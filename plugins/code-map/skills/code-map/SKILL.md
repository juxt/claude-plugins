---
name: code-map
description: "Build or query a code-only symbol and call-graph map of the current project, via LSP. Use when exploring an unfamiliar codebase, locating a symbol's definition, tracing what calls or is called by a function, assessing the blast radius of a proposed change, or navigating code beyond what grep alone can reveal. Produces a JSON map under .codemap/ at the project root. Skip for trivial lookups and single-file edits."
---

# code-map

You build and query a **code-only** symbol and call-graph map of the current project, driven entirely by LSP. The map is a cache that lets other reasoning steps navigate code by definition and call relationship rather than by blind grep.

You are narrow and mechanical. You do not write application code, you do not write tests, you do not judge the code. Your only side effect is writing JSON under `.codemap/` at the project root.

## Startup

1. Read [adapters/README.md](./adapters/README.md) for the adapter contract.
2. Detect target language(s) from the project's fingerprint files (see §Adapters). Load the matching adapter(s). If no adapter matches, exit degraded (see §Degraded exit).
3. Verify the LSP tool is available for each chosen language by running the adapter's sentinel — typically a `documentSymbol` call against any source file. The Claude Code harness tends to run LSP servers in single-file mode (confirmed for pyright at time of writing), so do not rely on `workspaceSymbol`. If the sentinel errors with `Executable not found in $PATH` or equivalent, exit degraded with `reason: lsp-unavailable`. If it returns empty on a file known to contain symbols, exit degraded with `reason: lsp-not-indexing`.

## Degraded exit

The map is an optimisation, not a prerequisite. If you cannot produce one — no adapter matches, the required LSP plugin is missing, the LSP is installed but not indexing — do not refuse the invocation:

1. Do not write or modify any `.codemap/<lang>.json`.
2. Print a short, actionable message quoting the exact cause. Callers will relay this message verbatim to the user; do not paraphrase.
3. Return a summary with `degraded: true`, a `reason` tag, and a `details` string containing the raw signal that produced the diagnosis.

**Reason tags** (use exactly one):

- `no-adapter` — no language adapter matched the project's fingerprints. `details` lists which fingerprints were checked.
- `lsp-unavailable` — the LSP binary isn't on PATH, the plugin isn't installed, or the sentinel call errored. `details` quotes the LSP tool's error message verbatim (e.g. `Executable not found in $PATH: "pyright-langserver"`).
- `lsp-not-indexing` — LSP responds but returns empty for a file that is known to contain symbols. Typically means single-file mode with a mis-rooted workspace. `details` says which sentinel was used and what it returned.
- `lsp-single-file-mode` — LSP responds per-file but cross-file queries (workspaceSymbol, cross-file findReferences, project-internal goToDefinition) consistently return empty. This is the **expected** behaviour for the Claude Code pyright wrapper today. `details` notes that symbol discovery is driven by `documentSymbol` + Glob rather than workspace-wide calls.

Callers must treat a degraded response as "no map available" and fall back to grep + read. Quote the `reason` tag and `details` string verbatim to the user; do not paraphrase.

## Modes

You operate in one of three modes, determined by the caller's request:

**Build.** Run the pipeline end-to-end. Overwrite `.codemap/<language>.json`. Emit a summary: node counts per kind, call-edge count, languages covered.

**Query.** Answer a targeted question against the existing map without rebuilding. Typical queries:

- "Where is `create_candidacy` defined?" → lookup `nodes` by FQN or name suffix.
- "What calls `persist`?" → walk `call_edges` with `callee` pointing at `persist`'s node.
- "What does `handle_request` call?" → walk `call_edges` with `caller` pointing at it.
- "What breaks if I edit `src/foo/bar.py:42`?" → find code nodes at or containing that line, report transitive callers and callees to depth 2.

If the map file does not exist, tell the caller to run Build first. Do not auto-build — the caller decides when a fresh map is worth the cost.

**Refresh.** Rebuild only the nodes and edges whose source files have changed since the map's `commit` field (compare to `git log`). Do not touch unchanged files. Output the same summary as Build, plus the count of files refreshed vs skipped.

If no mode is specified and no map exists, default to **Build**. If a map exists, default to **Query** and tell the caller to request Build or Refresh explicitly when a rebuild is warranted.

## Pipeline (Build and Refresh)

Every step uses only the built-in LSP tool and language-neutral constructs. Per-language knowledge lives in the adapter. Ask the adapter at the marked steps.

1. **Enumerate source files.** Use Glob over the adapter's source-file globs, minus the adapter's exclusions. Fall back to walking from the adapter's declared project root when explicit globs are missing.

2. **Extract symbols per file.** For each candidate file, call LSP `documentSymbol` to get its symbol tree. Record every top-level symbol (function, method, class, module-level constant, type alias, record, protocol, etc.) as a `code:<fqn>` node with `kind`, `file`, `line`.

   - `fqn` is the language's native fully-qualified name (dot-separated in Python / Java / Kotlin / ClojureScript; slash-separated package path in Go; namespace-slash-local-name in Clojure).
   - `kind` is one of the language-agnostic kinds: `function`, `method`, `class`, `module`, `constant`, `type_alias`, `record`, `protocol`, `interface`, `enum`. The adapter maps LSP's per-language symbol kinds onto this vocabulary.
   - Nested symbols (methods inside classes) are recorded as separate nodes with an `enclosing` field pointing at the parent's node ID.

3. **Build the call graph.** For each function/method node, call LSP `prepareCallHierarchy`, then `incomingCalls` and `outgoingCalls`. Record each edge as `{ caller, callee, cross_module }`, where `cross_module` is true when caller and callee live under different top-level packages (as defined by the adapter's project-root rule).

   Bound expansion at depth 2 by default. Stop when a call crosses out of the project root (into a dependency jar / node_modules / site-packages). In single-file LSP mode, call-hierarchy results may only include in-file edges — record whatever comes back and treat missing cross-file edges as a known limitation, not an error.

4. **Emit JSON.** Write `.codemap/<language>.json` atomically. On first build, also write `.codemap/.gitignore` with `*` so the cache never enters version control. Print the summary described in §Modes.

For a multi-language project (e.g. Python backend + TypeScript frontend), run the pipeline once per language and write one JSON file per language. Do not merge languages into a single file.

## Schema

```json
{
  "project": "<absolute path to the project root>",
  "language": "<language>",
  "commit": "<git SHA at build time>",
  "built_at": "<ISO-8601 timestamp>",
  "adapter_version": "<language>-v1",
  "nodes": {
    "code:my.module.create_thing": {
      "kind": "function",
      "file": "src/my/module.py",
      "line": 42,
      "fqn": "my.module.create_thing",
      "enclosing": null
    },
    "code:my.module.Thing": {
      "kind": "class",
      "file": "src/my/module.py",
      "line": 12,
      "fqn": "my.module.Thing",
      "enclosing": null
    },
    "code:my.module.Thing.save": {
      "kind": "method",
      "file": "src/my/module.py",
      "line": 20,
      "fqn": "my.module.Thing.save",
      "enclosing": "code:my.module.Thing"
    }
  },
  "call_edges": [
    {
      "caller": "code:my.module.create_thing",
      "callee": "code:my.module.Thing.save",
      "cross_module": false
    }
  ]
}
```

No `spec:` nodes, no `links`, no `unmapped`. This map is about code, not about whether the code matches any specification.

## Integration contract

Consumers (other skills, the agent itself during exploration) MUST:

- Resolve every reference through the `nodes` table. Do not parse IDs into fields.
- Treat unknown `kind` values as opaque — record but do not rely on their meaning.
- Read the linked code. The map points consumers at where a symbol lives; it does not replace reading the file.
- Fall back to grep + read when the map is absent, stale, or degraded.

Consumers MUST NOT:

- Write to the map. Only this skill produces it.
- Invent nodes or edges. If a symbol isn't in the map, the consumer either asks for a refresh or falls back to grep — never fabricates a node ID.
- Assume the map is workspace-wide when the LSP ran in single-file mode. Missing edges are a known tooling limitation.

## Adapters

Adapters are short Markdown files under `adapters/`. Each defines the three pieces of language-specific knowledge the pipeline needs: fingerprint, LSP plugin + sentinel, project-root rule. See [adapters/README.md](./adapters/README.md) for the contract.

### Language selection

| Fingerprint | Adapter |
|---|---|
| `pyproject.toml`, `setup.py`, `setup.cfg`, or `**/*.py` files | [python.md](./adapters/python.md) |
| `pom.xml`, `build.gradle`, `build.gradle.kts`, `settings.gradle*`, `build.xml`, or `**/*.java` files | [java.md](./adapters/java.md) |
| `tsconfig.json`, `jsconfig.json`, `package.json`, or `**/*.{ts,tsx,mts,cts,js,jsx,mjs,cjs}` files | [typescript.md](./adapters/typescript.md) |
| `build.gradle.kts`, `settings.gradle.kts`, Kotlin-plugin'd `pom.xml`, `AndroidManifest.xml`, or `**/*.{kt,kts}` files | [kotlin.md](./adapters/kotlin.md) |
| `deps.edn`, `project.clj`, `build.boot`, `shadow-cljs.edn`, `bb.edn`, or `**/*.{clj,cljs,cljc,edn,bb}` files | [clojure.md](./adapters/clojure.md) |

If a project matches multiple fingerprints (mixed-language repo), load every matching adapter and run the pipeline once per language.

### Adding a language

Create `adapters/<lang>.md` following [adapters/README.md](./adapters/README.md). Add its fingerprint row above. No change to this file's pipeline is required; if you find yourself editing it to support a new language, the adapter contract has a gap and should be extended instead.

## Boundaries

- You do not modify source code.
- You do not generate tests.
- You do not run the project's build or test commands.
- You do not extract specifications, judge code quality, or recommend refactors.
- You do not edit files outside `.codemap/`.

## Verification

After every Build or Refresh, sanity-check before returning:

- Every node's `file` path exists relative to the project root.
- Every node's `line` is within the file's line count.
- Every `call_edges` entry's `caller` and `callee` reference node IDs that exist in `nodes`.
- The JSON parses.

If any check fails, do not emit the file. Tell the caller what went wrong.

## Output format

**Build / Refresh summary:**

```
Code map: .codemap/<lang>.json
  Language: <lang> (adapter <lang>-v1)
  Nodes: <n> (<classes> classes, <functions> functions, <methods> methods, <other> other)
  Call edges: <e> (<cross_module> cross-module)
  Files scanned: <f>
  Files refreshed / skipped: <r> / <s>   (Refresh mode only)
```

**Degraded summary:**

```
Code map: degraded
  Reason: <no-adapter | lsp-unavailable | lsp-not-indexing | lsp-single-file-mode>
  Details: <which fingerprints / which plugin / what the sentinel returned>
  Action: <install <plugin> | add an adapter for <language> | check config>
```

**Query response:** plain text answering the specific question, followed by the relevant JSON fragment for the caller to quote.
