# zed-just

[Just](https://github.com/casey/just) language support for the [Zed](https://zed.dev) editor.

## Features

- Syntax highlighting via tree-sitter
- Language server support with [just-lsp](https://github.com/warrenbhw/just-lsp)
  - Hover documentation
  - Diagnostics
  - Formatting
- Run recipes directly from the editor

## Modern Just support

This fork pairs the grammar bundled with the patched `just-lsp` revision in
`extension.toml` with server release **0.9.1**. It supports native `[arg(...)]`
flags/options, attributes on modules, and qualified recipe dependencies such as
`check: (linting::all 'true')`. Module recipes resolve in their own import scope;
nested modules and unsaved module edits are supported. Missing recipes still
produce diagnostics.

The grammar and server are pinned together deliberately. Updating only the
highlighting grammar does not fix the upstream server's missing-recipe errors.

## Install in Zed

1. Clone this fork into a permanent local directory:

   ```sh
   git clone https://github.com/warrenbhw/zed-just.git
   ```

2. In Zed's Extensions view, choose **Install Dev Extension** and select that
   directory. This uses the same `just` extension ID as upstream.
3. Restart the Just language server or reload Zed after installation.

The extension builds with Rust's `wasm32-wasip2` target. If needed, install it
with `rustup target add wasm32-wasip2`.

The patched server is automatically downloaded on **Apple Silicon macOS**.
The fork release currently only ships that platform's binary. On other platforms,
build the server and put it on Zed's PATH as `just-lsp-mesa`:

```sh
git clone --branch 0.9.1 https://github.com/warrenbhw/just-lsp.git
cd just-lsp
cargo build --release --locked
# Install target/release/just-lsp as just-lsp-mesa in a directory on PATH.
# On Windows, use target/release/just-lsp.exe and just-lsp-mesa.exe.
```

A plain `just-lsp` on PATH is not used, to avoid silently selecting an older
upstream binary. No diagnostics are disabled by this extension.

## Validation

```sh
cargo build --locked
just --justfile tests/modern.justfile --dry-run check
```

The patched server contains regression tests for module resolution and live
LSP diagnostics. In its checkout, run:

```sh
cargo test --locked
ZED_JUST_EXTENSION=/absolute/path/to/zed-just \
  cargo test --test zed_queries -- --ignored
```

The latter compiles every Zed Tree-sitter query against the pinned grammar and
parses the modern-syntax fixtures in this extension. It catches query/grammar
mismatches as well as unsupported syntax.
