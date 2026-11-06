# Secvim development

Secvim is a Neovim 0.12+ distribution for authorized security research and bug
bounty work. It is derived from Rosavim (Apache-2.0); never remove the upstream
copyright notice in `LICENSE` or the attribution in `NOTICE`.

## Layout

- `init.lua` — entry point and lazy.nvim spec imports
- `lua/secvim/config/` — options, keybinds, appearance, toggles, autocmds
- `lua/secvim/plugins/` — third-party plugin specs by area
- `lua/secvim/sec_plugins/` — built-in Sec plugins
- `lua/secvim/sec_themes/` — Secmin, Secvintage, Secnight, Secjet, Secwave
- `lsp/` — native `vim.lsp.config` files
- `docs/manual/` — user documentation
- `sec_bin/` — generated helper scripts

## Commands

```sh
# Test the config without touching the user's default ~/.config/nvim
ln -sfn "$PWD" ~/.config/secvim
NVIM_APPNAME=secvim nvim --headless "+Lazy! sync" +qa
NVIM_APPNAME=secvim nvim

# Health and formatting
NVIM_APPNAME=secvim nvim --headless "+checkhealth" +qa
stylua lua/
```

## Rules

- User-facing names use the **Sec** / **sec** prefix. Keep module paths,
  highlight groups, command names, and docs consistent.
- Keep **Claude Code** as the primary AI integration. Copilot stays disabled
  by default. Do not add auto-approve / YOLO AI modes that bypass permission
  prompts.
- Do not add telemetry, analytics, or network calls to the distribution
  itself. Plugins may make network requests only when the user invokes them.
- Preserve native Neovim APIs (`vim.lsp.config`, `vim.lsp.enable`,
  `vim.treesitter`) and Neovim 0.12 compatibility.
- Keep `lazy-lock.json` committed once it is generated, so plugin sets are
  reproducible.
- Security content: examples and PoCs must be authorized, non-destructive,
  and free of secrets. Never commit tokens or real customer data.
