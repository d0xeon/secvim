--- SecLayout - a Neovim-native 2x2 development grid.
---
---   ┌──────────────┬──────────────┐
---   │ code window  │ run          │
---   ├──────────────┼──────────────┤
---   │ logs         │ tests        │
---   └──────────────┴──────────────┘
---
--- The layout lives in its own tab, so it never disturbs the tab you were
--- editing in. `Ctrl+G` opens/focuses it from another tab and closes it when
--- pressed inside the layout.
local M = {}

local config = require 'secvim.config.layout'
local state = {
  tab = nil,
  code_win = nil,
  terms = {},
}

local group = vim.api.nvim_create_augroup('SecLayout', { clear = true })

local function valid_tab(tab)
  return tab ~= nil and vim.api.nvim_tabpage_is_valid(tab)
end

local function valid_win(win)
  return win ~= nil and vim.api.nvim_win_is_valid(win)
end

local function term_keys(buf)
  local opts = { buffer = buf, nowait = true }
  vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

local function term_cmd(cmd)
  if type(cmd) ~= 'string' or cmd == '' then
    return { vim.o.shell }
  end
  -- Run the command in the shell, then exec an interactive shell so the pane
  -- is still usable after a build/test command finishes. `-i -c` does not
  -- reliably surface output in a Neovim terminal, so use `-c` + exec.
  return { vim.o.shell, '-c', cmd .. '; exec ' .. vim.fn.shellescape(vim.o.shell) }
end

local function make_term(win, role, cmd, cwd)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.bo[buf].bufhidden = 'hide'
  vim.bo[buf].swapfile = false
  vim.b[buf].seclayout_role = role

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = 'no'
  vim.wo[win].winbar = ' ' .. role .. ' '

  local job
  vim.api.nvim_buf_call(buf, function()
    job = vim.fn.jobstart(term_cmd(cmd), { term = true, cwd = cwd })
    term_keys(buf)
  end)
  if job <= 0 then
    vim.notify('SecLayout: failed to start ' .. role .. ' terminal', vim.log.levels.ERROR)
  end
  vim.b[buf].seclayout_job = job

  if config.focus_insert then
    vim.api.nvim_create_autocmd('BufEnter', {
      group = group,
      buffer = buf,
      callback = function()
        if vim.api.nvim_get_current_buf() == buf and vim.bo[buf].buftype == 'terminal' then
          vim.cmd 'startinsert'
        end
      end,
    })
  end

  return { win = win, buf = buf, job = job, role = role }
end

local function cleanup_terms(terms)
  for _, term in pairs(terms) do
    if term.job and term.job > 0 then
      pcall(vim.fn.jobstop, term.job)
    end
    if vim.api.nvim_buf_is_valid(term.buf) then
      pcall(vim.api.nvim_buf_delete, term.buf, { force = true })
    end
  end
end

local function apply_width()
  if not valid_win(state.code_win) then
    return
  end
  local fraction = tonumber(config.code_width) or 0.5
  fraction = math.max(0.25, math.min(0.75, fraction))
  local width = math.max(20, math.floor(vim.o.columns * fraction))
  pcall(vim.api.nvim_win_set_width, state.code_win, width)
end

local function build_impl()
  local cwd = vim.fn.getcwd()
  local source = vim.api.nvim_buf_get_name(0)
  local use_source = source ~= '' and vim.bo.buftype == '' and vim.fn.filereadable(source) == 1

  if use_source then
    vim.cmd('tabnew ' .. vim.fn.fnameescape(source))
  else
    vim.cmd 'tabnew'
  end

  state.tab = vim.api.nvim_get_current_tabpage()
  state.code_win = nil
  state.terms = {}
  vim.t[state.tab].seclayout = true

  -- Pick the real file window. The minimap is suppressed while the layout is
  -- built (vim.g.seclayout_building), but this also keeps the code pane correct
  -- if another plugin adds a window first.
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(state.tab)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'minimap' then
      state.code_win = win
      break
    end
  end
  state.code_win = state.code_win or vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(state.code_win)

  -- Right column: run above, tests below.
  vim.cmd 'vsplit'
  local run_win = vim.api.nvim_get_current_win()
  vim.cmd 'split'
  local tests_win = vim.api.nvim_get_current_win()

  -- Left column: code above, logs below.
  vim.cmd 'wincmd h'
  vim.cmd 'belowright split'
  local logs_win = vim.api.nvim_get_current_win()

  vim.cmd 'wincmd ='
  apply_width()

  state.terms.run = make_term(run_win, 'Run', config.commands and config.commands.run, cwd)
  state.terms.tests = make_term(tests_win, 'Tests', config.commands and config.commands.tests, cwd)
  state.terms.logs = make_term(logs_win, 'Logs', config.commands and config.commands.logs, cwd)

  vim.api.nvim_set_current_win(state.code_win)
end

local function build()
  vim.g.seclayout_building = true
  local ok, err = pcall(build_impl)
  vim.g.seclayout_building = false
  if not ok then
    pcall(M.close)
    error(err)
  end
end

function M.open()
  if valid_tab(state.tab) then
    vim.api.nvim_set_current_tabpage(state.tab)
    if valid_win(state.code_win) then
      vim.api.nvim_set_current_win(state.code_win)
    end
    return
  end
  build()
end

function M.close()
  local tab = state.tab
  local terms = state.terms
  state.tab = nil
  state.code_win = nil
  state.terms = {}

  if not valid_tab(tab) then
    cleanup_terms(terms)
    return
  end

  if #vim.api.nvim_list_tabpages() > 1 then
    if vim.api.nvim_get_current_tabpage() ~= tab then
      pcall(vim.api.nvim_set_current_tabpage, tab)
    end
    pcall(vim.cmd, 'tabclose')
  else
    for _, term in pairs(terms) do
      if valid_win(term.win) then
        pcall(vim.api.nvim_win_close, term.win, true)
      end
    end
  end

  cleanup_terms(terms)
end

function M.toggle()
  if valid_tab(state.tab) and vim.api.nvim_get_current_tabpage() == state.tab then
    M.close()
  else
    M.open()
  end
end

function M.is_open()
  return valid_tab(state.tab)
end

function M.is_active()
  return valid_tab(state.tab) and vim.api.nvim_get_current_tabpage() == state.tab
end

--- Open a picker whose plain <CR> lands in the layout's code pane, even when
--- the cursor is parked in a terminal pane. Honors the picker's split actions;
--- only confirmation is redirected.
function M.pick(source, opts)
  local ok, snacks = pcall(require, 'snacks')
  if not ok or not snacks.picker or type(snacks.picker[source]) ~= 'function' then
    return
  end
  opts = vim.tbl_extend('force', {}, opts or {})
  opts.confirm = function(picker, item)
    picker:close()
    if not item then
      return
    end
    if valid_tab(state.tab) then
      vim.api.nvim_set_current_tabpage(state.tab)
    end
    if valid_win(state.code_win) then
      vim.api.nvim_set_current_win(state.code_win)
    end
    if item.file then
      vim.cmd('edit ' .. vim.fn.fnameescape(item.file))
    elseif item.buf then
      vim.api.nvim_win_set_buf(0, item.buf)
    end
  end

  -- Focus the code window before the picker opens so <C-v>, <C-s>, and <C-t>
  -- split the code pane even when the search started from a terminal pane.
  if valid_tab(state.tab) then
    vim.api.nvim_set_current_tabpage(state.tab)
  end
  if valid_win(state.code_win) then
    vim.api.nvim_set_current_win(state.code_win)
  end
  snacks.picker[source](opts)
end

function M.find_file()
  M.pick 'files'
end

vim.api.nvim_create_autocmd('TabClosed', {
  group = group,
  callback = function()
    if state.tab and not valid_tab(state.tab) then
      local terms = state.terms
      state.tab = nil
      state.code_win = nil
      state.terms = {}
      cleanup_terms(terms)
    end
  end,
})

return M
