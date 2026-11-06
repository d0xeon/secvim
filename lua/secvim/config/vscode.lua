--- VS Code-style keymaps.
---
--- These are terminal-friendly equivalents of the VS Code defaults: Ctrl-based
--- shortcuts where the terminal can send them, F-keys for everything else.
--- VS Code on macOS uses Cmd, which a terminal cannot deliver; Ctrl/Alt/F-keys
--- are the closest portable mapping. Terminals that speak the kitty keyboard
--- protocol (kitty, WezTerm, Ghostty, foot) also deliver the Ctrl+Shift ones.

local function snacks()
  return require 'snacks'
end

local function save()
  if vim.bo.buftype == '' then
    vim.cmd 'silent! write'
  end
end

local function save_all()
  vim.cmd 'silent! wall'
end

local function toggle_explorer()
  require('secvim.helpers.explorer').toggle()
end

local function toggle_terminal()
  require('secvim.sec_plugins.secterm').toggle_float()
end

local function toggle_comment()
  local ok, err = pcall(vim.cmd, 'normal! gcc')
  if not ok then
    vim.notify('Comment: ' .. tostring(err), vim.log.levels.WARN)
  end
end

local function delete_line()
  vim.cmd 'normal! dd'
end

local function duplicate_line(direction)
  if direction == 'down' then
    vim.cmd 'normal! yyp'
  else
    vim.cmd 'normal! yyP'
  end
end

local function next_buffer()
  pcall(vim.cmd, 'bnext')
end

local function prev_buffer()
  pcall(vim.cmd, 'bprevious')
end

local function close_buffer()
  require('snacks').bufdelete()
end

local function jump_definition()
  vim.lsp.buf.definition()
end

local function set(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = 'VS Code: ' .. desc, nowait = true })
end

-- Files and search
set({ 'n', 'i', 'v' }, '<C-s>', save, 'Save file')
set('n', '<C-S-s>', save_all, 'Save all')
set('n', '<C-p>', function()
  require('secvim.helpers.picker').files()
end, 'Quick open file')
set({ 'n', 'i', 'v' }, '<F1>', function()
  snacks().picker.commands()
end, 'Command palette')
set('n', '<C-S-p>', function()
  snacks().picker.commands()
end, 'Command palette')
set('n', '<C-f>', function()
  snacks().picker.lines()
end, 'Find in file')
set('n', '<C-S-f>', function()
  snacks().picker.grep()
end, 'Find in files')
set('n', '<C-S-o>', function()
  snacks().picker.lsp_symbols()
end, 'Go to symbol in file')
set('n', '<C-S-g>', function()
  snacks().picker.git_status()
end, 'Source control: changes')

-- Explorer and terminal
set('n', '<C-b>', toggle_explorer, 'Toggle sidebar')
set({ 'n', 'i', 'v', 't' }, '<C-`>', toggle_terminal, 'Toggle terminal')

-- Editing
set('n', '<C-z>', 'u', 'Undo')
set('n', '<C-S-z>', '<C-r>', 'Redo')
set('n', '<C-/>', toggle_comment, 'Toggle line comment')
set('n', '<C-_>', toggle_comment, 'Toggle line comment')
vim.keymap.set('x', '<C-/>', 'gc', { desc = 'VS Code: Toggle comment', nowait = true, remap = true })
vim.keymap.set('x', '<C-_>', 'gc', { desc = 'VS Code: Toggle comment', nowait = true, remap = true })
set('n', '<C-S-k>', delete_line, 'Delete line')
set('n', '<M-k>', delete_line, 'Delete line (fallback)')
set('n', '<M-S-Down>', function()
  duplicate_line 'down'
end, 'Duplicate line down')
set('n', '<M-S-Up>', function()
  duplicate_line 'up'
end, 'Duplicate line up')

set('i', '<C-Space>', function()
  require('blink.cmp').show()
end, 'Trigger completion')

-- Problems
set('n', '<F8>', function()
  vim.diagnostic.goto_next { float = { border = 'rounded' } }
end, 'Next problem')
set('n', '<S-F8>', function()
  vim.diagnostic.goto_prev { float = { border = 'rounded' } }
end, 'Previous problem')

-- LSP
set('n', '<F2>', vim.lsp.buf.rename, 'Rename symbol')
set('n', '<F12>', jump_definition, 'Go to definition')
set('n', '<S-F12>', function()
  snacks().picker.lsp_references()
end, 'Find references')
set('n', '<M-F12>', function()
  require('secvim.sec_plugins.secpreview').definition()
end, 'Peek definition')

-- Debug
set('n', '<F5>', '<cmd>DapContinue<cr>', 'Debug: start/continue')
set('n', '<S-F5>', '<cmd>DapTerminate<cr>', 'Debug: stop')
set('n', '<F9>', '<cmd>DapToggleBreakpoint<cr>', 'Debug: toggle breakpoint')
set('n', '<F10>', '<cmd>DapStepOver<cr>', 'Debug: step over')
set('n', '<F11>', '<cmd>DapStepInto<cr>', 'Debug: step into')
set('n', '<S-F11>', '<cmd>DapStepOut<cr>', 'Debug: step out')

-- Buffers and tabs
set('n', '<C-Tab>', next_buffer, 'Next buffer')
set('n', '<C-S-Tab>', prev_buffer, 'Previous buffer')
set('n', '<M-]>', next_buffer, 'Next buffer (fallback)')
set('n', '<M-[>', prev_buffer, 'Previous buffer (fallback)')
set('n', '<C-F4>', close_buffer, 'Close buffer')
