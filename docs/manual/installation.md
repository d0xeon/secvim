# Installation

🇺🇸 **[English](#installation)** | 🇧🇷 **[Português](installation.pt-br.md)**

---

## Requirements

Before installing Secvim, make sure you have these dependencies:

| Dependency | Version | How to install |
|:-----------|:--------|:---------------|
| **Neovim** | **>= 0.12** | `brew install neovim` / [neovim.io](https://neovim.io) |
| **Lua** | >= 5.1 | `brew install lua` / `sudo apt install lua5.1` |
| **Git** | >= 2.19 | `brew install git` / `sudo apt install git` |
| **Node.js** | >= 18 | `brew install node` / [nodejs.org](https://nodejs.org) |
| **Python** | >= 3.10 | `brew install python` / `sudo apt install python3` |
| **Nerd Font** | Any | [nerdfonts.com](https://www.nerdfonts.com/) |
| **ripgrep** | Any | `brew install ripgrep` / `sudo apt install ripgrep` |

### Recommended

These are optional but highly recommended for the full experience:

| Tool | What it does | How to install |
|:-----|:-------------|:---------------|
| [lazygit](https://github.com/jesseduffield/lazygit) | Git UI in the terminal | `brew install lazygit` / `sudo apt install lazygit` |
| [yazi](https://github.com/sxyazi/yazi) | Terminal file manager | `brew install yazi` / `sudo apt install yazi` |
| [chafa](https://hpjansson.org/chafa/) | Terminal image display (dashboard) | `brew install chafa` / `sudo apt install chafa` |

## Mason Dependencies (system runtimes)

Mason downloads LSP servers, formatters, linters, and debuggers — but it relies on **system runtimes** to install and run them. Without these, several packages will fail silently.

| Runtime | Needed for | Why |
|:--------|:-----------|:----|
| **Node.js + npm** | tsc, vtsls, vue-language-server, tailwindcss, emmet-ls, intelephense, json-lsp, sqlls, prettierd, eslint_d, biome, sql-formatter, blade-formatter, php-debug-adapter | Most language servers and JS tools are npm packages |
| **Python 3 + pip** | basedpyright, autopep8, mypy, djlint, debugpy | Python tooling installs via pip |
| **Go** | gopls, goimports, go-debug-adapter | Built from source via `go install` |
| **Java (JDK 17+)** | jdtls, google-java-format, java-debug-adapter | Java tooling requires a JDK |
| **unzip / wget / curl** | Pre-built binaries (lua-language-server, stylua, etc.) | Used to download and extract releases |
| **C compiler** | Treesitter parsers, some native modules | Needed to compile parsers on first run |

### macOS

```bash
# Core (required by Secvim itself)
brew install neovim git ripgrep

# Mason runtimes
brew install node python go openjdk
brew install wget unzip curl

# C compiler (if not already present)
xcode-select --install
```

### Linux — Debian / Ubuntu

```bash
sudo apt update
sudo apt install -y neovim git ripgrep
sudo apt install -y nodejs npm python3 python3-pip golang-go default-jdk
sudo apt install -y unzip wget curl build-essential
```

> If your distro's Node.js is too old (< 18), install via [nvm](https://github.com/nvm-sh/nvm) or [nodesource](https://github.com/nodesource/distributions).

### Linux — Arch / Manjaro

```bash
sudo pacman -S neovim git ripgrep
sudo pacman -S nodejs npm python python-pip go jdk-openjdk
sudo pacman -S unzip wget curl base-devel
```

### Linux — Fedora

```bash
sudo dnf install -y neovim git ripgrep
sudo dnf install -y nodejs npm python3 python3-pip golang java-latest-openjdk
sudo dnf install -y unzip wget curl
sudo dnf groupinstall -y "Development Tools"
```

## Quick install (recommended)

```bash
git clone https://github.com/d0xeon/secvim.git /tmp/secvim
/tmp/secvim/install.sh --with-tools --with-tmux
rm -rf /tmp/secvim
nvim
```

`install.sh` backs up an existing `~/.config/nvim` when it needs to, syncs
Lazy.nvim plugins, and optionally installs Mason tools (`--with-tools`) and
links the bundled tmux config (`--with-tmux`, only when `~/.tmux.conf` does not
exist). Cloning to `/tmp` first is what makes the backup safe even when a
config already exists.

Run `./install.sh --help` for all options. The manual steps below remain
available if you prefer to control each part.

## Step 1: Back up your current config

If you already have a Neovim configuration, back it up first:

```bash
# Back up existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Also back up local data (optional, for a clean start)
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

## Step 2: Clone Secvim

```bash
git clone https://github.com/d0xeon/secvim.git ~/.config/nvim
```

## Step 3: Launch Neovim

```bash
nvim
```

On first launch:

1. **Lazy.nvim** installs any plugins the installer did not sync
2. Run `:MasonToolsInstall` unless you launched the installer with `--with-tools`
3. **Treesitter** downloads and compiles language parsers in the background

> The first run may take a few minutes. Let it finish before closing Neovim.

## Step 4: Verify the installation

Inside Neovim, run:

```
:checkhealth
```

This will show you the status of all providers and dependencies. Fix any warnings or errors that appear.

You can also run Secvim's own health check:

```
:checkhealth secvim
```

## Updating

To update Secvim, run the installer from the checkout:

```bash
cd ~/.config/nvim
./install.sh
```

It pulls the latest `main`, syncs Lazy.nvim plugins, and keeps your existing
Mason tools. Use `--no-plugins` to pull only. Inside Neovim, `:Lazy sync` does
the plugin half manually.

## Uninstalling

To completely remove Secvim:

```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

Then restore your backup if you have one:

```bash
mv ~/.config/nvim.bak ~/.config/nvim
```

## Troubleshooting

### Plugins fail to install

Make sure you have a working internet connection and Git is properly configured:

```bash
git --version
```

Try removing the plugin cache and reopening:

```bash
rm -rf ~/.local/share/nvim/lazy
nvim
```

### Mason tools fail to install

Some Mason packages require specific system dependencies. Check the Mason log:

```
:MasonLog
```

Common fixes:

- **npm packages**: Make sure `node` and `npm` are in your PATH
- **Python tools**: Make sure `python3` and `pip3` are available
- **Go tools**: Make sure `go` is installed and `GOPATH` is set

### Mason tools were not installed

Secvim does not install Mason tools on startup by default. Install them once
with:

```
:MasonToolsInstall
```

or re-run the installer with `./install.sh --with-tools`. This is expected if
you used `--no-plugins` or skipped the `--with-tools` flag.

You can also open the Mason UI to inspect what is installed (`✓`), pending (`➜`), or missing (`✗`):

```
:Mason
```

### Treesitter parsers fail to compile

Make sure you have a C compiler installed:

```bash
# macOS (should already have it)
xcode-select --install

# Linux
sudo apt install build-essential
```

### Icons not showing correctly

Install a [Nerd Font](https://www.nerdfonts.com/) and set it as your terminal font. Recommended: **JetBrains Mono Nerd Font** or **FiraCode Nerd Font**.

---

<div align="center">

[Back to README](../../README.md)

</div>
