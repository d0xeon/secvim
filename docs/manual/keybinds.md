# Keybindings Reference

> Leader key: `<Space>` | Modes: **n** = normal, **i** = insert, **v** = visual, **x** = visual block, **t** = terminal, **o** = operator-pending, **c** = command
>
> Vim help: `:help secvim` or `:help secvim-keymaps`. This file is the full reference.

## Table of Contents

- [Core](#core)
- [Daily Driver](#daily-driver)
- [VS Code-Style Shortcuts](#vs-code-style-shortcuts)
- [File & Project Navigation](#file--project-navigation)
- [Search & Find](#search--find)
- [LSP](#lsp)
- [Window Management](#window-management)
- [tmux Integration](#tmux-integration)
- [Tabs & Buffers](#tabs--buffers)
- [Git](#git)
- [Testing](#testing)
- [Security Toolbox](#security-toolbox)
- [Build & C/C++](#build--cc)
- [Dev Layout](#dev-layout)
- [Debugging](#debugging)
- [Formatting & Code Actions](#formatting--code-actions)
- [Terminal](#terminal)
- [AI (Copilot & SecAI)](#ai-copilot--secai)
- [File Operations](#file-operations)
- [Secdirs (Projects & Obsidian dirs)](#secdirs-projects--obsidian-dirs)
- [Secsnippets (Snippet Manager)](#secsnippets-snippet-manager)
- [Secpin (Bookmarks)](#secpin-bookmarks)
- [Flash (Motion)](#flash-motion)
- [Yank & Paste (Yanky)](#yank--paste-yanky)
- [UI & Appearance](#ui--appearance)
- [Diagnostics (Trouble)](#diagnostics-trouble)
- [Database (Dadbod)](#database-dadbod)
- [Search & Replace (GrugFar)](#search--replace-grugfar)
- [Obsidian (Notes)](#obsidian-notes)
- [Laravel](#laravel)
- [Spelling](#spelling)
- [macOS Notes](#macos-notes)
- [Lazy (Plugin Manager)](#lazy-plugin-manager)
- [Miscellaneous](#miscellaneous)

---

## Core

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| i | `kj` | Exit insert mode | Type `kj` quickly instead of reaching for `<Esc>` |
| n | `<BS>` | Switch to last buffer | Press backspace to toggle between your two most recent files |
| x | `<C-j>` | Move selection down | Select lines in visual mode, then `Ctrl+j` to move them down |
| x | `<C-k>` | Move selection up | Select lines in visual mode, then `Ctrl+k` to move them up |
| n | `<A-Down>` | Move current line down | Press `Alt+Down` to swap the current line with the one below |
| n | `<leader>w` | Save file | `Space w` to quick-save |
| n | `<leader>W` | Save without formatting | `Space Shift+w` to save without triggering format-on-save |
| n | `<leader>h` | Clear search highlight | `Space h` after a search to remove all highlights |
| n | `<leader>Q` | Quit | `Space Q` to close with confirmation |

---

## Daily Driver

The smallest set worth memorizing. Everything here works in a normal terminal,
inside tmux, and without a kitty-protocol terminal.

| Key | Action |
|:----|:-------|
| `<leader>w` | Save |
| `<leader>q` | Close window |
| `<leader>e` | Focus the sidebar; press again inside it to close |
| `<leader>ff` / `<C-p>` | Find file |
| `<leader>sg` | Live grep (project search) |
| `<leader>/` | Search the current buffer |
| `<C-h/j/k/l>` | Move between Neovim splits and tmux panes |
| `<M-h/j/k/l>` | Resize Neovim splits and tmux panes |
| `<leader>bn` / `<leader>bd` | New buffer / close buffer |
| `<leader>bo` | Close other buffers |
| `<leader>bj` / `<leader>bk` | Previous / next buffer |
| `<leader>tn` / `<leader>tc` | New tab / close tab |
| `Ctrl+G` | Toggle the 2×2 dev layout (code / run / tests / logs) |
| `gcc` / `<C-/>` | Toggle line comment |
| `<M-Up/Down>` | Move the current line up / down |
| `Shift+Alt+Up/Down` | Duplicate line up / down |
| `<leader>lf` | Format file |
| `<leader>la` | Code action |
| `<leader>r` | Rename symbol |
| `<C-\>` | Toggle terminal |
| `F5` / `F7` / `F6` | Debug / build / run C-C++ |
| `<leader>?` | Open this keybindings reference |

---

## VS Code-Style Shortcuts

Terminal-friendly equivalents of the VS Code defaults. VS Code on macOS uses
**Cmd**, which a terminal cannot deliver, so Secvim maps the closest portable
keys: **Ctrl**, **Alt**, and the **F-keys**. Terminals that speak the kitty
keyboard protocol (kitty, WezTerm, Ghostty, foot) also deliver the
`Ctrl+Shift` variants; plain `F1`, `Ctrl+P`, `Ctrl+B`, and the F-keys work
everywhere.

> **Ctrl+S caveat:** some terminals treat `Ctrl+S` as XOFF flow control. If the
> screen freezes, run `stty -ixon` in your shell (add it to `~/.zshrc`) or use
> `<leader>w`.

| Mode | Key | Action |
|:----:|:----|:-------|
| n, i, v | `Ctrl+s` | Save file |
| n | `Ctrl+Shift+s` | Save all |
| n | `Ctrl+p` | Quick open file |
| n, i, v | `F1` | Command palette |
| n | `Ctrl+Shift+p` | Command palette (kitty protocol) |
| n | `Ctrl+f` | Find in current file |
| n | `Ctrl+Shift+f` | Find in all files |
| n | `Ctrl+Shift+o` | Go to symbol in file |
| n | `Ctrl+Shift+g` | Source control: changed files |
| n | `Ctrl+b` | Toggle sidebar explorer |
| n, i, v, t | `` Ctrl+` `` | Toggle terminal |
| n | `Ctrl+z` | Undo |
| n | `Ctrl+Shift+z` | Redo |
| n | `Ctrl+/` or `Ctrl+_` | Toggle line comment |
| x | `Ctrl+/` or `Ctrl+_` | Toggle comment on selection |
| n | `Ctrl+Shift+k` or `Alt+k` | Delete current line |
| n | `Shift+Alt+Down` | Duplicate line down |
| n | `Shift+Alt+Up` | Duplicate line up |
| i | `Ctrl+Space` | Trigger completion |
| n | `F8` / `Shift+F8` | Next / previous problem |
| n | `F2` | Rename symbol |
| n | `F12` | Go to definition |
| n | `Shift+F12` | Find references |
| n | `Alt+F12` | Peek definition in a float |
| n | `F4` / `Alt+O` | Switch header/source (C/C++, clangd) |
| n | `F5` / `Shift+F5` | Debug: start/continue / stop |
| n | `F9` | Debug: toggle breakpoint |
| n | `F10` / `F11` / `Shift+F11` | Debug: step over / into / out |
| n | `F7` / `Ctrl+Shift+B` | Build project (SecBuild) |
| n | `F6` | Compile & run current C/C++ file |
| n | `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous buffer (kitty protocol) |
| n | `Alt+]` / `Alt+[` | Next / previous buffer (works everywhere) |
| n | `Ctrl+F4` | Close buffer |

---

## File & Project Navigation

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>e` | Explorer: focus/toggle | `Space e` focuses the sidebar; press it again inside the sidebar to close it |
| n | `<Esc>` | Close sidebar | While the explorer is focused, `<Esc>` closes it |
| n | `<C-b>` | Toggle sidebar | Works outside tmux; inside tmux the prefix is `Ctrl+a` so `Ctrl+b` reaches Neovim |
| n | `<leader>y` | Yazi file manager | `Space y` opens Yazi in a floating window for full file management |
| n | `<leader><space>` | Find files | `Space Space` then type part of a filename to fuzzy-find it |
| n | `<leader>fs` | Smart find | `Space f s` uses smart context to find the most relevant files |
| n | `<leader>ff` | Find files | `Space f f` opens the file picker |
| n | `<leader>fb` | Find buffers | `Space f b` to switch between open buffers |
| n | `<leader>fg` | Find git files | `Space f g` to search only git-tracked files |
| n | `<leader>fr` | Recent files | `Space f r` to open recently edited files |
| n | `<leader>fc` | Find config file | `Space f c` to quickly jump to a Secvim config file |
| n | `<leader>fp` | Discover projects | `Space f p` to browse and switch between projects |
| n | `<leader>;` | Dashboard | `Space ;` returns to the Secvim dashboard |

---

## Search & Find

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>sg` | Grep | `Space s g` then type a pattern — searches across all project files |
| n | `<leader>sb` | Grep buffers | `Space s b` to search only within open buffers |
| n,x | `<leader>sw` | Grep word | `Space s w` greps the word under cursor or visual selection |
| n | `<leader>/` | Buffer lines | `Space /` to fuzzy-search within the current buffer |
| n | `<leader>:` | Command history | `Space :` to browse and re-run previous commands |
| n | `<leader>s/` | Search history | `Space s /` to browse previous search patterns |
| n | `<leader>sc` | Command history | `Space s c` as an alternative to access command history |
| n | `<leader>sC` | Commands | `Space s Shift+c` to browse all available commands |
| n | `<leader>sd` | Diagnostics | `Space s d` to search all project diagnostics |
| n | `<leader>sD` | Buffer diagnostics | `Space s Shift+d` for current buffer diagnostics only |
| n | `<leader>sH` | Help pages | `Space s Shift+h` to search Neovim help documentation |
| n | `<leader>sh` | Highlights | `Space s h` to browse highlight groups |
| n | `<leader>si` | Icons | `Space s i` to search and insert icons |
| n | `<leader>sj` | Jumps | `Space s j` to browse the jump list |
| n | `<leader>sk` | Keymaps | `Space s k` to search all keybindings |
| n | `<leader>sl` | Location list | `Space s l` to browse the location list |
| n | `<leader>sm` | Marks | `Space s m` to browse marks |
| n | `<leader>sM` | Man pages | `Space s Shift+m` to search man pages |
| n | `<leader>sp` | Plugin spec | `Space s p` to search lazy.nvim plugin specs |
| n | `<leader>sq` | Registers | `Space s q` to browse register contents |
| n | `<leader>sR` | Quickfix list | `Space s Shift+r` to browse the quickfix list |
| n | `<leader>su` | Undo history | `Space s u` to browse and restore from undo tree |
| n | `<leader>sr` | LSP references | `Space s r` to list all usages of the symbol under the cursor (same as `gr`) |
| n | `<leader>ss` | LSP symbols | `Space s s` to search symbols in the current buffer |
| n | `<leader>sS` | Workspace symbols | `Space s Shift+s` to search symbols across the workspace |

---

## LSP

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `gd` | Go to definition | On a function call, press `gd` to jump to where it's defined |
| n | `gD` | Go to declaration | Press `gD` to jump to the symbol's declaration |
| n | `gr` | References | On a function name, press `gr` to see all usages across the project (also `<leader>sr`) |
| n | `gI` | Go to implementation | On an interface method, press `gI` to find its implementations |
| n | `gy` | Go to type definition | Press `gy` to jump to the type definition of the symbol |
| n | `gp` | Secpreview: Definition | Press `gp` to see the definition in a floating preview window |
| n | `gP` | Secpreview: Close All | Press `gP` to close all preview windows |
| n | `<leader>r` | Rename symbol | `Space r` on a variable, type the new name - renames across the project |
| n | `<leader>la` | Code action | `Space l a` to see available code actions (imports, fixes, refactors) |
| n | `<leader>lh` | Toggle inlay hints | Per-buffer toggle. Inlay hints are on by default for Rust, Go, and TS/JS |
| n | `<leader>R` | Rename file | `Space Shift+r` to rename the current file and update all imports |
| n | `<leader>Q` | Secpreview: Expand Vsplit | Open the preview definition in a vertical split |
| n | `<leader>M` | Secpreview: Replace Window | Open the preview definition replacing the current window |

---

## Window Management

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<C-h>` | Move to left split | `Ctrl+h` to move focus to the window on the left |
| n | `<C-j>` | Move to below split | `Ctrl+j` to move focus to the window below |
| n | `<C-k>` | Move to above split | `Ctrl+k` to move focus to the window above |
| n | `<C-l>` | Move to right split | `Ctrl+l` to move focus to the window on the right |
| n | `<left>` | Resize left | Arrow left to shrink/grow the split horizontally |
| n | `<down>` | Resize down | Arrow down to adjust split height |
| n | `<up>` | Resize up | Arrow up to adjust split height |
| n | `<right>` | Resize right | Arrow right to shrink/grow the split horizontally |
| n | `<leader>cq` | Split vertical | `Space c q` to create a vertical split |
| n | `<leader>ce` | Split horizontal | `Space c e` to create a horizontal split |
| n | `<leader>cc` | Close window | `Space c c` to close the current window |
| n | `<leader>cC` | Close other editor windows | `Space c Shift+c` to close the other editor windows, leaving the sidebars and the panels alone |
| n | `<leader>C` | Close everything else | `Space Shift+c` to leave only the focused window - it also takes the Secterm and SecAI panels, the other sidebars and any stray float. The Snacks explorer is the one exception and stays open. Focused on a panel, one editor pane stays behind (Neovim always keeps a native window) |
| n | `<leader>ch` | Swap left | `Space c h` to swap the current window to the left. Focused on a Secterm panel, it trades places with the Secterm on its left and never touches the editor layout |
| n | `<leader>cl` | Swap right | `Space c l` to swap the current window to the right. Focused on a Secterm panel, it trades places with the Secterm on its right |
| n | `<leader>ck` | Swap up | `Space c k` to swap the current window up. Focused on a Secterm panel, it trades places with the Secterm above it |
| n | `<leader>cj` | Swap down | `Space c j` to swap the current window down. Focused on a Secterm panel, it trades places with the Secterm below it |
| n | `<leader>c1` | Resize left 1/3 | Resize the current window to occupy 1/3 from the left |
| n | `<leader>c2` | Resize right 2/3 | Resize the current window to occupy 2/3 from the right |
| n | `<leader>c3` | Resize up 1/3 | Resize the current window to occupy 1/3 from the top |
| n | `<leader>c4` | Resize down 2/3 | Resize the current window to occupy 2/3 from the bottom |
| n | `<leader>cr` | Reset window sizes | Reset all windows to equal sizes |
| n | `<leader>1` | Focus left window | `Space 1` to jump to the left window, including a Secterm/SecAI panel docked there |
| n | `<leader>2` | Focus right window | `Space 2` to jump to the right window, including a Secterm/SecAI panel docked there |
| n | `<leader>3` | Focus bottom window | `Space 3` to jump to the bottom window, including a Secterm/SecAI panel docked there |
| n | `<leader>4` | Focus top window | `Space 4` to jump to the top window, including a Secterm/SecAI panel docked there |
| n | `<leader>cm` | Secmaximize | `Space c m` to maximize the current window or restore the layout (shows a `max` badge + lualine indicator) |
| n | `<leader>m` | Pick a window | `Space m` to visually pick which window to focus |
| n | `<leader>S` | Pick a window | `Space S` does the same as `Space m`, reachable with the left hand alone |
| n | `<M-h/j/k/l>` | Resize split | Alt+h/j/k/l; continues into tmux panes at the edge |

---

## tmux Integration

Secvim ships a tmux config at `sec_bin/tmux.conf`, symlinked to `~/.tmux.conf`.
The smart-splits tmux backend is loaded eagerly so the pane marker is set as
soon as Neovim starts.

### Neovim ↔ tmux navigation

| Key | In Neovim | In a shell pane |
|:----|:----------|:----------------|
| `Ctrl+h/j/k/l` | Move between Neovim splits; at the edge, continue into tmux | Move between tmux panes |
| `Alt+h/j/k/l` | Resize Neovim splits; at the edge, resize the tmux pane | Resize tmux panes |

### tmux prefix: `Ctrl+a`

The default `Ctrl+b` prefix is moved to `Ctrl+a` so `Ctrl+b` can toggle
Neovim's sidebar inside tmux. Press `Ctrl+a` twice to send a literal `Ctrl+a`
(Neovim's number increment).

| Key | Action |
|:----|:-------|
| `Ctrl+a` (then the pipe key) | Split pane vertically |
| `Ctrl+a` `-` | Split pane horizontally |
| `Ctrl+a` `h/j/k/l` | Move between panes |
| `Ctrl+a` `H/J/K/L` | Resize pane (repeatable) |
| `Ctrl+a` `x` | Close pane (confirm) |
| `Ctrl+a` `z` | Zoom / unzoom pane |
| `Ctrl+a` `c` | New window (tmux tab) in the current directory |
| `Ctrl+a` `n` / `p` | Next / previous window |
| `Ctrl+a` `&` / `X` | Close window (confirm) |
| `Ctrl+a` `s` | Session / window picker |
| `Ctrl+a` `(` / `)` | Previous / next session |
| `Ctrl+a` `[` | Copy mode (`v` select, `y` yank, `Ctrl+v` block) |
| `Ctrl+a` `r` | Reload tmux config |

The tmux side forwards the movement keys only when `@pane-is-vim` is set by the
smart-splits backend. Verify with:

```sh
tmux show-options -p -v @pane-is-vim
nvim "+checkhealth smart-splits"
```

---

## Tabs & Buffers

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>J` | Previous buffer | `Space Shift+j` to go to the previous buffer |
| n | `<leader>K` | Next buffer | `Space Shift+k` to go to the next buffer |
| n | `<leader>tt` | New tab | `Space t t` to create a new tab |
| n | `<leader>tn` | New tab (alias) | `Space t n` — same as `<leader>tt` |
| n | `<leader>tj` | Previous tab | `Space t j` to go to the previous tab |
| n | `<leader>tk` | Next tab | `Space t k` to go to the next tab |
| n | `<leader>tc` | Close tab | `Space t c` to close the current tab |
| n | `<leader>tC` | Close other tabs | `Space t Shift+c` to close all tabs except the current one |
| n | `<leader>t1`-`t0` | Go to tab N | `Space t 1` through `t 0` to jump to tab 1-10 |
| n | `<leader>tf` | Pick tab (Snacks) | `Space t f` to open a tab picker and switch tabs |
| n | `<leader>st` | Pick tab (Snacks) | `Space s t` to open a tab picker and switch tabs |
| n | `<leader>fw` | Pick tab (Snacks) | `Space f w` to open a tab picker and switch tabs |

### Bufferline

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>bn` | New buffer | `Space b n` opens a blank buffer (the buffer-tab equivalent of a new file) |
| n | `<leader>bd` | Close buffer | `Space b d` closes the current buffer and keeps the window layout |
| n | `<leader>bo` | Close other buffers | `Space b o` closes every other listed buffer |
| n | `<leader>bb` | Pick buffer | `Space b b` to pick a buffer by letter |
| n | `<leader>bf` | Find buffers | `Space b f` to search open buffers |
| n | `<leader>bp` | Pick close buffer | `Space b p` to pick a buffer to close |
| n | `<leader>bh` | Close left | `Space b h` to close all buffers to the left |
| n | `<leader>bl` | Close right | `Space b l` to close all buffers to the right |
| n | `<leader>bC` | Close others | `Space b Shift+c` to close all buffers except the current one |
| n | `<leader>bj` | Previous buffer | `Space b j` to cycle to the previous buffer |
| n | `<leader>bk` | Next buffer | `Space b k` to cycle to the next buffer |
| n | `<leader>bq` | Sort by directory | `Space b q` to sort buffers by directory |
| n | `<leader>be` | Sort by extension | `Space b e` to sort buffers by file extension |
| n | `<leader>br` | Sort by relative dir | `Space b r` to sort buffers by relative directory |
| n | `<leader>q` | Close window | `Space q` closes the current window (same as `Space c c`) |
| n | `<leader>lb` | Toggle bufferline | `Space l b` to show/hide the buffer tab bar |

---

## Git

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>gt` | Toggle line blame | `Space g t` to show/hide inline blame on the current line |
| n | `<leader>gl` | Blame line (float) | `Space g l` to see blame info in a floating window |
| n | `<leader>gg` | Lazygit | `Space g g` to open lazygit in a floating terminal |
| n | `<leader>gc` | Git log | `Space g c` to browse the commit log |
| n | `<leader>gb` | Git branches | `Space g b` to browse and switch branches |
| n | `<leader>gs` | Git status | `Space g s` to see the current git status |
| n | `<leader>gS` | Git stash | `Space g Shift+s` to browse stashed changes |
| n | `<leader>gd` | Git diff (hunks) | `Space g d` to browse diff hunks |
| n | `<leader>gf` | Git log (file) | `Space g f` to see the git log for the current file |
| n | `<leader>gL` | Git log (line) | `Space g Shift+l` to see the git log for the current line |
| n | `<leader>gr` | Git Review | `Space g r` to open/toggle a keep/reject review of **all** changes vs `HEAD` (same panel as the AI review) |

---

## Testing

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>nn` | Sectest menu | `Space n n` with cursor inside a test function to run just that test |
| n | `<leader>nf` | Run file tests | `Space n f` to run all tests in the current file |
| n | `<leader>nl` | Run last test | `Space n l` to re-run the last executed test |
| n | `<leader>ns` | Stop tests | `Space n s` to stop currently running tests |
| n | `<leader>no` | Test output | `Space n o` to see the output of the last test run |
| n | `<leader>np` | Output panel | `Space n p` to open the test output panel |
| n | `<leader>nt` | Test summary | `Space n t` to toggle the test summary sidebar |
| n | `<leader>nw` | Watch file | `Space n w` to watch the file and re-run tests on save |
| n | `<leader>nga` | Go: Add test | `Space n g a` to generate a test for the current Go function |
| n | `<leader>ngA` | Go: Add all tests | `Space n g Shift+a` to generate tests for all Go functions in the file |

> **Foundry / Solidity:** Sectest detects `foundry.toml` and runs `forge test`,
> including nearest-test detection for `test_*` and `invariant_*` functions.
> **C/C++:** CTest is detected from `build/CTestTestfile.cmake`, with
> GoogleTest / Catch2 test-name detection for nearest-test runs. Makefile
> projects with a `test:` target fall back to `make test`.
> Python tests use `VIRTUAL_ENV`, `.venv`, `venv`, or `.env` automatically,
> falling back to `python3`.

---

## Security Toolbox

Local, offline text transforms for payload decoding and inspection. No network
calls are made.

| Mode | Key | Action |
|:----:|:----|:-------|
| n | `<leader>kt` | Transform the word under the cursor (prompts for input) |
| x | `<leader>kt` | Transform the selection in place |
| n | `<leader>kx` | Hex dump the current file (first 64 KiB) |

Transforms: Base64 encode/decode, Base64URL encode/decode, URL encode/decode,
hex encode/decode, JWT decode (header + payload), JSON pretty-print, and JSON
minify. Results are copied to the system clipboard; decoded output opens in a
scratch float (`q` or `<Esc>` closes it).

---

## Build & C/C++

SecBuild detects the project type from the current buffer's root and runs the
build in a terminal split. C/C++ files additionally get a compile-and-run menu
with sanitizer instrumentation.

| Mode | Key | Action |
|:----:|:----|:-------|
| n | `F7` | Build project (CMake, Meson, Make, Cargo, Go, Foundry, npm) |
| n | `Ctrl+Shift+B` | Build project — kitty protocol; `F7` works everywhere |
| n | `F6` | Compile & run current C/C++ file: plain, ASan + UBSan, or compile only |
| n | `F4` / `Alt+O` | Switch between header and source (clangd) |
| n | `<leader>kb` | SecBuild menu: build, run, compile_commands.json, CTest |
| n | `<leader>kk` | SecKit C/C++ sections: sources, headers, tests, fuzzing, build files |

C/C++ build details:

- `F7`/`Ctrl+Shift+B` runs `cmake --build build -j` for CMake projects,
  configuring with `CMAKE_EXPORT_COMPILE_COMMANDS=ON` and symlinking
  `compile_commands.json` into the project root when needed. If the cache has
  no build type, it configures `CMAKE_BUILD_TYPE=Debug`.
- Meson uses `meson compile -C build`; Make uses `make -j`.
- `F6` compiles to `stdpath('cache')/secbuild` with `-g -O0 -Wall -Wextra`;
  the ASan option adds `-fsanitize=address,undefined
  -fno-omit-frame-pointer`.
- CTest is available through Sectest (`<leader>nr` / `<leader>nf` /
  `<leader>na`) for GoogleTest and Catch2 test names.

---

## Dev Layout

`Ctrl+G` (or `:SecLayout`) toggles a Neovim-native 2×2 grid in its own tab:

```text
┌──────────────┬──────────────┐
│ code window  │ Run          │
├──────────────┼──────────────┤
│ Logs         │ Tests        │
└──────────────┴──────────────┘
```

| Key | Action |
|:----|:-------|
| `Ctrl+G` | Open/focus the layout; press again inside it to close |
| `<leader>lw` | Same as `Ctrl+G` |
| `:SecLayout` / `:SecLayoutClose` | Command equivalents |
| `Ctrl+P` / `<leader>ff` | Project file search; plain `<CR>` opens in the code pane |
| `Ctrl+h/j/k/l` | Move between the four panes and Neovim splits |
| `Esc` or `jk` | Leave terminal mode |
| `Ctrl+h/j/k/l` in terminal mode | Move to another pane |

The three terminal commands are configured in
`lua/secvim/config/layout.lua`:

```lua
commands = {
  run = '',   -- top-right: build / execute / dev server
  tests = '', -- bottom-right: test runner / watch mode
  logs = '',  -- bottom-left: logs, AI CLI, notes
}
```

Leave a command empty for an interactive shell. Each command is typed into a
live shell, so the prompt is still there when the command finishes. The layout
is Neovim-native: closing Neovim ends the terminals. The minimap is suppressed
in this tab so the grid stays exactly 2×2.

---

## Debugging

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>ds` | Start / Continue | `Space d s` to start the debugger or continue execution |
| n | `<leader>dq` | Terminate | `Space d q` to stop the debug session |
| n | `<leader>db` | Toggle breakpoint | `Space d b` on any line to set/remove a breakpoint |
| n | `<leader>dc` | Clear breakpoints | `Space d c` to remove all breakpoints |
| n | `<leader>dt` | Toggle DAP UI | `Space d t` to open/close the debug UI panels |
| n | `<leader>df` | DAP UI float | `Space d f` to open the debug UI in a floating window |
| n | `<leader>dd` | Step over | `Space d d` to execute the current line and move to the next |
| n | `<leader>di` | Step into | `Space d i` to step into a function call |
| n | `<leader>do` | Step out | `Space d o` to step out of the current function |
| n | `<leader>dp` | Pause | `Space d p` to pause a running debug session |
| n | `<leader>dr` | Rerun | `Space d r` to restart the debug session |
| n | `<leader>dR` | Restart frame | `Space d Shift+r` to restart the current stack frame |
| n | `<leader>dn` | New session | `Space d n` to start a new debug configuration |
| n | `<leader>de` | Eval expression | `Space d e` to evaluate an expression in the debug context |
| n | `<leader>dD` | Disconnect | `Space d Shift+d` to disconnect from the debug adapter |

---

## Formatting & Code Actions

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n,v | `<leader>lf` | Format file/selection | `Space l f` to format the current file — or select lines first to format only those |

---

## Terminal

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n,t | `<C-\>` | Toggle terminal | `Ctrl+\` to open/close a floating terminal |
| n,t | `<S-x>` | Horizontal terminal | `Shift+x` to toggle a horizontal split terminal |
| n,t | `<S-z>` | Float terminal | `Shift+z` to toggle a floating terminal |
| n | `<leader>cii` | Horizontal split | `Space c i i` to open a horizontal terminal split |
| n | `<leader>cie` | Vertical split | `Space c i e` to open a vertical terminal split |

With a Secterm panel focused, the arrow keys resize it in **normal mode** only (vertical panel changes width, horizontal changes height, docked pairs answer all four arrows). In terminal/insert mode the arrows stay free for the shell itself, so `<up>` still walks the command history. Press `<Esc>` to drop to normal mode first when you want to resize.

---

## AI (Copilot & SecAI)

### Copilot

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| i | `<Tab>` | Accept suggestion | While typing, press `Tab` to accept the Copilot suggestion |
| i | `<C-l>` | Next suggestion | `Ctrl+l` to cycle to the next Copilot suggestion |
| i | `<C-h>` | Previous suggestion | `Ctrl+h` to cycle to the previous Copilot suggestion |
| i | `<C-d>` | Dismiss suggestion | `Ctrl+d` to dismiss the current Copilot suggestion |
| n | `<leader>aia` | Auth | `Space a i a` to authenticate with GitHub Copilot |
| n | `<leader>aii` | Toggle | `Space a i i` to toggle Copilot on/off (persisted) |
| n | `<leader>ail` | Lualine icon | `Space a i l` to show/hide the Copilot icon on the statusline (persisted) |
| n | `<leader>aip` | Panel | `Space a i p` to open the Copilot suggestions panel |

### SecAI

Native AI CLI integration for Claude, Cursor, OpenClaude, OpenCode, Gemini and friends. Each tool gets its own persistent terminal session — switching tools or layouts preserves history. The picker on `<leader>aa` only appears the very first time; after that it just toggles the last open layout.

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n,t,i,x | `<C-.>` | Focus SecAI | `Ctrl+.` to focus the SecAI window |
| n | `<leader>aa` | Toggle CLI (smart) | First time prompts layout `v/h/f`; afterwards toggles last layout |
| x | `<leader>aa` | Ask AI (preview + prompt) | Select code, `Space a a` to open a preview window + prompt below |
| n | `<leader>av` | Open Vertical | Opens (or hides if already vertical) on the right/left edge |
| n | `<leader>ah` | Open Horizontal | Opens (or hides if already horizontal) at the bottom |
| n | `<leader>af` | Open Float | Opens (or hides if already float) as a centered floating window |
| n | `<leader>as` | Select CLI | Pick from the list of CLIs whose binary is installed |
| n,x | `<leader>at` | Send `{this}` | Send the current cursor reference (`@file:line`) |
| n | `<leader>al` | Send `{file}` | Send the whole file reference (`@file`) |
| x | `<leader>av` | Send selection | Send the visual selection range (`@file:start-end`) |
| n,x | `<leader>ap` | Select prompt | Pick from built-in prompt templates (explain / review / refactor / ...) |
| n | `<leader>ac` | Toggle Claude Code | Open/hide Claude Code (`claude`) |
| n | `<leader>au` | Toggle Cursor | Open/hide `cursor-agent` |
| n | `<leader>ao` | Toggle OpenClaude | Open/hide `openclaude` |
| n | `<leader>ae` | Toggle OpenCode | Open/hide `opencode` |
| n | `<leader>ag` | Toggle Gemini | Open/hide `gemini` |
| n | `<leader>ar` | Review AI Changes | `Space a r` to open/toggle the review of **AI-only** edits (green/red inline diffs + overview panel) |
| n | `<leader>ab` | Mark Review Baseline | `Space a b` to manually set the "before" point the review compares against |
| n | `<leader>aR` | Review (master switch) | `Space a R` to enable/disable the whole Review feature - when off, `<leader>ar` / `<leader>ab` are removed and no baseline is captured (persisted) |
| n | `<leader>aA` | Auto Review | `Space a A` to auto-open the review panel after the AI finishes editing files (persisted, off by default) |

Inside the CLI terminal: single `<Esc>` exits to nvim normal mode; double `<Esc>` within 300ms sends a literal `ESC` to the CLI (cancel current operation). In **normal mode** the arrow keys resize the window (vertical → width, horizontal → height, float → both axes, kept centered); the size persists per position until you pick a named size preset. The arrows stay free for the CLI itself while in terminal/insert mode. While SecAI is focused, the lualine mode block shows `SECAI`.

#### Review AI Changes

`<leader>ar` opens a Cursor/VSCode-style review of the file edits SecAI made on disk, comparing against a snapshot baseline taken automatically when you opened the CLI. It shows **only the AI's own changes**: the AI's result is frozen at the end of each turn, so edits you make yourself afterwards are filtered out of the panel (a manual edit landing exactly on top of an AI hunk is the one ambiguous case). Changes show as green/red inline diffs, and a floating overview panel lists every touched file so you can keep or reject each hunk. The panel has a built-in search box to fuzzy-filter the list, an `f` filter to narrow by git status, and a `p` preview that shows a file's diff in a secpreview float beside the panel.

Want to review **everything** in the repo (your edits included), not just the AI's? Use `<leader>gr` (**Git Review**) — the exact same panel and keys, but diffed against `HEAD`.

**In the overview panel (normal mode):**

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `j` / `k` (or `↓`/`↑`) | Move down / up | Move between the listed files |
| n | `a` / `i` / `/` | Search files | Enter the search box and fuzzy-filter the list as you type |
| n | `<CR>` | Jump to hunk | Open the file and jump to the change under the cursor |
| n | `e` | Keep file | Accept all changes in the selected file |
| n | `r` | Reject file | Discard all changes in the selected file |
| n | `p` | Preview | Open the selected file's diff in a secpreview float beside the panel |
| n | `f` | Filter by status | Cycle the list: all → added → modified (shown in the title) |
| n | `A` | Keep all | Accept every pending change across all files |
| n | `R` | Reject all | Discard every pending change across all files |
| n | `q` / `<Esc>` | Close panel | Close the overview panel |

**In the search box (insert mode):**

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| i | *(type)* | Filter | Fuzzy-filter the file list live as you type |
| i | `↓`/`↑`, `<C-j>`/`<C-k>`, `<C-n>`/`<C-p>` | Move selection | Move the highlighted file without leaving the box |
| i | `<CR>` | Jump | Jump to the selected file |
| i | `<C-f>` | Filter by status | Cycle the status filter without leaving the box |
| i | `<Esc>` | Back to list | Return to the list in normal mode (keeps the filter) |
| i | `<C-c>` | Close panel | Close the whole panel |

**In a reviewed buffer:**

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `]h` | Next hunk | Jump to the next AI change in the file |
| n | `[h` | Previous hunk | Jump to the previous AI change in the file |
| n | `<leader>ak` | Keep hunk | Accept the change under the cursor |
| n | `<leader>ax` | Reject hunk | Discard the change under the cursor |
| n | `<leader>aK` | Keep all | Accept every change in the file |
| n | `<leader>aX` | Reject all | Discard every change in the file |
| n | `<leader>ar` | Reopen panel | Reopen the floating overview panel |

---

## File Operations

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>xx` | Secfile menu | `Space x x` to open the file operations popup |
| n | `<leader>xa` | Create file here | `Space x a` to create a file in the current directory |
| n | `<leader>xd` | Delete file | `Space x d` to delete the current file |
| n | `<leader>xn` | Rename file | `Space x n` to rename the current file |
| n | `<leader>xc` | Duplicate file | `Space x c` to duplicate the current file |
| n | `<leader>xi` | File info | `Space x i` to show current file information |
| n | `<leader>xr` | Create from root | `Space x r` to create a file from project root |

---

## Secdirs (Projects & Obsidian dirs)

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>lp` | Secdirs menu | `Space l p` to open the directory manager popup |
| n (in menu) | `a` | Add project | Type a path (use `/*` to treat subfolders as projects) |
| n (in menu) | `d` | Remove project | Picker opens with all project entries |
| n (in menu) | `c` | Clear projects | Confirms then removes every project directory |
| n (in menu) | `A` | Add Obsidian vault | Type the vault path |
| n (in menu) | `D` | Remove Obsidian vault | Picker opens with all vault entries |
| n (in menu) | `C` | Clear Obsidian vaults | Confirms then removes every vault |
| n (in menu) | `X` | Clear EVERYTHING | Wipes both lists after confirm |
| n (in menu) | `q` / `<Esc>` | Close | Closes the menu |

> Changes apply live: project updates take effect immediately, and Obsidian re-runs `Workspace.setup` if already loaded. Only the **first** Obsidian vault added in a session needs a restart (the plugin was skipped at startup).

---

## Secsnippets (Snippet Manager)

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>lo` | Secsnippets panel | `Space l o` opens the snippet manager (grouped list + live-filter search bar) |
| n (panel) | `↵` | Edit body | Body editor with syntax highlight and autosave — changes hot-reload into completion |
| n (panel) | `a` | Add snippet | 4-step wizard: filetype → trigger → description → starter preset, ending in the body editor |
| n (panel) | `e` | Edit trigger/desc | Two prefilled prompts (`Edit 1/2 · Trigger`, `Edit 2/2 · Description`), saved as confirmed |
| n (panel) | `d` | Delete snippet | Asks for confirmation |
| n (panel) | `o` | Open JSON file | Jumps straight to the snippet inside `snippets/<filetype>.json` |
| n (panel) | `p` | Preview file | Secpreview docks beside the panel (slides back on close) |
| n (panel) | `f` | Filter by language | Mini popup (same style as the theme selector); `none` clears — active filter shows in the title |
| n (panel) | `t` | Presets | Save the selected snippet as a personal preset, or browse all presets |
| n (panel) | `/` or `i` | Search | Fuzzy live filter; `<C-j>`/`<C-k>` move the selection while typing, `<Esc>` keeps the filter |
| n (panel) | `q` / `<Esc>` | Close | Closes the panel |
| i (body editor) | `<C-t>` | Next tabstop | Inserts the next numbered `${N:}` at the cursor |
| n (preset browser) | `j`/`k` | Navigate | The read-only preview pane follows the selection live |
| n (preset browser) | `e` / `r` / `d` | Edit body / rename / delete | Personal presets (★) only — built-ins are view-only |

> Snippets are VSCode-format JSON in `snippets/<filetype>.json`, expanded by native `vim.snippet` (`<Tab>`/`<S-Tab>` jump between placeholders while a snippet is active). Personal presets live in `~/.config/secsnippets/templates.json` — outside the Secvim config, so they never ship with the distro. Every change hot-reloads into blink.cmp instantly, no restart.

---

## Secpin (Bookmarks)

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>oo` | Pin | `Space o o` to pin/unpin the current file |
| n | `<leader>oe` | Menu | `Space o e` to manage pinned files (jump, delete, reorder) |
| n | `dd` (in menu) | Remove pin | In the Secpin menu, `dd` on a tag to remove it |
| v | `d` (in menu) | Remove selected | In the Secpin menu, select tags in visual mode and `d` to remove them |
| n | `DD` (in menu) | Remove all | In the Secpin menu, `DD` to remove all tags at once |
| n | `<leader>o1`-`o0` | Jump 1-10 | `Space o 1` to instantly jump to your first pinned file |
| n | `<leader>of` | Search | `Space o f` to fuzzy-search pinned files |
| n | `<leader>oj` | Prev | `Space o j` to cycle to the previous pin |
| n | `<leader>ok` | Next | `Space o k` to cycle to the next pin |

---

## Flash (Motion)

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n,x,o | `s` | Flash jump | Press `s` then type characters — labels appear for instant jumping |
| n,x,o | `S` | Flash treesitter | Press `Shift+s` to select treesitter nodes with labels |
| o | `r` | Remote flash | In operator-pending mode, `r` to flash-jump to a remote location |
| o,x | `R` | Treesitter search | `Shift+r` to search and select treesitter nodes |
| c | `<C-s>` | Toggle flash search | `Ctrl+s` in command mode to toggle flash for `/` searches |

---

## Yank & Paste (Secyank)

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n,x | `<leader>p` | Yank history | `Space p` to browse and paste from yank history (persisted across sessions) |
| n | `<leader>P` | Yank menu | `Space P` to open yank menu with numbered entries, `dd` remove, `DD` clear all |

---

## UI & Appearance

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>lqt` | Toggle dark/light | `Space l q t` to switch between dark and light mode |
| n | `<leader>lqij` | Invert BG: secjet | `Space l q i j` swaps secjet's editor background with its explorer/tab chrome background |
| n | `<leader>lqim` | Invert BG: secmin | `Space l q i m` same swap for secmin |
| n | `<leader>lqiv` | Invert BG: secvintage | `Space l q i v` same swap for secvintage |
| n | `<leader>lqs` | Select theme | `Space l q s` to pick one of the bundled themes (secmin / secvintage / secnight / secjet) |
| n | `<leader>lqm` | Select Render Markdown theme | `Space l q m` to pick the render-markdown preset (none / lazy / obsidian) |
| n | `<leader>lqg` | Select lualine separator | `Space l q g` to pick a statusline separator preset (rounded / bar / arrow / slant) |
| n | `<leader>lqe` | Toggle transparent | `Space l q e` to toggle background transparency |
| n | `<leader>lqna` | Borderless: All | `Space l q n a` to blend every tool's borders into their own bg at once (persists) |
| n | `<leader>lqnw` | Borderless: Which-Key | `Space l q n w` to blend only the which-key border |
| n | `<leader>lqns` | Borderless: Snacks Picker | `Space l q n s` to blend the snacks picker input, list, preview and outer box borders |
| n | `<leader>lqnp` | Borderless: Secpick | `Space l q n p` to blend only the secpick label border |
| n | `<leader>lqnb` | Borderless: Blink.cmp | `Space l q n b` to blend the completion menu, docs and signature borders |
| n | `<leader>lqnr` | Borderless: Secterm | `Space l q n r` to blend the secterm float, split and title chip borders |
| n | `<leader>lqni` | Borderless: SecAI | `Space l q n i` to blend the SecAI panel, chip and ask/preview borders |
| n | `<leader>lqnn` | Borderless: Notify | `Space l q n n` to blend the notification borders on every level |
| n | `<leader>lqfa` / `<leader>lqfA` | Force dark bg: All | `Space l q f a` (light mode) / `Space l q f A` (dark mode) to flip the #000 background on secterm, secai, yazi and lazygit at once; reads as on only while all four are on (persists) |
| n | `<leader>lqfr` / `<leader>lqfR` | Secterm force dark bg | `Space l q f r` (light mode) / `Space l q f R` (dark mode) to force a #000 background on Secterm instead of the theme bg (persists) |
| n | `<leader>lqfi` / `<leader>lqfI` | SecAI force dark bg | `Space l q f i` (light mode) / `Space l q f I` (dark mode) to force a #000 background on the SecAI panel instead of the theme bg (persists) |
| n | `<leader>lqfy` / `<leader>lqfY` | Yazi force dark bg | `Space l q f y` (light mode) / `Space l q f Y` (dark mode) to force a #000 background on the yazi float instead of the theme bg (persists) |
| n | `<leader>lqfg` / `<leader>lqfG` | Lazygit force dark bg | `Space l q f g` (light mode) / `Space l q f G` (dark mode) to force a #000 background on the lazygit float instead of the theme bg (persists) |
| n | `<leader>lqy` | Toggle lualine bar-y transparency | `Space l q y` — on (default) blends the lualine centre/y bar with the theme bg; off shows the original solid `#1a1a1a` bar (works in both auto and custom lualine themes) |
| n | `<leader>lqdt` | Toggle dashboard gif | `Space l q d t` to enable/disable the chafa gif (persisted, hot-reload) |
| n | `<leader>lqds` | Search dashboard gif | `Space l q d s` to pick a new image from `dashboard_img/` (persisted, hot-reload) |
| n | `<leader>lqdc` | Configure dashboard gif | `Space l q d c` opens a popup — press `h`, `w`, or `i` to edit just height/width/indent (persisted, hot-reload) |
| n | `<leader>lw` | Toggle wrap | `Space l w` to toggle line wrapping |
| n | `<leader>lg` | Toggle relative numbers | `Space l g` to toggle relative line numbers |
| n | `<leader>ln` | Toggle line numbers | `Space l n` to toggle line numbers on/off |
| n | `<leader>lz` | Toggle Seczen | `Space l z` to toggle Seczen — distraction-free mode (maximizes + centers the window, hides UI chrome; persists across sessions) |
| n | `<leader>li` | Toggle indent guides | `Space l i` to toggle indent guide lines |
| n | `<leader>lk` | Toggle dim | `Space l k` to dim inactive code |
| n | `<leader>ly` | Toggle cursor shape | `Space l y` — on by default (block cursor in normal mode); turn off for a thin vertical bar (`ver25`) in every mode |
| n | `<leader>lY` | Toggle cursor line | `Space l Y` to show/hide the current-line highlight (on by default) |
| n | `<leader>ll` | Toggle lualine | `Space l l` to show/hide the statusline |
| n | `<leader>lu` | Toggle dropbar | `Space l u` to show/hide the breadcrumb bar |
| v | `an` | Select parent node | In visual mode, expand selection to the parent treesitter node |
| v | `in` | Select child node | In visual mode, shrink selection to a child treesitter node |
| v | `]n` | Next sibling node | In visual mode, move selection to the next sibling node |
| v | `[n` | Previous sibling node | In visual mode, move selection to the previous sibling node |
| n | `<leader>lc` | Toggle Incline | `Space l c` to show/hide the floating filename indicator |
| n | `<leader>ls` | Toggle auto-save | `Space l s` to enable/disable auto-save |
| n | `<leader>lm` | Toggle Image Preview | `Space l m` to toggle persistent image preview on/off (default: off) |
| n | `<leader>laml` | Secmaximize lualine indicator | `Space l a m l` to show/hide the `max` indicator on the lualine |
| n | `<leader>lamb` | Secmaximize buffer badge | `Space l a m b` to show/hide the floating `max` badge on the buffer |
| n | `<leader>lamn` | Secmaximize name/icon | `Space l a m n` to switch between the `max` text and icon-only |
| n | `<leader>lqx` | Secmaximize border | `Space l q x` to open a popup to select the badge border (none / rounded / straight) |
| n | `<leader>lv` | Toggle Sectag | `Space l v` to enable/disable the whole Sectag plugin (auto close + live rename, default: on) |
| n | `<leader>latc` | Sectag auto close tag | `Space l a t c` to enable/disable auto closing tags (default: on) |
| n | `<leader>latr` | Sectag auto live rename tag | `Space l a t r` to enable/disable live renaming of the paired tag (default: on) |
| n | `<leader>lqp` | Picker Layout | `Space l q p` to open a popup to select picker layout preset |
| n | `<leader>lasp` | Picker Preview | `Space l a s p` to toggle picker preview on/off |
| n | `<leader>lass` | Smooth Scrolling | `Space l a s s` to toggle the scroll animation on/off (default: on) |
| n | `<leader>lqo` | Picker Border | `Space l q o` to open a popup to select picker border style |
| n | `<leader>lqw` | Which-Key Preset | `Space l q w` to open a popup to select which-key preset |
| n | `<leader>lqb` | Which-Key Border | `Space l q b` to open a popup to select which-key border style |
| n | `<leader>uu` | Toggle Render Markdown | `Space u t` to toggle enhanced markdown rendering |
| n | `<leader>ua` | Markdown preview | `Space u a` to open markdown preview in the browser |
| n | `<leader>zz` | Pick winbar symbol | `Space z z` to pick a symbol from the breadcrumb bar |

---

## Diagnostics (Trouble)

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>,,` | Diagnostics | `Space , ,` to open the diagnostics panel for the whole project |
| n | `<leader>,x` | Buffer diagnostics | `Space , x` to see diagnostics for the current buffer only |
| n | `<leader>,s` | Symbols | `Space , s` to browse document symbols in Trouble |
| n | `<leader>,l` | LSP references | `Space , l` to see LSP definitions and references |
| n | `<leader>,g` | Location list | `Space , g` to browse the location list |
| n | `<leader>,q` | Quickfix list | `Space , q` to browse the quickfix list |

---

## Database (Dadbod)

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>vb` | Toggle DBUI | `Space v b` to open the database UI |
| n | `<leader>va` | Add connection | `Space v a` to add a new database connection string |
| n | `<leader>vf` | Find buffer | `Space v f` to find a specific query buffer |

---

## Search & Replace (GrugFar)

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>lee` | GrugFar | `Space l e e` to open the search & replace panel |
| n | `<leader>lei` | GrugFar (current file) | `Space l e i` to search & replace in the current file only |
| v | `<leader>lev` | GrugFar (selection) | Select text, `Space l e v` to search & replace the selection |
| n | `<leader>lew` | GrugFar (word) | `Space l e w` to search & replace the word under cursor |

---

## Todo Comments

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `]t` | Next todo | `]t` to jump to the next TODO/FIXME/HACK comment |
| n | `[t` | Previous todo | `[t` to jump to the previous TODO comment |
| n | `<leader>ftt` | Find all todos | `Space f t t` to search all TODO comments in the project |
| n | `<leader>ftf` | Find FIX | `Space f t f` to find all FIX/FIXME comments |
| n | `<leader>fte` | Find TODO | `Space f t e` to find all TODO comments |
| n | `<leader>ftn` | Find NOTE | `Space f t n` to find all NOTE comments |
| n | `<leader>fti` | Find INFO | `Space f t i` to find all INFO comments |
| n | `<leader>fth` | Find HACK | `Space f t h` to find all HACK comments |
| n | `<leader>ftw` | Find WARN | `Space f t w` to find all WARN comments |
| n | `<leader>lh` | Toggle plugin | `Space l h` to enable/disable todo-comments entirely (persists) |
| n | `<leader>lqcb` | Toggle background | `Space l q c b` to toggle the colored background chip (persists) |
| n | `<leader>lqcf` | Toggle foreground | `Space l q c f` to color the text instead of the background (persists) |

---

## CodeSnap (Screenshots)

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| x | `<leader>lP` | Snap to clipboard | Select code, `Space l Shift+p` to copy a screenshot to clipboard |
| x | `<leader>lp` | Snap to file | Select code, `Space l p` to save a screenshot |
| x | `<leader>lH` | Highlight to clipboard | Select code, `Space l Shift+h` for a highlighted screenshot |
| x | `<leader>lh` | Highlight to file | Select code, `Space l h` to save a highlighted screenshot |
| x | `<leader>la` | ASCII snap | Select code, `Space l a` for an ASCII art screenshot |

---

## Obsidian (Notes)

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>jj` | Search notes | `Space j j` to fuzzy-search all notes in your vault |
| n | `<leader>jo` | Open Obsidian | `Space j o` to open the Obsidian app |
| n | `<leader>jd` | Daily note | `Space j d` to open/create today's daily note |
| n | `<leader>jy` | Yesterday's note | `Space j y` to open yesterday's daily note |
| n | `<leader>jt` | Tomorrow's note | `Space j t` to open tomorrow's daily note |
| n | `<leader>jg` | List dailies | `Space j g` to browse all daily notes |
| n | `<leader>js` | Search (Obsidian) | `Space j s` to search notes using Obsidian's search |
| n | `<leader>jr` | Rename note | `Space j r` to rename the current note |
| n | `<leader>je` | Extract note | `Space j e` to extract a section into a new note |
| n | `<leader>jl` | Link new note | `Space j l` to create and link a new note |
| n | `<leader>ja` | From template | `Space j a` to create a note from a template |
| n | `<leader>jz` | New note | `Space j z` to create a blank note |
| n | `<leader>jb` | Backlinks | `Space j b` to see all notes linking to this one |
| n | `<leader>jp` | Paste image | `Space j p` to paste an image from clipboard |
| n | `<leader>jc` | Toggle checkbox | `Space j c` to toggle a checkbox in a markdown list |
| n | `<leader>jm` | Toggle checkbox (alt) | `Space j m` alternative checkbox toggle |

---

## Secvisualmulti (Multi-cursor)

Cursors live on extmarks, so they follow every edit. A session ends with `<Esc>` or when you switch to another file.

**Creating cursors**

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<C-n>` | Select word under cursor, then each next occurrence | `Ctrl n` on `pedro`, again for the next `pedro` |
| x | `<C-n>` | One cursor per line of the visual selection | `V j j` then `Ctrl n` to get 3 cursors |
| n | `<C-Down>` / `<C-Up>` | Add a cursor on the line below / above, same column | column editing, ignores the text |
| n | `<leader>kva` | Select every occurrence at once | `Space k v a` |

**Managing cursors**

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `n` / `N` | Add the next / previous occurrence | `N` also recovers an occurrence you skipped |
| n | `q` | Skip: drop the current cursor and take the next occurrence | keeps the cursor count |
| n | `Q` | Remove the current cursor, no replacement | lowers the cursor count |
| n | `[` / `]` | Move between the cursors you already have | does not change the list |
| n | `<Esc>` | End the session | |

**Editing at every cursor**

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `i` `a` `I` `A` | Insert before / after / at line start / at line end | what you type lands on every cursor when you press `<Esc>` |
| n | `c` | Change the selection | |
| n | `d` / `x` | Delete the selection | |
| n | `D` | Delete the whole lines | |
| n | `y` / `p` / `P` | Yank / paste over / paste before | |
| n | `gu` / `gU` / `~` | Lowercase / uppercase / toggle case | |
| n | `.` | Run an arbitrary normal command at every cursor | `ci"new`, `>>`, `dt,`, `cit` |
| n | `@` | Run a macro from a register at every cursor | |

**Menu and popups**

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>kvv` | Action menu. Its entries change depending on whether a session is active | `Space k v v` |
| n | `<leader>kvr` | Rename popup, prefilled with the selected word | select every `pedro`, rewrite it once, all of them change |
| n | `<leader>kva` | Select every occurrence | |

Inside the menu: `/` cursors from a vim regex, `.` normal command, `@` macro, `l` align the cursors, `L` align on a character, `s` surround, `#` number the cursors, `r` rename.

Every operation lands in a single undo step. The lualine mode block shows `SECVISUALMULTI` with the live cursor count while a session is active.

---

## SecKit (Language Tools)

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>kk` | SecKit menu | `Space k k` to open the language tools popup |
| n | `<leader>ka` | LSP Actions | `Space k a` to open LSP code actions |
| n | `<leader>kr` | Sectag rename tag | `Space k r` to rename the tag under the cursor and its pair. Buffer-local: only exists on the filetypes Sectag attaches to, same as its entry in the `<leader>kk` menu |

---

## Spelling

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>ljj` | Toggle spell | `Space l j j` to enable/disable spell checking |
| n | `<leader>ljp` | Set Portuguese | `Space l j p` to switch spell checking to Portuguese |
| n | `<leader>lje` | Set English | `Space l j e` to switch spell checking to English |
| n | `<leader>ljl` | Spell suggestions | `Space l j l` to see spelling suggestions for the word under cursor |

---

## macOS Notes

This config is tuned for macOS and zsh. A few keys depend on the terminal.

### Cmd vs Ctrl

Terminal Neovim cannot receive Cmd shortcuts. The VS Code-style layer uses
**Ctrl**, **Alt**, and **F-keys**. Cmd works only in GUI frontends such as
Neovide.

### Option as Meta

`Alt+h/j/k/l` (resize) and `Alt+F12` (peek definition) need Option to send
Meta:

- **Terminal.app**: Settings → Profiles → Keyboard → enable **Use Option as Meta key**.
- **iTerm2**: Settings → Profiles → Keys → Left/Right Option key → **Esc+**.
- **Ghostty**: `macos-option-as-alt = true`.
- **kitty**: `macos_option_as_alt yes`.
- **WezTerm**: Option works by default.

Plain arrow keys resize splits without any terminal setup, so
`Alt+h/j/k/l` is optional.

### Function keys

F1–F12 are media keys unless you enable standard function keys:

- System Settings → Keyboard → Keyboard Shortcuts → Function Keys →
  **Use F1, F2, etc. as standard function keys**.
- Or press `Fn+F1` … `Fn+F12`.

This affects `F1` (command palette), `F5`/`F9`–`F12` (debugging),
`F7` (build), `F6` (C/C++ run), and `F8` (diagnostics).

### Ctrl+S / XOFF

macOS terminals may interpret `Ctrl+S` as XOFF and freeze output. Add:

```sh
stty -ixon
```

to `~/.zshrc`, or use `<leader>w` / `:w`.

### Ctrl+?

`Ctrl+?` is DEL — the same code as Backspace — in most terminals. Do not bind
it. Use `Ctrl+P` for project search and `Ctrl+G` for the dev layout. Only
kitty-protocol terminals distinguish `Ctrl+Shift+/`, and that is not portable.

### Ctrl+Shift chords

`Ctrl+Shift+P/F/O/G/K/Z` and `Ctrl+Tab` need the kitty keyboard protocol
(Ghostty, kitty, WezTerm). Terminal.app and iTerm2 usually deliver plain Ctrl
chords instead. `F1` is the command palette everywhere; the VS Code section
lists the leader-key fallbacks.

### Clipboard

Neovim `unnamedplus` uses `pbcopy`/`pbpaste`. tmux uses `set-clipboard on`.
Check `:checkhealth provider` if a yank does not reach the system clipboard.

### Shell and paths

The layout terminals use `$SHELL` (zsh). `/tmp` is `/private/tmp`; the config
handles both. `solc`, `forge`, and `clang` are resolved through Mason and the
shell `PATH`.

### tmux

The bundled config uses `tmux-256color`, truecolor overrides,
`extended-keys on`, and prefix `Ctrl+a`. Reload with
`tmux source-file ~/.tmux.conf`. Existing Neovim instances must restart once so
the smart-splits backend sets `@pane-is-vim`.

---

## Lazy (Plugin Manager)

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>Ll` | Lazy | `Space Shift+l l` to open the Lazy plugin manager UI |
| n | `<leader>Lp` | Profile | `Space Shift+l p` to see plugin load times |
| n | `<leader>Lh` | Health | `Space Shift+l h` to run a health check |
| n | `<leader>LH` | Help | `Space Shift+l Shift+h` to open Lazy help |
| n | `<leader>Lb` | Build | `Space Shift+l b` to rebuild plugins |
| n | `<leader>Lc` | Clean | `Space Shift+l c` to remove unused plugins |
| n | `<leader>LC` | Clear | `Space Shift+l Shift+c` to clear the Lazy cache |
| n | `<leader>Lu` | Update | `Space Shift+l u` to update all plugins |
| n | `<leader>Ls` | Sync | `Space Shift+l s` to sync all plugins |

---

## Miscellaneous

| Mode | Key | Action | Example |
|:----:|:----|:-------|:--------|
| n | `<leader>lR` | Secvim | `Space l Shift+r` to run the Secvim command |
| n | `<leader>N` | Notification history | `Space Shift+n` to browse past notifications |
| n | `<leader>.` | Dismiss notification | `Space .` to dismiss the current notification |
| n | `<leader>lxs` | Select Python venv | `Space l x s` to pick a Python virtual environment |
