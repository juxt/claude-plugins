# Clojure adapter

The Clojure / ClojureScript language adapter for the `code-map` skill. Follows the three-section contract in [README.md](./README.md). Covers Clojure (JVM), ClojureScript, Babashka and `.cljc` shared sources — clojure-lsp treats all four as one language with per-dialect reader conditionals.

## 1. Fingerprint

Activate this adapter if any of the following is present in the target project:

- `deps.edn` at the project root (Clojure CLI / `tools.deps`).
- `project.clj` at the project root (Leiningen).
- `build.boot` at the project root (Boot — legacy, still seen).
- `shadow-cljs.edn` at the project root (ClojureScript via shadow-cljs).
- `bb.edn` at the project root (Babashka script project).
- Any `**/*.{clj,cljs,cljc,edn,bb}` file inside the project root.

If both `deps.edn` and `project.clj` exist, prefer `deps.edn` as the authoritative manifest; many projects keep `project.clj` purely for editor tooling. If `shadow-cljs.edn` is present alongside `deps.edn`, the project is a mixed Clojure/ClojureScript build — the adapter still activates once and walks both source sets.

## 2. LSP plugin

**Plugin:** `clojure-lsp` (from JUXT's `juxt-plugins` marketplace — the official Anthropic marketplace does not currently ship a Clojure LSP plugin). Uses the upstream `clojure-lsp` server ([github.com/clojure-lsp/clojure-lsp](https://github.com/clojure-lsp/clojure-lsp)), which wraps [clj-kondo](https://github.com/clj-kondo/clj-kondo) for static analysis.

**Requirements:** The GraalVM-compiled native binary has no runtime dependencies. The JAR distribution requires JDK 11 or later on PATH. Either is acceptable; the native binary is faster to start and is recommended for Claude Code use.

**Install:**

```bash
# 1. Install clojure-lsp so the `clojure-lsp` binary resolves on PATH.
#    The Claude Code LSP tool spawns this binary from PATH.
#    macOS:    brew install clojure-lsp/brew/clojure-lsp-native
#    Linux:    bash < <(curl -s https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install)
#    Arch:     pacman -S clojure-lsp      (or yay -S clojure-lsp-bin)
#    Nix:      nix-env -iA nixpkgs.clojure-lsp
#    Other:    download the native zip from
#              https://github.com/clojure-lsp/clojure-lsp/releases
#              and place `clojure-lsp` on PATH.

# Verify:
which clojure-lsp    # must print a path
clojure-lsp --version

# 2. In Claude Code, add the JUXT marketplace and install the plugin:
/plugin marketplace add juxt/juxt-plugins
/plugin install clojure-lsp@juxt-plugins
```

After install, run `/reload-plugins` (or restart the session) and the built-in `LSP` tool will route `.clj`, `.cljs`, `.cljc`, `.edn` and `.bb` files to clojure-lsp.

**Caveat — project indexing cost.** clojure-lsp indexes the full classpath on first contact, resolving `deps.edn` / `project.clj` dependencies into a `.lsp/.cache/` directory. On a fresh clone, the first invocation can take 10–30 seconds while it fetches dependencies and runs clj-kondo across the project. Subsequent calls are fast because the cache is reused. If the sentinel call below times out the first time, retry after 15–30 seconds before concluding the LSP is broken. If `clojure -P` (or `lein deps`) has never been run for this project, do that first — the LSP cannot index unresolved dependencies.

**Caveat — reader conditionals.** `.cljc` files contain `#?(:clj ... :cljs ...)` blocks; clojure-lsp returns symbols for the dialect indicated by the file's context (deduced from `deps.edn` / `shadow-cljs.edn`). If a symbol is implemented behind a reader-conditional branch you cannot see (e.g. only the `:cljs` branch but the project is being probed as `:clj`), you may miss it. Record what comes back; do not guess at the other branch.

**Caveat — macro-heavy code.** Clojure relies heavily on macros (`defn`, `defroutes`, `defrecord`, `deftest`, `defmethod`, `defmulti`, `defschema`, custom DSLs). clj-kondo (and therefore clojure-lsp) reports macro-generated vars when it understands the macro; for unknown macros it either silently misses the vars or reports them with empty metadata. Most common macros have built-in clj-kondo support; project-specific DSLs may need `.clj-kondo/config.edn` hooks to be visible. Missing symbols from a custom macro are a tooling limitation — record what the LSP returns, do not fabricate.

**Caveat — single-file indexing is likely here too.** Treat the LSP tool as a single-file symbol oracle by default (same guidance as the Python, Java, TypeScript and Kotlin adapters). clojure-lsp is genuinely workspace-aware under normal editor use and `workspaceSymbol` queries do return project-wide results when the `.lsp/.cache/` is populated — but the Claude Code harness has only been verified in single-file mode to date. The code-map pipeline uses Glob + per-file `documentSymbol`; treat `workspaceSymbol` as a bonus signal if it works rather than a primary discovery mechanism.

**Sentinel:** open any `.clj` or `.cljs` file in the project and call `documentSymbol` on it. If clojure-lsp returns a non-empty symbol tree, the server is live. If the call errors with `Executable not found in $PATH`, `clojure-lsp` isn't installed — tell the user to run the install steps above. If it returns an empty or suspiciously shallow tree on a file that clearly contains `defn` / `defrecord` forms, the `.lsp/.cache/` is probably stale or missing — run `clojure -P` (or `lein deps`) in the project root, then retry.

## 3. Project-root rule

**Root discovery:** walk upward from the current working directory.

- If `deps.edn` is found, that directory is the root (tools.deps / Clojure CLI project). If `deps.edn` declares `:aliases` with `:local/root` dependencies, the referenced sub-projects have their own roots but participate in the same classpath — the top-level `deps.edn` directory remains the map root.
- Otherwise the first directory containing `project.clj` is the root (Leiningen). For multi-module Leiningen (`:sub` coordinates via lein-sub / lein-monolith), the topmost `project.clj` wins.
- Otherwise the first directory containing `build.boot` is the root.
- Otherwise the first directory containing `shadow-cljs.edn` is the root (ClojureScript-only project).
- Otherwise the first directory containing `bb.edn` is the root (Babashka-only project).
- Fallback: the first directory containing a `.git` folder.

**Source globs:**

- `src/**/*.{clj,cljs,cljc}` — Clojure / ClojureScript / shared sources (standard layout for tools.deps, Leiningen, and shadow-cljs).
- `src/main/clojure/**/*.clj` — Maven-style layout (seen when Clojure code is part of a larger JVM project; `clojure-maven-plugin`).
- `src/main/clojurescript/**/*.cljs` — same, ClojureScript counterpart.
- `dev/**/*.{clj,cljs,cljc}` — dev-only source directory (conventional in tools.deps projects with a `:dev` alias). Include only when the caller explicitly asks about dev-time behaviour.
- `script/**/*.bb`, `scripts/**/*.bb`, `bb/**/*.clj` — Babashka scripts when `bb.edn` is present.

Honour any `:paths` / `:source-paths` / `:extra-paths` declared in `deps.edn`, `project.clj`, or `shadow-cljs.edn` — they override the defaults above. A project that puts its sources under `core/` instead of `src/` is perfectly valid.

**Exclusions (always):**

- `test/**`, `src/test/**`, `**/*_test.{clj,cljs,cljc}`, `**/test_*.{clj,cljs,cljc}` — test sources (both by directory convention and `_test` filename suffix, which is the canonical `cljs.test` / `clojure.test` runner expectation).
- `target/**` — build output (Leiningen and tools.deps build tools both write here).
- `.cpcache/**` — tools.deps classpath cache.
- `.shadow-cljs/**`, `.clj-kondo/.cache/**`, `.lsp/.cache/**` — tooling caches.
- `classes/**`, `out/**` — AOT-compiled output / shadow-cljs build output.
- `node_modules/**` — present when a ClojureScript project has JS dependencies.
- `resources/public/js/**`, `public/js/**` — ClojureScript compilation artefacts.
- `.cljs_rhino_repl/**`, `.nrepl-port`, `.cider-repl-history` — REPL state.
- `pom.xml`, `pom.xml.asc` — Maven descriptors generated by `clj -T:build` (not hand-authored).
- Any path matched by the project's `.gitignore`.

**Depth:** default call-hierarchy expansion depth is 2. Stop when a call crosses into a dependency JAR or `node_modules` (for ClojureScript). Be aware of:

- **Vars vs functions.** Clojure vars are first-class: a `defn` defines a var bound to a fn, and call sites reference the var (late-bound). clojure-lsp reports the var declaration as the symbol; call-hierarchy resolves through the var. Treat `(my.ns/foo ...)` and `my.ns/foo` the same — both are edges to `foo`.
- **Multimethods.** `(defmulti name dispatch-fn)` creates one var; each `(defmethod name dispatch-val [...] body)` adds a method to that multimethod but does **not** create a new var. clojure-lsp reports the `defmethod` as an implementation of the multimethod var. Record each `defmethod` as a node that references the `defmulti`'s node ID via its `enclosing` field; annotate the dispatch value in the node's metadata when available.
- **Protocols.** `defprotocol` declares signatures; `extend-protocol`, `extend-type`, or `defrecord ... <Protocol>` provide implementations. clojure-lsp can surface these relationships via `goToImplementation`; use that to connect protocol methods to their implementations when building the call graph.
- **Macros that define vars.** `defn`, `defn-`, `def`, `defrecord`, `deftype`, `defprotocol`, `defmethod`, `defschema`, `defroutes`, `defresource`, `deftest`, and project-specific DSL macros (`reg-event-db` in re-frame, `defcomponent` in some Component-ish libs) each produce analysable symbols when clj-kondo understands the macro. Unknown macros silently drop their defined vars; when a symbol seems missing and you suspect macro hiding, check `.clj-kondo/config.edn` / `.clj-kondo/hooks/` — but record only what the LSP returned.
- **Anonymous inline fns (`#(...)`, `(fn [...] ...)`)** have no symbol; they are edges without endpoints. Record the enclosing named var as the edge participant.
- **Namespace aliases.** A namespace required as `[my.app.candidacy :as c]` is called as `(c/create ...)`. clojure-lsp resolves the alias; record the edge against the real namespace, not the alias.
