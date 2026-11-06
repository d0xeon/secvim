# Language Support

Secvim provides a complete development environment for many languages out of the box. This guide details the tooling configured for each language and how to add support for new ones.

## Table of Contents

- [TypeScript / JavaScript / React](#typescript--javascript--react)
- [Go](#go)
- [Rust](#rust)
- [C / C++](#c--c)
- [Solidity](#solidity)
- [Python](#python)
- [Java](#java)
- [PHP / Laravel](#php--laravel)
- [HTML / CSS / Tailwind](#html--css--tailwind)
- [SQL](#sql)
- [Lua](#lua)
- [JSON](#json)
- [Bash / Zsh, YAML, TOML](#bash--zsh-yaml-toml)
- [Adding New Languages](#adding-new-languages)

---

## TypeScript / JavaScript / React

| Component | Tool |
|:----------|:-----|
| **LSP** | [tsc](https://github.com/microsoft/typescript-go) - native TypeScript 7 language server. In Vue projects [vtsls](https://github.com/yioneko/vtsls) takes over instead, see the Vue section |
| **Formatter** | Biome (primary), Prettier (fallback) |
| **Linter** | Biome, eslint_d |
| **Tests** | Jest, Vitest (via Sectest) |
| **Debug** | js-debug-adapter (via nvim-dap): launch current file, npm `dev` script, or attach to a process |
| **Features** | Auto-close/rename JSX tags, Emmet support, Tailwind CSS intellisense, inlay hints |

**File types:** `.js`, `.jsx`, `.ts`, `.tsx`, `.mjs`, `.cjs`

**Root markers:** `tsconfig.json`, `jsconfig.json`, `package.json`

**Treesitter parsers:** `javascript`, `typescript`, `tsx`, `html`, `css`

**Debugging:** `<F5>` starts a session, `<F9>` toggles a breakpoint, `<F10>` /
`<F11>` / `<Shift+F11>` step, and `<Shift+F5>` stops. TypeScript buffers also
offer a **Launch current file (tsx)** configuration.

---

## Go

| Component | Tool |
|:----------|:-----|
| **LSP** | [gopls](https://pkg.go.dev/golang.org/x/tools/gopls) — official Go language server |
| **Formatter** | goimports (organizes imports + formats) |
| **Linter** | golangci-lint |
| **Tests** | go test (via Sectest) |
| **Debug** | Delve (via nvim-dap-go) |

**File types:** `.go`, `go.mod`, `go.work`, `go.sum`

**Root markers:** `go.mod`, `go.work`

**Extra keybindings:**

| Key | Action |
|:----|:-------|
| `<leader>nga` | Generate test for current function |
| `<leader>ngA` | Generate tests for all functions |

---

## Rust

| Component | Tool |
|:----------|:-----|
| **LSP** | [rust-analyzer](https://rust-analyzer.github.io/) |
| **Formatter** | rustfmt (via conform.nvim) |
| **Linter** | clippy (`cargo clippy --all-targets`) |
| **Tests** | cargo test (via Sectest) |
| **Debug** | CodeLLDB (via nvim-dap) |

**File types:** `.rs`

**Root markers:** `Cargo.toml`, `rust-project.json`, `.git`

**Treesitter parser:** `rust`

**Features:** inlay hints are enabled by default (`<leader>lh` toggles them per
buffer), proc-macro expansion, all-features analysis, and clippy diagnostics.

**Keybindings:** `<F5>` debugs, `<F9>` toggles a breakpoint, `<F10>` / `<F11>`
/ `<Shift+F11>` step, `<Shift+F5>` stops. Sectest runs the nearest test with
`<leader>nr` and the workspace with `<leader>na`.

---

## C / C++

| Component | Tool |
|:----------|:-----|
| **LSP** | [clangd](https://clangd.llvm.org/) with background indexing and clang-tidy diagnostics |
| **Formatter** | clang-format (via conform.nvim) |
| **Linter** | clang-tidy checks surfaced through clangd |
| **Tests** | CTest via Sectest (GoogleTest / Catch2 test names), or a `make test` target |
| **Debug** | CodeLLDB (launch or attach) |
| **Build** | `F7` — auto-detects CMake, Meson, Make, Cargo, Go, Foundry, and npm |
| **Run** | `F6` — compile and run the current C/C++ file, plain or with ASan/UBSan |

**File types:** `.c`, `.h`, `.cpp`, `.cc`, `.cxx`, `.hpp`, `.hh`, `.hxx`, `.cu`,
`.m`, `.mm`

**Root markers:** `compile_commands.json`, `compile_flags.txt`, `.clangd`,
`CMakeLists.txt`, `Makefile`, `meson.build`, `configure.ac`, `.git`

**Treesitter parsers:** `c`, `cpp`

**Formatting:** 4-space indent, clang-format on save.

**Compile database:** clangd gives the best results with
`compile_commands.json`. Generate it from SecKit (`<leader>kk` →
**Generate compile_commands.json**) or from the SecBuild menu (`<leader>kb`).
CMake builds created by SecBuild export it automatically, symlink it into the
project root, and configure `CMAKE_BUILD_TYPE=Debug` when the cache has no
build type yet.

**Build and run:**

| Key | Action |
|:----|:-------|
| `F7` / `Ctrl+Shift+B` | Build the project (CMake, Meson, Make, Cargo, Go, Foundry, npm) |
| `F6` | Compile & run the current C/C++ file: plain, ASan + UBSan, or compile only |
| `F4` / `Alt+O` | Switch between header and source (clangd) |
| `<leader>kb` | SecBuild menu: build, run, compile_commands, CTest |
| `<leader>kk` | SecKit C/C++ sections: sources, headers, tests, fuzzing, build files |

The `F6` runner compiles to `stdpath('cache')/secbuild` with `-g -O0 -Wall
-Wextra` and, when selected, `-fsanitize=address,undefined
-fno-omit-frame-pointer`. Output streams into a terminal split.

**Debugging:** `F5` prompts for the executable (defaults to `build/` for C/C++
and `target/debug/` for Rust). **Attach to process** is also available. Use
`F9` for breakpoints, `F10` / `F11` / `<Shift+F11>` to step, and `<Shift+F5>`
to stop.

**Project navigation:** SecKit detects CMake, Meson, Makefile, and
`compile_commands.json` projects and offers source/header/test/fuzzing sections
plus build tools.

---

## Solidity

| Component | Tool |
|:----------|:-----|
| **LSP** | [Nomic Foundation Solidity Language Server](https://github.com/NomicFoundation/hardhat-vscode) (preferred, Mason), falling back to `vscode-solidity-server` |
| **Formatter** | `forge fmt` (Foundry), then Prettier |
| **Linter** | solhint (via nvim-lint) |
| **Tests** | Foundry `forge test` (via Sectest) |
| **Debug** | Not configured by default; use `forge test -vvvv` traces |

**File types:** `.sol`

**Root markers:** `foundry.toml`, `hardhat.config.ts`, `hardhat.config.js`,
`truffle-config.js`, `package.json`

**Treesitter parser:** `solidity`

**Formatting:** 4-space indent, `forge fmt` on save inside Foundry projects,
with Prettier as fallback. Comments use `//`, so `<Ctrl+/>` works.

**Testing:** Sectest detects `foundry.toml`. `<leader>nr` runs the test or
invariant under the cursor, `<leader>nf` runs the file
(`forge test --match-path`), and `<leader>na` runs the whole suite. Output is
parsed for `[PASS]` / `[FAIL]` / `[SKIP]`.

**Extra tools:** `<leader>kt` decodes JWT/Base64/hex and formats JSON;
`<leader>kx` opens a hex dump of the current contract or bytecode file.

---

## Python

| Component | Tool |
|:----------|:-----|
| **LSP** | [basedpyright](https://github.com/DetachHead/basedpyright) — Pyright fork with inlay hints, semantic highlighting, and fully open-source features |
| **Formatter** | autopep8 |
| **Linter** | Mypy (type checking), Pylint (code analysis) |
| **Tests** | pytest (via Sectest) |
| **Debug** | debugpy (via nvim-dap-python) |

**File types:** `.py`, `.pyi`

**Root markers:** `pyproject.toml`, `setup.py`, `setup.cfg`, `requirements.txt`, `pyrightconfig.json`

**Debug configurations:**
- Django server
- Django shell
- Attach to running process

**Extra tools:**
- **venv-selector** (`<leader>lxs`) — pick and activate virtual environments

---

## Java

| Component | Tool |
|:----------|:-----|
| **LSP** | [JDTLS](https://github.com/eclipse-jdtls/eclipse.jdt.ls) (Eclipse JDT Language Server) via nvim-jdtls |
| **Formatter** | google-java-format |
| **Linter** | Checkstyle |
| **Tests** | Gradle (via Sectest) |
| **Debug** | Remote attach via DAP |

**File types:** `.java`

**Root markers:** `pom.xml`, `build.gradle`, `build.gradle.kts`

**Spring Boot keybindings:**

| Key | Action |
|:----|:-------|
| `<leader>ks*` | Spring-related tools |

---

## PHP / Laravel

| Component | Tool |
|:----------|:-----|
| **LSP** | [Intelephense](https://intelephense.com/) — premium PHP language server |
| **Formatter** | php-cs-fixer |
| **Linter** | phpcs |
| **Tests** | Pest (via Sectest) |
| **Debug** | Xdebug |

**File types:** `.php`, `.blade.php`

**Root markers:** `composer.json`, `.git`

**Blade templates:** Full syntax highlighting with a custom Treesitter parser, Emmet support, and blade-formatter.

**Laravel keybindings (15+ commands):**

| Key | Action |
|:----|:-------|
| `<leader>kla` | Artisan commands |
| `<leader>klr` | Routes |
| `<leader>klg` | Make (generate classes) |
| `<leader>klm` | Goto model |
| `<leader>kle` | Goto controller |
| `<leader>klv` | Goto view |
| `<leader>kln*` | Sail commands |
| `<leader>klc*` | Composer commands |
| `<leader>klh*` | IDE Helper |
| `<leader>kld*` | Database schema |

---

## HTML / CSS / Tailwind

| Component | Tool |
|:----------|:-----|
| **LSP** | Emmet (abbreviations), Tailwind CSS Language Server (intellisense) |
| **Formatter** | Prettier |
| **Linter** | djlint |

**File types:** `.html`, `.css`, `.scss`

**Features:**
- Emmet abbreviations (`<C-y>` leader)
- Tailwind class completion and hover preview
- Auto-close and auto-rename HTML tags
- Django template detection (auto-switches to `htmldjango` filetype when `manage.py` is present)

---

## SQL

| Component | Tool |
|:----------|:-----|
| **LSP** | sqlls |
| **Formatter** | sql_formatter |
| **Completion** | vim-dadbod-completion (table names, columns, etc.) |

**Database UI:** vim-dadbod-ui provides a full database client with connection management, query execution, and result browsing.

| Key | Action |
|:----|:-------|
| `<leader>vb` | Toggle DB UI |
| `<leader>va` | Add connection |
| `<leader>vf` | Find query buffer |

---

## Lua

| Component | Tool |
|:----------|:-----|
| **LSP** | lua_ls (Lua Language Server) |
| **Formatter** | StyLua |

**Features:**
- lazydev.nvim provides enhanced completions for Neovim Lua API
- Full type checking and diagnostics

---

## JSON

| Component | Tool |
|:----------|:-----|
| **LSP** | json_ls (JSON Language Server) |
| **Formatter** | Prettier |
| **Linter** | Biome |

**File types:** `.json`, `.jsonc`

---

## Bash / Zsh, YAML, TOML

Security work is full of shell scripts, compose files, CI workflows, and
tooling manifests, so these formats get LSP and formatting too.

| Format | LSP | Formatter | Linter |
|:-------|:----|:----------|:-------|
| **Bash / Zsh** | bash-language-server | shfmt | shellcheck |
| **YAML** | yaml-language-server (SchemaStore fetch disabled) | - | - |
| **TOML** | taplo | taplo | - |

**File types:** `sh`, `bash`, `zsh`; `yaml`, `yaml.docker-compose`,
`yaml.gitlab`, `yaml.ansible`; `toml`.

**Root markers:** `.shellcheckrc` / `.git`, `.git`, `Cargo.toml` /
`pyproject.toml` / `foundry.toml` / `.git`.

YAML schema validation uses local `# yaml-language-server: $schema=` directives;
the automatic SchemaStore download is off, so the editor does not reach the
network by itself.

---

## Adding New Languages

Secvim uses **Mason** to manage external tools. Adding support for a new language is straightforward:

### 1. Install the LSP Server

Open Neovim and run:
```
:Mason
```

Search for the LSP server you need (e.g., `rust-analyzer` for Rust) and press `i` to install.

### 2. Create an LSP Configuration

Create a new file in `lsp/` (e.g., `lsp/rust_analyzer.lua`):

```lua
return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json" },
}
```

Neovim automatically loads config files from the `lsp/` directory, but it does **not** start them on its own.

### 3. Enable the Server

Add the server name to the `vim.lsp.enable { ... }` list in `lua/secvim/plugins/env/lsp/mason.lua` (the name must match the `lsp/<name>.lua` filename):

```lua
vim.lsp.enable {
  -- ... existing servers
  "rust_analyzer",
}
```

Without this step the server will not attach — creating the `lsp/<name>.lua` file alone is not enough.

### 4. Add a Formatter (optional)

Edit `lua/secvim/plugins/env/conform.lua` and add your formatter to the `formatters_by_ft` table:

```lua
rust = { "rustfmt" },
```

### 5. Add a Linter (optional)

Edit `lua/secvim/plugins/env/lint.lua` and add your linter:

```lua
rust = { "clippy" },
```

### 6. Add to Mason Auto-Install (optional)

Edit `lua/secvim/plugins/env/lsp/mason.lua` to auto-install the tools:

```lua
ensure_installed = {
  -- ... existing tools
  "rust-analyzer",
  "rustfmt",
}
```

### Languages You Can Add in Minutes

Here are some popular languages and their recommended tools:

| Language | LSP | Formatter | Linter |
|:---------|:----|:----------|:-------|
| **Rust** | rust-analyzer | rustfmt | clippy |
| **C / C++** | clangd | clang-format | clang-tidy |
| **C#** | omnisharp | csharpier | — |
| **Kotlin** | kotlin-language-server | ktlint | ktlint |
| **Ruby** | solargraph | rubocop | rubocop |
| **Elixir** | elixir-ls | mix format | credo |
| **Zig** | zls | zig fmt | — |
| **Swift** | sourcekit-lsp | swift-format | swiftlint |
| **Dart** | dartls | dart format | — |
| **YAML** | yaml-language-server | prettier | yamllint |
| **TOML** | taplo | taplo | — |
| **Docker** | dockerls | — | hadolint |
| **Terraform** | terraformls | terraform fmt | tflint |
| **Svelte** | svelte-language-server | prettier | — |
| **Vue** | volar | prettier | eslint |
| **Astro** | astro-ls | prettier | — |

All of these can be installed via Mason (`:Mason`) without any external setup.
