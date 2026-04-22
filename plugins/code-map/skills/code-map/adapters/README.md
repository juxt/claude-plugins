# code-map language adapters

A language adapter tells the `code-map` skill how to discover source files and verify the LSP in a particular language. The skill's pipeline is language-agnostic; everything that varies between Python, Java, TypeScript, Kotlin, Clojure, etc. lives here.

Adapters are Markdown files interpreted by the LLM, not compiled code. Consistency comes from following the three sections below in the same order. Do not invent additional sections.

## Adding a new adapter

Create `adapters/<language>.md` with exactly these three sections, in order. Then add a fingerprint row to the table in [../SKILL.md](../SKILL.md) under "Language selection".

### 1. Fingerprint

How to tell this language is in use in the target project. List the files and globs the skill should check. If any match, this adapter activates.

Example (Python):

> - Presence of `pyproject.toml`, `setup.py` or `setup.cfg` at the project root.
> - Any `**/*.py` file inside the project root.

### 2. LSP plugin

Which Claude Code LSP plugin the skill must have installed. Name the plugin exactly as it appears in the marketplace. Include install commands for the common platforms. Supply a sentinel query that confirms the LSP is live before the pipeline runs — typically a `documentSymbol` call against any source file. Do not specify sentinels that require `workspaceSymbol`, since the Claude Code harness tends to run LSP servers in single-file mode.

Example (Python):

> **Plugin:** `pyright-lsp`.
>
> **Sentinel:** open any `.py` file in the project and call `documentSymbol` on it. If pyright returns a non-empty symbol tree, the server is live.

### 3. Project-root rule

What counts as "inside the project" when the pipeline bounds call-hierarchy expansion and source-file enumeration. The adapter names:

- **Root discovery** — which manifest file(s) or directory marker defines the root, and the walk-up rules for multi-module builds.
- **Source globs** — which file patterns count as project source (with any framework- or tooling-specific additions).
- **Exclusions** — directories and file patterns to skip unconditionally: tests, build output, vendor dirs, generated code, IDE metadata, anything on `.gitignore`.
- **Depth** — the default call-hierarchy expansion depth and any language-specific caveats about symbol visibility (Lombok, extension functions, multimethods, etc.).

## Things adapters must not do

- Do not define the JSON schema. That is fixed in [../SKILL.md](../SKILL.md).
- Do not reimplement pipeline steps. That is fixed in [../SKILL.md](../SKILL.md).
- Do not add name-variant generators, surface-pattern tables, or confidence heuristics. Those were needed when the pipeline mapped to a specification; the code-only map does not.
- Do not add application-specific rules (e.g. "in this repo, handlers live in `handlers/`"). That is a project-level concern, not a language adapter.

If you find yourself wanting to add a fourth section, something is wrong with the pipeline's decomposition. Raise it rather than forking the contract.
