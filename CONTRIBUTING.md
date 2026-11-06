# Contributing to Secvim

Thanks for taking the time to improve Secvim.

## Development setup

```bash
git clone https://github.com/d0xeon/secvim.git ~/.config/nvim
cd ~/.config/nvim
./install.sh
make check
```

Useful commands:

| Command | Does |
|:--------|:-----|
| `make check` | StyLua check, shellcheck the installer, headless startup |
| `make format` | Run `stylua lua/` |
| `make update` | Sync plugins with Lazy.nvim |
| `make tools` | Install Mason language tools |

The Vim help file is `doc/secvim.txt`. After editing its tags, run
`:helptags doc` and commit the regenerated `doc/tags`.

## Before you open an issue

- Reproduce with a clean `NVIM_APPNAME=secvim` instance.
- Include `:checkhealth secvim`, `:Lazy`, and `:Mason` output when relevant.
- Remove tokens, customer data, and private target names from logs.

## Pull requests

- Keep changes scoped. Separate plugin additions from large refactors.
- Run `stylua lua/` before opening the PR.
- Test on Neovim 0.12+ with `NVIM_APPNAME=secvim nvim --headless "+Lazy! sync" +qa`.
- Update the English and Portuguese READMEs when user-facing keymaps,
  features, or requirements change.
- Do not remove the upstream Rosavim attribution in `LICENSE` or `NOTICE`.

## Security

Secvim is for authorized testing only. Contributions must not add active
scanning, credential collection, or destructive behavior. Report
vulnerabilities privately as described in [SECURITY.md](SECURITY.md).
