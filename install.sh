#!/usr/bin/env bash
# Secvim installer.
#
#   ./install.sh                 install plugins only
#   ./install.sh --with-tools    also install Mason language tools
#   ./install.sh --with-tmux     also link the bundled tmux config
#
# Safe to re-run. An existing Neovim config is backed up, never deleted.
set -euo pipefail

REPO_URL="${SECVIM_REPO_URL:-https://github.com/d0xeon/secvim.git}"
DEFAULT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
CONFIG_DIR="${SECVIM_CONFIG_DIR:-$DEFAULT_DIR}"
BRANCH="main"
WITH_TOOLS=0
WITH_TMUX=0
SKIP_PLUGINS=0
SKIP_UPDATE=0

if [ -t 1 ]; then
  BOLD=$'\033[1m'
  DIM=$'\033[2m'
  RED=$'\033[31m'
  GREEN=$'\033[32m'
  YELLOW=$'\033[33m'
  RESET=$'\033[0m'
else
  BOLD='' DIM='' RED='' GREEN='' YELLOW='' RESET=''
fi

say() { printf '%s\n' "$*"; }
step() { printf '\n%s==>%s %s\n' "$BOLD" "$RESET" "$*"; }
ok() { printf '%s  ok%s  %s\n' "$GREEN" "$RESET" "$*"; }
warn() { printf '%swarn%s  %s\n' "$YELLOW" "$RESET" "$*" >&2; }
die() { printf '%sError:%s %s\n' "$RED" "$RESET" "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
Secvim installer

Usage:
  ./install.sh [options]

Options:
  --with-tools     Install Mason LSP servers, formatters, linters, and debuggers
  --with-tmux      Symlink the bundled tmux config to ~/.tmux.conf
  --no-plugins     Skip the initial Lazy.nvim plugin sync
  --no-update      Do not git pull an existing Secvim checkout
  --dir <path>     Install into <path> (default: ~/.config/nvim)
  --branch <name>  Git branch to install (default: main)
  -h, --help       Show this help

Examples:
  ./install.sh --with-tools --with-tmux
  ./install.sh --no-plugins
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --with-tools) WITH_TOOLS=1 ;;
    --with-tmux) WITH_TMUX=1 ;;
    --no-plugins) SKIP_PLUGINS=1 ;;
    --no-update) SKIP_UPDATE=1 ;;
    --dir)
      [ $# -ge 2 ] || die "--dir needs a path"
      CONFIG_DIR="$2"
      shift
      ;;
    --branch)
      [ $# -ge 2 ] || die "--branch needs a name"
      BRANCH="$2"
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1 (try --help)"
      ;;
  esac
  shift
done

# ── Requirements ────────────────────────────────────────────────────
step "Checking requirements"

command -v git >/dev/null 2>&1 || die "git is required"
command -v nvim >/dev/null 2>&1 || die "Neovim is required: https://neovim.io"

NVIM_VERSION="$(nvim --version | sed -n '1s/^NVIM v//p')"
NVIM_MAJOR="${NVIM_VERSION%%.*}"
NVIM_REST="${NVIM_VERSION#*.}"
NVIM_MINOR="${NVIM_REST%%.*}"
NVIM_MINOR="${NVIM_MINOR%%[!0-9]*}"
if [ -z "$NVIM_MAJOR" ] || [ -z "$NVIM_MINOR" ]; then
  die "could not read the Neovim version; 0.12+ is required"
fi
if [ "$NVIM_MAJOR" -eq 0 ] && [ "$NVIM_MINOR" -lt 12 ]; then
  die "Neovim 0.12+ is required (found ${NVIM_VERSION:-unknown})"
fi
ok "Neovim ${NVIM_VERSION}"
ok "git $(git --version | awk '{print $3}')"

if command -v rg >/dev/null 2>&1; then
  ok "ripgrep"
else
  warn "ripgrep missing (pickers and grep need it)"
fi
if command -v fd >/dev/null 2>&1 || command -v fdfind >/dev/null 2>&1; then
  ok "fd"
else
  warn "fd missing (file pickers need it)"
fi
if command -v node >/dev/null 2>&1; then
  ok "node $(node --version)"
else
  warn "node missing (many language servers need it)"
fi
if command -v python3 >/dev/null 2>&1; then
  ok "python3 $(python3 --version 2>&1 | awk '{print $2}')"
else
  warn "python3 missing (Python LSPs and debugpy need it)"
fi
if command -v tree-sitter >/dev/null 2>&1; then
  ok "tree-sitter"
else
  warn "tree-sitter CLI missing (parser builds need it)"
fi
if command -v cc >/dev/null 2>&1 || command -v clang >/dev/null 2>&1; then
  ok "C compiler"
else
  warn "C compiler missing (Treesitter parsers need it)"
fi

if [ "$(uname -s)" = "Darwin" ]; then
  say "${DIM}macOS hints: brew install neovim git ripgrep fd node python tree-sitter-cli${RESET}"
  say "${DIM}              or use MacPorts for the same packages.${RESET}"
else
  say "${DIM}Linux hints: install neovim git ripgrep fd-find nodejs npm python3 gcc make unzip${RESET}"
fi

# ── Install or update the checkout ──────────────────────────────────
SCRIPT_DIR="$(unset CDPATH; cd -- "$(dirname -- "$0")" && pwd -P)"
CONFIG_ABS=""

if [ -e "$CONFIG_DIR" ]; then
  CONFIG_ABS="$(unset CDPATH; cd -- "$CONFIG_DIR" 2>/dev/null && pwd -P || true)"
fi

is_secvim_checkout() {
  [ -f "$1/init.lua" ] && [ -d "$1/lua/secvim" ]
}

use_checkout() {
  if [ "$SKIP_UPDATE" -eq 0 ] && [ -d "$1/.git" ] && git -C "$1" rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
    step "Updating existing checkout at $1"
    git -C "$1" pull --ff-only
  else
    ok "Using existing checkout at $1"
  fi
}

if [ -n "$CONFIG_ABS" ] && [ "$CONFIG_ABS" = "$SCRIPT_DIR" ]; then
  use_checkout "$CONFIG_DIR"
elif [ -n "$CONFIG_ABS" ] && is_secvim_checkout "$CONFIG_DIR"; then
  use_checkout "$CONFIG_DIR"
elif [ -n "$CONFIG_ABS" ]; then
  BACKUP="${CONFIG_DIR}.bak.$(date +%Y%m%d-%H%M%S)"
  step "Backing up existing config -> $BACKUP"
  mv "$CONFIG_DIR" "$BACKUP"
  step "Cloning Secvim"
  git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$CONFIG_DIR"
  CONFIG_ABS="$CONFIG_DIR"
elif [ -e "$CONFIG_DIR" ]; then
  die "$CONFIG_DIR exists but is not a directory"
else
  step "Cloning Secvim into $CONFIG_DIR"
  mkdir -p "$(dirname "$CONFIG_DIR")"
  git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$CONFIG_DIR"
  CONFIG_ABS="$CONFIG_DIR"
fi

[ -f "$CONFIG_DIR/init.lua" ] || die "no init.lua in $CONFIG_DIR"
CONFIG_DIR="$(unset CDPATH; cd -- "$CONFIG_DIR" && pwd -P)"
ok "Secvim at $CONFIG_DIR"

run_nvim() {
  if [ "$CONFIG_DIR" = "$DEFAULT_DIR" ]; then
    NVIM_APPNAME=nvim nvim --headless "$@"
  else
    XDG_CONFIG_HOME="$(dirname "$CONFIG_DIR")" \
      NVIM_APPNAME="$(basename "$CONFIG_DIR")" \
      nvim --headless "$@"
  fi
}

# ── Plugins ─────────────────────────────────────────────────────────
if [ "$SKIP_PLUGINS" -eq 0 ]; then
  step "Installing plugins (Lazy.nvim)"
  run_nvim "+Lazy! sync" +qa
  ok "Plugins synced"
fi

# ── Mason tools ─────────────────────────────────────────────────────
if [ "$WITH_TOOLS" -eq 1 ]; then
  step "Installing Mason tools (this can take several minutes)"
  if run_nvim "+MasonToolsInstall" +qa; then
    ok "Mason tools installed"
  else
    warn "MasonToolsInstall did not finish; run :MasonToolsInstall inside Neovim"
  fi
fi

# ── tmux ────────────────────────────────────────────────────────────
if [ "$WITH_TMUX" -eq 1 ]; then
  TMUX_SRC="$CONFIG_DIR/sec_bin/tmux.conf"
  TMUX_DST="$HOME/.tmux.conf"
  if [ -e "$TMUX_DST" ] || [ -L "$TMUX_DST" ]; then
    warn "$TMUX_DST already exists; leaving it untouched"
    say "${DIM}Merge the smart-splits bindings from $TMUX_SRC manually.${RESET}"
  else
    ln -s "$TMUX_SRC" "$TMUX_DST"
    ok "Linked $TMUX_DST -> $TMUX_SRC"
    if command -v tmux >/dev/null 2>&1 && tmux ls >/dev/null 2>&1; then
      tmux source-file "$TMUX_DST" || warn "could not reload tmux; run: tmux source-file ~/.tmux.conf"
      ok "tmux config reloaded"
    fi
  fi
fi

# ── Done ────────────────────────────────────────────────────────────
step "Ready"
say "  nvim"
say "  :MasonToolsInstall   # if you did not pass --with-tools"
say "  :checkhealth secvim"
say "  :help secvim"
say ""
say "${DIM}Restart any Neovim/tmux sessions that were already running.${RESET}"
if [ "$WITH_TOOLS" -eq 0 ]; then
  say "${DIM}Language servers/formatters are optional: re-run with --with-tools.${RESET}"
fi
