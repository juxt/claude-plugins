# clojure-lsp

Clojure / ClojureScript language server for Claude Code, providing code intelligence, refactoring, and analysis. Backed by [clojure-lsp](https://github.com/clojure-lsp/clojure-lsp), which wraps [clj-kondo](https://github.com/clj-kondo/clj-kondo) for static analysis.

## Supported extensions

`.clj`, `.cljs`, `.cljc`, `.edn`, `.bb`

## Installation

Install the GraalVM-native binary so `clojure-lsp` resolves on PATH. The Claude Code LSP tool spawns this binary from PATH.

```bash
# macOS
brew install clojure-lsp/brew/clojure-lsp-native

# Linux (installs into ~/.local/bin with --dir, or /usr/local/bin by default)
bash < <(curl -sL https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install) --dir ~/.local/bin

# Arch
pacman -S clojure-lsp   # or: yay -S clojure-lsp-bin

# Nix
nix-env -iA nixpkgs.clojure-lsp
```

Verify:

```bash
which clojure-lsp
clojure-lsp --version
```

## First-invocation cost

clojure-lsp indexes the project's classpath on first contact, writing to `.lsp/.cache/`. On a fresh clone expect 10–30 seconds of cold-start cost while it fetches dependencies and runs clj-kondo across the project. If `clojure -P` (or `lein deps`) has never been run for this project, do that first — the LSP cannot index unresolved dependencies.

## More information

- [clojure-lsp docs](https://clojure-lsp.io/)
- [clojure-lsp on GitHub](https://github.com/clojure-lsp/clojure-lsp)
- [clj-kondo on GitHub](https://github.com/clj-kondo/clj-kondo)
