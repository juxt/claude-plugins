# TypeScript adapter

The TypeScript / JavaScript language adapter for the `code-map` skill. Follows the three-section contract in [README.md](./README.md). Covers both TypeScript and JavaScript projects — the LSP treats `.js` / `.jsx` as untyped TS.

## 1. Fingerprint

Activate this adapter if any of the following is present in the target project:

- `tsconfig.json` at the project root (TypeScript).
- `jsconfig.json` at the project root (type-checked JavaScript).
- `package.json` at the project root with a `typescript` dependency (direct or indirect).
- Any `**/*.{ts,tsx,mts,cts}` file inside the project root.
- `package.json` at the project root plus any `**/*.{js,jsx,mjs,cjs}` file (fallback for plain JS projects).

For monorepos — workspaces declared in `package.json`, pnpm `pnpm-workspace.yaml`, Nx, Turborepo, Lerna — the project root is the top-level workspace root, and per-package `tsconfig.json` files are loaded as sub-project boundaries.

## 2. LSP plugin

**Plugin:** `typescript-lsp` (from Anthropic's `claude-plugins-official` marketplace). Uses `typescript-language-server` on top of the `typescript` package's `tsserver`.

**Requirements:** Node.js and npm (or yarn / pnpm) on PATH.

**Install:**

```bash
# 1. Install the language server and the TypeScript package globally so
#    `typescript-language-server` resolves on the global PATH. The
#    Claude Code LSP tool spawns this binary from PATH — project-local
#    installs under node_modules/.bin will NOT be picked up.
npm install -g typescript-language-server typescript

# (yarn global add and pnpm add -g also work, provided their global
#  bin directory is on PATH.)

# Verify:
which typescript-language-server   # must print a path
which node                         # must print a path

# 2. In Claude Code, add the marketplace and install the plugin:
/plugin marketplace add anthropics/claude-plugins-official
/plugin install typescript-lsp
```

After install, run `/reload-plugins` (or restart the session) and the built-in `LSP` tool will route TypeScript and JavaScript files to the server.

**Caveat — tsconfig awareness.** `typescript-language-server` spawns a `tsserver` process that reads the nearest `tsconfig.json` / `jsconfig.json` walking up from the opened file. If a file lives outside every `tsconfig.json`'s `include` / `files` list, tsserver will report it as loose-mode (no type information, limited symbol intelligence). When walking project files, avoid pointing the LSP at files that are `exclude`d from the nearest `tsconfig.json` — they'll return degraded results.

**Caveat — single-file indexing is likely here too.** Treat the LSP tool as a single-file symbol oracle by default (same guidance as the Python adapter). `tsserver` is more workspace-aware than pyright under normal IDE usage, but the Claude Code harness has only been verified in single-file mode. The code-map pipeline uses Glob + per-file `documentSymbol`; do not rely on `workspaceSymbol` without empirically confirming it works for your setup.

**Sentinel:** open any `.ts` or `.tsx` file in the project and call `documentSymbol` on it. If tsserver returns a non-empty symbol tree, the server is live. If the call errors with `Executable not found in $PATH`, the language server isn't installed — tell the user to run the install steps above. If it returns a minimal tree for a file that clearly has classes or exports, the file is likely outside the project's `tsconfig.json` scope.

## 3. Project-root rule

**Root discovery:** walk upward from the current working directory.

- If a `pnpm-workspace.yaml`, a `package.json` with a `workspaces` field, or an `nx.json` / `turbo.json` is found, that directory is the monorepo root. Per-package `tsconfig.json` files remain sub-project boundaries.
- Otherwise the first directory containing `tsconfig.json` or `jsconfig.json` is the project root.
- Otherwise the first directory containing `package.json` is the root.
- Fallback: the first directory containing a `.git` folder.

**Source globs:**

- If `tsconfig.json` declares `include` / `files`, honour them.
- Otherwise default to `src/**/*.{ts,tsx,mts,cts}` and `<root>/**/*.{ts,tsx}`.
- For Next.js: `pages/**/*.{ts,tsx}` and `app/**/*.{ts,tsx}` in addition to `src/**`.
- For monorepos: `packages/*/src/**/*.{ts,tsx}`, `apps/*/src/**/*.{ts,tsx}`, or whatever the `workspaces` glob declares.

**Exclusions (always):**

- `node_modules/**` — dependency code.
- `dist/**`, `build/**`, `out/**`, `.next/**`, `.nuxt/**`, `.turbo/**`, `.vercel/**` — build outputs.
- `coverage/**` — test-coverage reports.
- `**/*.test.{ts,tsx,js,jsx}`, `**/*.spec.{ts,tsx,js,jsx}`, `**/__tests__/**`, `**/__mocks__/**` — test code and mocks.
- `**/*.d.ts` — ambient type declarations (unless the project's own `.d.ts` files are load-bearing behaviour).
- `**/*.stories.{ts,tsx,js,jsx}`, `**/*.mdx` — Storybook / MDX.
- `**/*.generated.{ts,tsx}`, `**/generated/**` — GraphQL / OpenAPI / Prisma / Protobuf codegen output.
- Any path matched by the project's `.gitignore`.

**Depth:** default call-hierarchy expansion depth is 2. Stop when a call crosses into `node_modules`. Note: barrel re-exports (`export * from "./foo"`) can inflate reference counts; prefer the declared source of a symbol over its re-export sites when recording nodes.
