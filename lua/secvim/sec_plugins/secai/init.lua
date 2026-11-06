--- SecAI - Native AI CLI integration for Secvim
--- One persistent terminal per supported CLI tool (claude, cursor-agent,
--- openclaude, gemini, ...). Layout/theme are configurable through the
--- shared toggles store and mirror the look-and-feel of secterm.
local M = {}

local cli = require 'secvim.sec_plugins.secai.cli'

function M.toggle(name)
  cli.toggle(name)
end

function M.toggle_with_picker(name)
  cli.toggle_with_picker(name)
end

function M.show_in(position, name)
  cli.show_in(position, name)
end

function M.open_in_layout(position)
  cli.open_in_layout(position)
end

function M.show(name)
  cli.show(name)
end

function M.hide()
  cli.hide()
end

function M.close()
  cli.close()
end

--- Pick one of the running CLIs and kill it (window + process + history).
function M.close_pick()
  cli.close_pick()
end

--- Kill the CLI whose slot occupies `win`, if any.
function M.close_win(win)
  return cli.close_win(win)
end

--- Kill every running CLI.
function M.close_all()
  cli.close_all()
end

--- Visual-pick a CLI window and minimize (hide) it, keeping its session alive.
function M.minimize_pick()
  cli.minimize_pick()
end

function M.focus()
  cli.focus()
end

function M.select()
  cli.select()
end

function M.send(opts)
  cli.send(opts)
end

function M.send_ref(opts)
  cli.send_ref(opts)
end

function M.prompt()
  cli.prompt()
end

function M.ask_with_selection()
  cli.ask_with_selection()
end

function M.ask_with_preview()
  cli.ask_with_preview()
end

function M.refresh_chips()
  cli.refresh_chips()
end

--- Reset open panels to their preset size.
function M.reset_sizes()
  cli.reset_sizes()
end

function M.relayout()
  cli.relayout()
end

--- Resize the active CLI float in an arrow direction ('up'/'down'/'left'/
--- 'right'). Returns true if it handled the resize (used by smart-splits).
function M.resize_arrow(dir)
  return cli.resize_arrow(dir)
end

--- Whether any CLI buffer is currently visible (used by secmaximize)
function M.is_open()
  local state = require 'secvim.sec_plugins.secai.state'
  return state.any_visible()
end

--- Open/toggle the review of pending AI changes (keep/reject per hunk, diffed
--- against the session baseline snapshot).
function M.review()
  require('secvim.sec_plugins.secai.review').toggle()
end

--- Manually (re)mark the review baseline — the "before" snapshot the review
--- diffs against. Normally captured automatically when a CLI opens.
function M.mark_baseline()
  require('secvim.sec_plugins.secai.snapshot').mark(function(sha)
    if sha then
      vim.notify('SecAI: review baseline marked', vim.log.levels.INFO)
    else
      vim.notify('SecAI: could not mark baseline (not a git repo?)', vim.log.levels.WARN)
    end
  end)
end

--- Create or remove the global review keybinds based
--- on the master `secai_review` toggle, so they disappear from which-key when
--- the feature is off. Called at startup and whenever the toggle flips.
function M.apply_review_keymaps()
  local toggles = require 'secvim.config.toggles'
  local on = toggles.get 'secai_review'
  if on == nil then
    on = true
  end
  if on then
    vim.keymap.set('n', '<leader>ar', function()
      require('secvim.sec_plugins.secai').review()
    end, { desc = 'SecAI: Review AI Changes' })
    vim.keymap.set('n', '<leader>ab', function()
      require('secvim.sec_plugins.secai').mark_baseline()
    end, { desc = 'SecAI: Mark Review Baseline' })
  else
    pcall(vim.keymap.del, 'n', '<leader>ar')
    pcall(vim.keymap.del, 'n', '<leader>ab')
  end
end

return M
