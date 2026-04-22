# Python adapter

The Python language adapter for the `code-map` skill. Follows the three-section contract in [README.md](./README.md).

## 1. Fingerprint

Activate this adapter if any of the following is present in the target project:

- `pyproject.toml` at the project root.
- `setup.py` or `setup.cfg` at the project root.
- Any `**/*.py` file inside the project root (fallback for scripts-only projects with no packaging manifest).

## 2. LSP plugin

**Plugin:** `pyright-lsp` (from Anthropic's `claude-plugins-official` marketplace).

**Install:**

```bash
# 1. Install pyright so that `pyright-langserver` resolves on the global
#    PATH. The Claude Code LSP tool spawns this binary from PATH — it
#    does not inspect per-project venvs — so `uv pip install pyright`
#    inside a project venv will NOT work for Claude Code:
uv tool install pyright

# (pip install pyright and npm install -g pyright also work, provided
#  their install location ends up on PATH.)

# Verify:
which pyright-langserver   # must print a path

# 2. In Claude Code, add the marketplace and install the plugin:
/plugin marketplace add anthropics/claude-plugins-official
/plugin install pyright-lsp
```

After install, run `/reload-plugins` (or restart the session) and the built-in `LSP` tool will route Python files to pyright.

**Caveat — single-file indexing:** In the Claude Code harness, pyright runs per invocation against the file passed in `filePath`; it does not index the wider workspace. Empirically:

- `documentSymbol` and `hover` return the expected per-file results.
- `findReferences` only returns hits in the single file, not across the workspace.
- `workspaceSymbol` returns empty.
- Cross-file `goToDefinition` does not resolve project-internal imports (they appear as `reportMissingImports`).

Treat the LSP tool as a **single-file symbol and type oracle**, not a workspace index. The code-map pipeline reflects this: symbol discovery uses Glob + per-file `documentSymbol`, not `workspaceSymbol`. Call-hierarchy results may be incomplete across files; record what comes back and accept the gap.

**Sentinel:** open any `.py` file in the project and call `documentSymbol` on it. If pyright returns a non-empty symbol tree, the LSP server is live. If the call errors with `Executable not found in $PATH`, pyright is not installed — tell the user to run the install steps above.

## 3. Project-root rule

**Root discovery:** walk upward from the current working directory. The first directory containing `pyproject.toml`, `setup.py` or `setup.cfg` is the project root. If none is found, use the first directory containing a `.git` folder.

**Source globs:**

- If `pyproject.toml` declares `[tool.setuptools.packages.find]` or `[tool.poetry]` packages, use those package directories.
- Otherwise default to `src/**/*.py` and `<root>/**/*.py`.

**Exclusions (always):**

- `tests/**`, `test/**`, `**/test_*.py`, `**/*_test.py`, `**/conftest.py` — test code.
- `.venv/**`, `venv/**`, `env/**` — virtual environments.
- `build/**`, `dist/**`, `*.egg-info/**` — build artefacts.
- `__pycache__/**`, `*.pyc`.
- Any path matched by the project's `.gitignore`.
- `migrations/**` when using Django or Alembic — these are generated from models, not hand-authored behaviour.

**Depth:** default call-hierarchy expansion depth is 2. Stop when a call crosses into a third-party package (imports from outside the project root).
