# Java adapter

The Java language adapter for the `code-map` skill. Follows the three-section contract in [README.md](./README.md).

## 1. Fingerprint

Activate this adapter if any of the following is present in the target project:

- `pom.xml` at the project root (Maven).
- `build.gradle`, `build.gradle.kts`, or `settings.gradle` / `settings.gradle.kts` at the project root (Gradle, including multi-module).
- `build.xml` at the project root (Ant — rare, legacy).
- Any `**/*.java` file inside the project root (fallback for manifest-less projects).

For multi-module builds, the project root is the directory of the **top-level** `pom.xml` or `settings.gradle*` — not an individual module's manifest.

## 2. LSP plugin

**Plugin:** `jdtls-lsp` (from Anthropic's `claude-plugins-official` marketplace). Uses Eclipse JDT.LS.

**Requirements:** Java 17 or later (JDK, not JRE) must be on PATH. `java -version` should print `openjdk version "17"` or higher.

**Install:**

```bash
# 1. Install JDK 17+ if you don't already have one.
#    macOS:    brew install openjdk@17
#    Ubuntu:   apt install openjdk-17-jdk
#    SDKMAN:   sdk install java 21-tem
#    Verify:   java -version

# 2. Install jdtls so that `jdtls` resolves on the global PATH. The
#    Claude Code LSP tool spawns this binary from PATH.
#    macOS:    brew install jdtls
#    Arch:     yay -S jdtls   (AUR)
#    Other:    download from https://download.eclipse.org/jdtls/snapshots/
#              extract to e.g. ~/.local/share/jdtls, then create a
#              wrapper script named `jdtls` on your PATH.

# Verify:
which jdtls       # must print a path
which java        # must print a path

# 3. In Claude Code, add the marketplace and install the plugin:
/plugin marketplace add anthropics/claude-plugins-official
/plugin install jdtls-lsp
```

After install, run `/reload-plugins` (or restart the session) and the built-in `LSP` tool will route Java files to JDT.LS.

**Caveat — first-invocation cost.** JDT.LS has a substantially higher cold-start cost than pyright: it indexes the project's classpath (Maven/Gradle dependencies, target/build outputs, generated sources) on first contact. Expect a multi-second delay on the first `documentSymbol` or `hover` call in a fresh session. Subsequent calls are fast. If the sentinel call below times out the first time, retry after 10–15 seconds before concluding the LSP is broken.

**Caveat — single-file indexing is likely here too.** Treat the LSP tool as a single-file symbol oracle by default (same guidance as the Python adapter). JDT.LS is more workspace-aware than pyright under normal usage, but the Claude Code harness has only been verified in single-file mode. The code-map pipeline uses Glob + per-file `documentSymbol`; do not rely on `workspaceSymbol` without empirically confirming it works for your setup.

**Sentinel:** open any `.java` file in the project and call `documentSymbol` on it. If JDT.LS returns a non-empty symbol tree, the server is live. If the call errors with `Executable not found in $PATH`, jdtls isn't installed — tell the user to run the install steps above. If it errors with a JDK-version message, Java 17+ isn't installed or isn't the one on PATH.

## 3. Project-root rule

**Root discovery:** walk upward from the current working directory.

- If a `settings.gradle` or `settings.gradle.kts` is found, that directory is the root (multi-module Gradle).
- Otherwise the first directory containing `pom.xml` is the root — but for Maven multi-module, continue walking up: the topmost `pom.xml` whose `<packaging>` is `pom` wins. If none have `pom` packaging, the deepest-located `pom.xml` on the walk wins.
- Otherwise the first directory containing `build.gradle` / `build.gradle.kts` / `build.xml` is the root.
- Fallback: the first directory containing a `.git` folder.

**Source globs:**

- `src/main/java/**/*.java` (Maven and Gradle standard layout).
- For multi-module: `*/src/main/java/**/*.java` at the root, recursing into each module.
- Kotlin-mixed projects: also include `src/main/kotlin/**/*.kt` if the Kotlin adapter is not loaded; Kotlin call sites into Java types are resolvable by JDT.LS in many setups but the adapter's primary source remains `.java`.

**Exclusions (always):**

- `src/test/**`, `src/integrationTest/**` — test sources.
- `target/**` — Maven build output.
- `build/**`, `out/**` — Gradle / IntelliJ build output.
- `target/generated-sources/**`, `build/generated/**`, `**/generated/**` — annotation-processor and code-generator output (Lombok, MapStruct, Protobuf, QueryDSL).
- `.idea/**`, `.settings/**`, `.project`, `.classpath`, `*.iml` — IDE metadata.
- `**/*.class`, `**/*.jar`, `**/*.war`, `**/*.ear` — compiled artefacts.
- Any path matched by the project's `.gitignore`.

**Depth:** default call-hierarchy expansion depth is 2. Stop when a call crosses into a dependency JAR (anything outside the project's source set). Be aware that Lombok-generated methods (`getX`, `setX`, `builder()`) may appear as synthetic symbols — prefer the declaring field over the synthetic accessor when recording nodes.
