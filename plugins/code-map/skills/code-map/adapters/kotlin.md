# Kotlin adapter

The Kotlin language adapter for the `code-map` skill. Follows the three-section contract in [README.md](./README.md).

## 1. Fingerprint

Activate this adapter if any of the following is present in the target project:

- `build.gradle.kts` at the project root with the Kotlin plugin applied (`kotlin("jvm")`, `kotlin("multiplatform")`, `kotlin("android")`).
- `settings.gradle.kts` at the project root (Kotlin-DSL Gradle root, common for Kotlin-native projects).
- `pom.xml` at the project root declaring `kotlin-maven-plugin` (Kotlin-on-Maven, rarer).
- `AndroidManifest.xml` and `build.gradle.kts` / `build.gradle` (Android Kotlin project).
- Any `**/*.{kt,kts}` file inside the project root.

For mixed Kotlin/Java projects, load both adapters — many Spring / Android / server-side Kotlin codebases have `.java` sources alongside `.kt`. The Java adapter's Gradle / Maven project-root rules apply unchanged.

## 2. LSP plugin

**Plugin:** `kotlin-lsp` (from Anthropic's `claude-plugins-official` marketplace). Uses JetBrains' official Kotlin LSP server ([github.com/Kotlin/kotlin-lsp](https://github.com/Kotlin/kotlin-lsp)), not the community fwcd/kotlin-language-server.

**Requirements:** JDK 17 or later on PATH (`java -version`). The LSP server runs on the JVM. If a Java adapter is already active, the JDK requirement is shared.

**Install:**

```bash
# 1. Install JDK 17+ if you don't already have one (see the Java adapter
#    for detailed JDK install options; any working JDK 17+ satisfies both).
#    Verify: java -version

# 2. Install the Kotlin LSP binary so that `kotlin-lsp` resolves on the
#    global PATH. The Claude Code LSP tool spawns this binary from PATH.
#    macOS: brew install JetBrains/utils/kotlin-lsp
#    Other: download from https://github.com/Kotlin/kotlin-lsp/releases
#           and place the launcher on your PATH.

# Verify:
which kotlin-lsp     # must print a path
which java           # must print a path

# 3. In Claude Code, add the marketplace and install the plugin:
/plugin marketplace add anthropics/claude-plugins-official
/plugin install kotlin-lsp
```

After install, run `/reload-plugins` (or restart the session) and the built-in `LSP` tool will route `.kt` and `.kts` files to the Kotlin LSP server.

**Caveat — first-invocation cost.** Like JDT.LS, the Kotlin LSP indexes the Gradle / Maven classpath on cold start. For a project with Kotlin compiler plugins (KSP, kapt, serialisation) and many Gradle modules, expect a multi-second first-response delay. Retry once after 10–15 seconds before concluding the LSP is broken.

**Caveat — Gradle-KTS interpretation.** The LSP runs Gradle to resolve dependencies. If the project has compile errors in its `build.gradle.kts` or hasn't fetched dependencies, the LSP will report degraded symbol information. `./gradlew help` (or `build`) should succeed before running the code-map pipeline on a fresh clone.

**Caveat — single-file indexing is likely here too.** Treat the LSP tool as a single-file symbol oracle by default (same guidance as the Python and Java adapters). The code-map pipeline uses Glob + per-file `documentSymbol`; do not rely on `workspaceSymbol` without empirically confirming it works for your setup.

**Sentinel:** open any `.kt` file in the project and call `documentSymbol` on it. If the LSP returns a non-empty symbol tree, the server is live. If the call errors with `Executable not found in $PATH`, `kotlin-lsp` isn't installed. If it errors on JDK version, JDK 17+ isn't the one on PATH. If it returns a nearly empty tree on a file that clearly has classes, the project probably hasn't had dependencies resolved yet — run `./gradlew help` first.

## 3. Project-root rule

**Root discovery:** walk upward from the current working directory.

- If a `settings.gradle.kts` or `settings.gradle` is found, that directory is the root (Gradle multi-module). This covers the majority of modern Kotlin projects.
- Otherwise the first directory containing `build.gradle.kts` or `build.gradle` is the root.
- Otherwise the first directory containing `pom.xml` is the root (Kotlin-on-Maven).
- For Android projects, the project root is the directory containing `settings.gradle*` — not an individual app module (`app/`, `library/`).
- Fallback: the first directory containing a `.git` folder.

**Source globs:**

- `src/main/kotlin/**/*.kt` — Gradle standard layout.
- `src/main/java/**/*.kt` — some Kotlin projects colocate `.kt` files under `src/main/java` (valid; Gradle accepts it).
- `*/src/main/kotlin/**/*.kt` at the root, recursing into each module (multi-module).
- Kotlin Multiplatform: `src/commonMain/kotlin/**/*.kt`, `src/jvmMain/kotlin/**/*.kt`, `src/androidMain/kotlin/**/*.kt`, `src/nativeMain/kotlin/**/*.kt` — all are first-class source sets. Walk each source set the project actually declares.
- Android: `app/src/main/kotlin/**/*.kt`, `app/src/main/java/**/*.kt` (Android tolerates both), plus per-flavor source sets if the project uses product flavors.

**Exclusions (always):**

- `src/test/**`, `src/androidTest/**`, `src/integrationTest/**`, `src/functionalTest/**` — test sources.
- `target/**`, `build/**`, `out/**`, `.gradle/**` — build outputs and Gradle cache.
- `build/generated/**`, `build/tmp/**`, `build/intermediates/**` — annotation-processor / KSP / kapt / Android codegen output.
- `**/generated/**`, `**/*.kt.generated` — other codegen paths.
- `.idea/**`, `.settings/**`, `*.iml`, `local.properties`, `gradle.properties` — IDE / local-only metadata.
- `**/*.class`, `**/*.jar`, `**/*.aar` — compiled artefacts.
- `buildSrc/**` — Gradle build logic, not application behaviour (include only if the caller is explicitly asking about build logic).
- Any path matched by the project's `.gitignore`.

**Depth:** default call-hierarchy expansion depth is 2. Stop when a call crosses into a dependency JAR or the Kotlin standard library (`kotlin.*`, `kotlinx.*`). Be aware of:

- **Extension functions** may appear as methods on the receiver type in LSP results — prefer the file where the extension is declared.
- **Top-level functions** in Kotlin have no enclosing class; the LSP reports them as file-level symbols. Record the file + line, not a synthetic class name.
- **Companion objects** expose their members under `<Name>.Companion`; the LSP usually shows them as static-like. Prefer the declaring class's FQN with `.Companion.` in the path.
- **Inline functions** may be source-inlined at call sites; call-hierarchy results can be noisy. Treat inline-function call sites as valid edges.
