<div align="center">

<img src="assets/logo/secvim.svg" alt="Secvim" width="420" />

# Secvim

**A security-focused Neovim distribution for researchers, bug hunters, and tool builders.**

[![Neovim](https://img.shields.io/badge/Neovim-0.12%2B-57A143?style=for-the-badge&logo=neovim&logoColor=57A143&labelColor=1a1a2e)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge)](LICENSE)
[![CI](https://github.com/d0xeon/secvim/actions/workflows/ci.yml/badge.svg)](https://github.com/d0xeon/secvim/actions/workflows/ci.yml)

*Fast, focused, and explicit about scope.*

🇺🇸 **English** · 🇧🇷 **[Português](README.pt-br.md)**

</div>

## What is Secvim?

Secvim is a Neovim 0.12+ distribution for authorized security research and bug
bounty work. Open a repository and it already feels like an IDE: file tree,
tabs, breadcrumbs, fuzzy search, LSP, formatting, linting, DAP, tests, and a
terminal-first AI workflow.

It ships first-class support for **Rust, Python, Go, Solidity,
TypeScript/JavaScript, and C/C++**, with the configuration formats around them
(JSON, YAML, TOML, Bash, HTTP, SQL, Dockerfiles). Claude Code is the primary AI
integration; GitHub Copilot and other CLIs are optional and disabled by
default.

It runs on **Lazy.nvim** and loads plugins only when they are needed, so
startup stays quick. On top of that it brings its own set of **"sec" plugins**
(terminal, test runner, file operations, project navigator, and more), which
covers most of what you would otherwise install by hand.

Secvim is derived from [Rosavim](https://github.com/pedrorcruzz/rosavim)
(Apache-2.0). See [Origin and license](#origin-and-license).

## Quick Start

```bash
# Clone to /tmp so the installer can back up an existing config safely
git clone https://github.com/d0xeon/secvim.git /tmp/secvim
/tmp/secvim/install.sh --with-tools --with-tmux
rm -rf /tmp/secvim
nvim
```

The installer backs up an existing config when it has to, syncs Lazy.nvim
plugins, and with `--with-tools` installs the Mason LSP servers, formatters,
linters, and debug adapters. `--with-tmux` links the bundled tmux config only
when `~/.tmux.conf` does not already exist. Treesitter parsers finish
installing on the first launch.

Prefer the manual route? See the [Installation Manual](docs/manual/installation.md).

<details>
<summary><b>Requirements</b></summary>

<br>

| Dependency | Version |
|:-----------|:--------|
| **Neovim** | **>= 0.12** |
| Git | >= 2.19 |
| Node.js | >= 18 |
| Python | >= 3.10 |
| [Nerd Font](https://www.nerdfonts.com/) | Any |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Any |
| [fd](https://github.com/sharkdp/fd) | Any |
| [tree-sitter-cli](https://github.com/tree-sitter/tree-sitter) | >= 0.26.1 |

**macOS (MacPorts):**

```bash
sudo port install neovim fd ripgrep tree-sitter-cli lazygit tmux jq
```

Node.js is best managed with nvm; Python with `uv` or MacPorts.

> **macOS:** terminal Neovim cannot receive Cmd shortcuts, so the keymaps use
> Ctrl/Alt/F-keys. See [macOS Notes](docs/manual/keybinds.md#macos-notes) for
> Option-as-Meta, standard function keys, `Ctrl+S`/XOFF, the kitty-protocol
> caveat, and clipboard setup.

**Recommended:** [tmux](https://github.com/tmux/tmux) (bundled config) · [lazygit](https://github.com/jesseduffield/lazygit) (Git UI) · [yazi](https://github.com/sxyazi/yazi) (file manager) · [chafa](https://hpjansson.org/chafa/) (dashboard image)

Full step-by-step guide (backup, dependencies, troubleshooting): **[Installation Manual](docs/manual/installation.md)**.

</details>

## Documentation

Detailed guides live in [`docs/manual`](docs/manual/):

[Installation](docs/manual/installation.md) · [Keybindings](docs/manual/keybinds.md) · [Plugins](docs/manual/plugins.md) · [Languages](docs/manual/languages.md) · [Debugging](docs/manual/debugging.md) · [Customization](docs/manual/customization.md) · [Toggles](docs/manual/toggles.md)

Inside Neovim: `:help secvim` for the overview, `:help secvim-keymaps` for daily keys, `:help secvim-layout`, `:help secvim-tmux`, and `:help secvim-macos`.

## Features

<details>
<summary><b>Editor & Navigation</b></summary>

<br>

- **blink.cmp**, a completion engine written in Rust that keeps up even in big files
- **Native snippets** (`vim.snippet`) + friendly-snippets, managed by **Secsnippets**, an interactive panel with fuzzy search, per-language starter presets, and live preview
- **Native Treesitter** (Neovim 0.12+) for precise highlighting and indentation
- **Format on save** (conform.nvim) and **auto-save** on focus loss
- **Snacks Picker** for fuzzy finding files, grep, and buffers
- **tmux integration**: smart-splits backend plus a bundled tmux config; `Ctrl+h/j/k/l` crosses Neovim splits and tmux panes, `Alt+h/j/k/l` resizes across both
- **SecLayout**: `Ctrl+G` opens a Neovim-native 2×2 grid — code, run, tests, and logs — in its own tab; terminal commands are configured in `lua/secvim/config/layout.lua`
- **Flash.nvim** for jump-anywhere navigation with visual labels
- **GrugFar** for project-wide search and replace (ripgrep)
- **Persistent toggles**, so your UI settings are still there next time you open the editor

</details>

<details>
<summary><b>Git, Debug & Testing</b></summary>

<br>

- **Gitsigns** for inline change indicators and per-line blame
- Built-in **lazygit** integration
- **DAP**, a full debugger with UI, breakpoints, and inline variable inspection
- **Sectest**, the built-in test runner with a popup UI: run the nearest test, the whole file, or everything. Works with Go, Rust, Jest, Vitest, Pytest, Foundry, CTest, Pest, PHPUnit, and Java

</details>

<details>
<summary><b>AI</b></summary>

<br>

- **Claude Code** as the primary AI workflow, launched inside a themed,
  resizable terminal from SecAI
- **SecAI**, native integration with AI CLIs (Claude, Cursor, OpenClaude,
  OpenCode, Gemini, and others) when their binaries are installed
- **GitHub Copilot** is available but **disabled by default**; enable it
  explicitly if your environment permits it

</details>

<details>
<summary><b>Security workflow</b></summary>

<br>

- First-class **Rust, Python, Go, Solidity, TypeScript/JavaScript, and C/C++**
  support: LSP, format-on-save, linting, tests, and project-wide search. DAP is
  wired for Rust, Go, Python, C/C++, PHP, Java, and TS/JS; Solidity uses
  `forge test -vvvv` traces
- **Sectools**, an offline decode/inspect toolbox: Base64, Base64URL, URL, hex,
  JWT, JSON pretty/minify, and hex dumps (`<leader>kt`, `<leader>kx`)
- **SecBuild**, IDE-style build/run for C/C++ and the other stacks: `F7` builds
  CMake/Meson/Make/Cargo/Go/Foundry/npm projects, `F6` compiles and runs the
  current C/C++ file with optional ASan/UBSan, and CMake export of
  `compile_commands.json` is one menu item away (`<leader>kb`)
- **GrugFar** and Snacks grep for finding sinks, unsafe blocks, and dangerous
  deserialization paths
- **DAP** for stepping through PoCs and parser harnesses
- Scope and authorization rules live in `~/.claude/CLAUDE.md`, not in the
  editor. Secvim never initiates scans or network traffic on its own

</details>

<details>
<summary><b>UI & Appearance</b></summary>

<br>

- **5 built-in themes**: **Secwave** (default, Kanagawa dragon/lotus), **Secmin** (minimal), **Secvintage** (warm, earthy), **Secnight** (monochrome, OLED black), and **Secjet** (JetBrains palette), all with dark/light mode and transparency
- **Dashboard**, **Lualine** statusline (selectable separators), **Bufferline** tabs, **Dropbar** breadcrumbs, **Incline** floating filenames, and **Noice** for modern messages
- One-shortcut **dark/light** and **theme** switching

</details>

<details>
<summary><b>Built-in "Sec" plugins</b></summary>

<br>

| Plugin | What it does |
|:-------|:-------------|
| **Secterm** | Float and split terminals, native, no external dependencies. Cycle floats, themed title chip, persistent toggles |
| **Sectest** | Test runner with popup results (Go, Rust, Jest, Vitest, Pytest, Foundry, CTest, Pest, PHPUnit, Java) |
| **SecBuild** | Build/run helper: `F7` builds CMake, Meson, Make, Cargo, Go, Foundry, and npm projects; `F6` compiles/runs C/C++ with ASan/UBSan; generates `compile_commands.json` |
| **SecLayout** | Neovim-native 2×2 dev grid (code / run / tests / logs) toggled with `Ctrl+G`; terminal commands live in `lua/secvim/config/layout.lua` |
| **Sectools** | Offline decode/inspect toolbox: Base64, Base64URL, URL, hex, JWT, JSON pretty/minify, hex dump (`<leader>kt`, `<leader>kx`) |
| **SecKit** | Language-aware project navigator with automatic stack detection (React, Next, Vue, Angular, Svelte, Nest, Express, Go, Django, FastAPI, Laravel, Spring), monorepos included |
| **Secfile** | File operations menu: create, rename, duplicate, delete, info |
| **Secpreview** | LSP preview (definition, type, implementation, references) in a floating window |
| **Secpin** | Bookmark and jump between frequently used files, scoped per git repo |
| **Secdirs** | Manage Projects & Obsidian vault directories at runtime |
| **Secsnippets** | Snippet manager: browse and search your snippets, 4-step creation wizard with per-language starter presets (plus your own), live preview, hot reload into completion |
| **Secpick** | Visual window picker with letter labels |
| **Secmaximize** | Maximize the current window and restore the full layout, with a `max` badge and a lualine indicator (configurable via `<leader>lam`) |
| **Seczen** | Distraction-free mode: maximizes and centers the current window, hides all UI chrome, keeps floating tools (Secterm/SecAI/Yazi/Lazygit) usable, and persists across sessions |
| **Sectag** | Auto close and live rename html/jsx tags, no treesitter parser needed (`<leader>kr` to rename, toggles in `<leader>lat`) |
| **Secvisualmulti** | Multi-cursor editing built on extmarks: occurrence (`<C-n>`), column (`<C-Up>`/`<C-Down>`) and regex cursors, insert replicated to every cursor, arbitrary normal commands and macros, align, rename popup, and a dynamic action menu (`<leader>kv`) |
| **Secyank** | Persistent yank history (ring buffer) |
| **Secsave** | Debounced auto-save |
| **Secsweep** | Auto-closes inactive buffers |

</details>

<details>
<summary><b>Extras</b></summary>

<br>

- **Database Client** (vim-dadbod) with UI for SQL
- **Obsidian** integration for notes
- **Discord Presence**

> The plugin system is modular, so add, remove, or swap plugins to match how you work.

</details>

## Languages & Frameworks

Full support (LSP, formatting, linting, testing, debugging) for the most popular stacks:

<details>
<summary><b>Show support table</b></summary>

<br>

| Language | LSP | Formatter | Linter | Tests | Debug |
|:---------|:---:|:---------:|:------:|:-----:|:-----:|
| **Rust** | rust-analyzer | rustfmt | clippy | cargo test | codelldb |
| **C / C++** | clangd | clang-format | clang-tidy | ctest | codelldb |
| **TypeScript / JavaScript** | tsc | Biome / Prettier | Biome / eslint_d | Jest / Vitest | js-debug |
| **React / JSX / TSX** | tsc | Biome / Prettier | Biome / eslint_d | Jest / Vitest | js-debug |
| **Go** | gopls | goimports | golangci-lint | go test | Delve |
| **Solidity** | Nomic Solidity LS | forge fmt / Prettier | solhint | forge test | - |
| **Python** | basedpyright + ruff | ruff | ruff / Mypy | pytest | debugpy |
| **Bash / Zsh** | bash-language-server | shfmt | shellcheck | - | - |
| **YAML / TOML** | yaml-language-server / taplo | taplo (TOML) | - | - | - |
| **Java** | JDTLS | google-java-format | Checkstyle | Gradle | Remote Attach |
| **PHP / Laravel** | Intelephense | php-cs-fixer | phpcs | Pest | Xdebug |
| **HTML / CSS** | Emmet + Tailwind | Prettier | djlint | - | - |
| **SQL** | sqlls | sql_formatter | - | - | - |
| **Lua** | lua_ls | StyLua | - | - | - |
| **JSON** | json_ls | Prettier | Biome | - | - |

</details>

> **Not listed?** Secvim leans on **Mason** for tooling, so Kotlin, Ruby,
> Elixir, Zig, and plenty of others take a couple of minutes to add.

## Themes

Secvim comes with 5 themes of its own, all wired into the dark/light and transparency toggles.

<details>
<summary><b>Secmin</b>: minimal, clean, focused</summary>

<br>

A low-contrast dark surface with cool accents. This is the default theme and
the best starting point for long working sessions. Dark, light, and
transparency are all supported.

</details>

<details>
<summary><b>Secvintage</b>: warm, earthy tones</summary>

<br>

A warm, earthy palette with muted greens and browns. Dark, light, and
transparency are all supported.

</details>

<details>
<summary><b>Secnight</b>: monochrome (OLED black and cool white)</summary>

<br>

A night theme with no color at all: OLED black (`#000000`) behind a cool white and grey ramp. In light mode the whole thing flips onto a soft `#D3D2CE` base. Dark, light, and transparency are all supported.

</details>

<details>
<summary><b>Secjet</b>: JetBrains IDE palette (ported)</summary>

<br>

A port of the JetBrains color scheme. The dark side follows IntelliJ IDEA's New
UI: `#272729` in the editor, `#191A1C` in the explorer and tab strip (press
`<leader>lqij` to swap the two) and `#2B2D30` in the tool windows. Light mode
follows IntelliJ Light (`#FFFFFF` and `#F7F8FA`). The syntax roles are the IDE's
own: orange or blue keywords, green strings, magenta constants and properties,
olive annotations, and plain text for classes and identifiers. Ported from
[nickkadutskyi/jb.nvim](https://github.com/nickkadutskyi/jb.nvim), and the
lualine mode chips reuse the IdeaVim mode colors. Dark, light, and transparency
are all supported.

</details>

<details>
<summary><b>Secwave</b>: Kanagawa's dragon & lotus palettes (ported, default)</summary>

<br>

A port of [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim), using its
warm, muted dragon palette for dark mode and the lotus palette for light mode.
Borders, cursor, and the Snacks explorer/picker backgrounds are tuned to match
the neutral grey chrome the other Sec themes share instead of kanagawa's own
bluer tones. Dark, light, and transparency are all supported.

</details>

## Key Shortcuts

> Leader key: `<Space>` · Press `<leader>` anytime to open **which-key** and browse everything. For Vim help use `:help secvim` / `:help secvim-keymaps`; for the full Markdown reference use `<leader>?` or `:help secvim-more`.

<details>
<summary><b>Show essential shortcuts</b></summary>

<br>

**Files & Navigation**
| Key | Action |
|:----|:-------|
| `<leader><space>` | Find files |
| `<C-p>` | Find files (layout-aware) |
| `<leader>e` | Explorer: focus/toggle |
| `<C-b>` | Toggle sidebar |
| `<leader>bn` / `<leader>bd` | New buffer / close buffer |
| `<leader>tn` / `<leader>tc` | New tab / close tab |
| `<leader>y` | Yazi file manager |
| `<leader>;` | Dashboard |
| `s` | Flash jump |
| `<leader>oo` / `<leader>oe` | Secpin: pin / menu |

**Search & Code**
| Key | Action |
|:----|:-------|
| `<leader>sg` | Live grep |
| `<leader>sw` | Grep word under cursor |
| `<leader>lee` | Search & replace (GrugFar) |
| `gd` / `gr` / `gI` | Definition / references / implementation |
| `gp` | Secpreview definition |
| `<leader>lf` | Format file |
| `<leader>xx` | Secfile menu |
| `<leader>kk` | SecKit menu |
| `<C-n>` | Secvisualmulti: select word / next occurrence |
| `<leader>kvv` | Secvisualmulti menu |

**Git, Test & Debug**
| Key | Action |
|:----|:-------|
| `<leader>gg` | Lazygit |
| `<leader>gt` | Toggle git blame |
| `<leader>nn` | Sectest menu |
| `<leader>nf` | Run file tests |
| `<leader>ds` | Start / continue debug |
| `<leader>db` | Toggle breakpoint |

**Windows, Terminal & AI**
| Key | Action |
|:----|:-------|
| `<C-h/j/k/l>` | Move between Neovim splits and tmux panes |
| `<M-h/j/k/l>` | Resize Neovim splits and tmux panes |
| `<C-g>` | Toggle the 2×2 dev layout (code / run / tests / logs) |
| `<leader>lw` | Toggle the 2×2 dev layout (same as `Ctrl+G`) |
| `<leader>m` | Secpick (window picker) |
| `<leader>S` | Secpick (window picker, left-hand alias) |
| `<leader>cm` | Secmaximize |
| `<leader>lz` | Seczen (distraction-free mode) |
| `<C-\>` / `<S-z>` | Secterm: toggle float |
| `<S-x>` | Secterm: horizontal terminal |
| `<leader>cii` / `<leader>cie` | Secterm: vertical / horizontal split |
| `<leader>aa` | SecAI: toggle CLI |
| `<leader>ac` | SecAI: toggle Claude Code |

> **tmux:** the bundled `sec_bin/tmux.conf` (symlinked to `~/.tmux.conf`) sets
> the prefix to `Ctrl+a`, forwards `Ctrl+h/j/k/l` and `Alt+h/j/k/l` to Neovim
> when a pane is running Neovim, and adds pane/window/session shortcuts. See
> [tmux Integration](docs/manual/keybinds.md#tmux-integration).

**UI & Misc**
| Key | Action |
|:----|:-------|
| `<leader>lqt` | Toggle dark/light mode |
| `<leader>lqs` | Switch theme (secmin / secvintage / secnight / secjet / secwave) |
| `<leader>lqi` | Invert BG (secjet `j` / secmin `m` / secvintage `v`) |
| `<leader>lqy` | Toggle lualine bar-y transparency |
| `<leader>lp` | Secdirs (manage project dirs) |
| `<leader>lo` | Secsnippets (snippet manager) |
| `<leader>ll` | Toggle statusline |
| `<leader>ly` | Toggle cursor shape (block ↔ thin bar) |
| `<leader>lY` | Toggle current-line highlight |
| `kj` | Exit insert mode |

Full reference: **[Keybindings Manual](docs/manual/keybinds.md)**.

</details>

## Project Structure

<details>
<summary><b>Show structure</b></summary>

<br>

```
~/.config/nvim/
├── init.lua                       # Entry point
├── install.sh                     # Installer (plugins, Mason tools, tmux)
├── Makefile                       # make install/update/tools/format/check
├── doc/                           # :help secvim
├── lua/secvim/
│   ├── init.lua                   # Bootstrap
│   ├── config/                    # options, keybinds, appearance, autocmds, toggles, focus
│   ├── plugins/
│   │   ├── env/                   # LSP, Mason, Treesitter, DAP, lint, format, git
│   │   ├── ai/                    # Copilot, SecAI
│   │   ├── ui/                    # themes, statusline, dashboard, bufferline, noice
│   │   ├── editor/                # terminal, navigation, file ops, projects
│   │   ├── coding/                # flash, surround, multi-cursor
│   │   ├── language/              # language-specific (Laravel, Spring, Django, etc)
│   │   └── test/                  # Sectest
│   ├── sec_plugins/              # built-in plugins (see Features)
│   │   ├── secterm/  sectest/  seckit/  secfile/
│   │   ├── secbuild/  sectools/  seclayout/
│   │   ├── secpreview/  secpin/  secdirs/  secpick/  secsnippets/
│   │   ├── secmaximize/  seczen/  secyank/  secsave/  secsweep/
│   │   ├── sectag/
│   │   └── secai/
│   └── sec_themes/
│       ├── secmin/              # minimal theme
│       ├── secvintage/          # earthy, warm theme
│       ├── secnight/            # minimalist monochrome (OLED)
│       ├── secjet/              # JetBrains IDE palette (ported), Invert BG in config/invert_bg.lua
│       └── secwave/             # default (Kanagawa dragon/lotus)
├── lsp/                           # individual LSP configs
├── snippets/                      # VSCode-format snippets (managed by Secsnippets, <leader>lo)
├── sec_bin/                       # helper scripts + tmux.conf
└── assets/                        # logo and documentation images
```

</details>

## Origin and license

Secvim is a fork of [Rosavim](https://github.com/pedrorcruzz/rosavim) by
Pedro Rosa, used under the Apache License 2.0. The original copyright and
license are preserved in [LICENSE](LICENSE) and [NOTICE](NOTICE).

Maintained by [d0xeon](https://github.com/d0xeon).

---

<div align="center">

Built and maintained by **d0xeon**

</div>
