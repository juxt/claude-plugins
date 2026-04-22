# JUXT Claude Code Plugins

A plugin marketplace for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Installation

```
/plugin marketplace add juxt/claude-plugins
```

Then install individual plugins:

```
/plugin install allium
```

## Available plugins

Once the marketplace is added, you can install any of the following:

- **[Allium](https://juxt.github.io/allium/)**: an LLM-native behavioural specification language.
- **[Chalk](plugins/chalk/)**: GitHub Issue-backed agent session memory. Like [beads](https://github.com/steveyegge/beads) but uses GitHub Issues as the storage backend.
- **[Chill](plugins/chill/)**: a circuit-breaker skill that interrupts forward momentum when Claude is spinning, scope-creeping, or pushing through errors.
- **[Clojure-lsp](plugins/clojure-lsp/)**: Clojure / ClojureScript language server (clojure-lsp + clj-kondo) for code intelligence, refactoring, and analysis.
- **[Code-map](plugins/code-map/)**: build and query a code-only LSP-based symbol and call-graph map of the current project. A navigation accelerator for multi-file code reasoning.
- **[Glance](https://github.com/juxt/glance)**: pipe long command output through glance for token-efficient summaries.

Each plugin is open source. Visit the links above for documentation and examples.

## Copyright & License

The MIT License (MIT)

Copyright © 2026 JUXT Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
