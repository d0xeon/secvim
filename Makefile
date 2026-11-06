.DEFAULT_GOAL := help

.PHONY: help install update tools format check

help:
	@printf '%s\n' \
	  'Secvim development commands' \
	  '' \
	  '  make install   Run ./install.sh' \
	  '  make update    Sync plugins with Lazy.nvim' \
	  '  make tools     Install Mason language tools' \
	  '  make format    Format lua/ with StyLua' \
	  '  make check     Format check, shellcheck, and headless startup'

install:
	./install.sh

update:
	nvim --headless "+Lazy! sync" +qa

tools:
	nvim --headless "+MasonToolsInstall" +qa

format:
	stylua lua/

check:
	stylua --check lua/
	@if command -v shellcheck >/dev/null 2>&1; then shellcheck install.sh; else echo "shellcheck not found; skipping install.sh check"; fi
	nvim --headless -u init.lua "+lua print('startup OK')" +qa
