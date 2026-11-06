--- Secterm - Native terminal plugin for Secvim
--- Float window cycles through multiple terminals via <C-j>/<C-k>;
--- splits are persistent and toggle visibility. Both modes show a
--- top winbar with terminal name, buffer size and time.
local M = {}

local float = require 'secvim.sec_plugins.secterm.float'
local split = require 'secvim.sec_plugins.secterm.split'

function M.toggle_float()
  float.toggle()
end

function M.float_new()
  float.new()
end

function M.float_cycle(direction)
  float.cycle(direction)
end

function M.toggle_horizontal(id, size, name)
  split.toggle(id or 'h_main', 'horizontal', size or 16, name)
end

function M.toggle_vertical(id, size, name)
  split.toggle(id or 'v_main', 'vertical', size or 70, name)
end

--- Pick a secterm window with secpick and end that terminal's session.
function M.pick_close()
  local secpick = require 'secvim.sec_plugins.secpick'
  local win = secpick.select {
    single = true,
    filter = function(_, buf)
      return vim.bo[buf].filetype == 'secterm'
    end,
  }
  if not win then
    return
  end
  if not float.close_win(win) then
    split.close_win(win)
  end
end

--- End the terminal living in `win`, float or split. Returns false when the
--- window isn't a secterm.
function M.close_win(win)
  if float.close_win(win) then
    return true
  end
  return split.close_win(win) and true or false
end

--- End every terminal session, float and split.
function M.close_all()
  local n = float.close_all() + split.close_all()
  if n > 0 then
    Snacks.notify.info('Secterm: closed ' .. n .. ' terminal' .. (n > 1 and 's' or ''))
  end
end

--- Re-evaluate chip visibility on float and all splits (called by toggles)
function M.refresh_chips()
  float.refresh()
  split.refresh_all()
end

--- Size popup (compact / default / wide) — per-mode, real-time. Float,
--- vertical and horizontal each keep their own preset; 'a' changes all. The
--- popup stays open and applies every change live. Mirrors SecAI's size picker.
function M.pick_size()
  local sizes = require 'secvim.sec_plugins.secterm.sizes'
  require('secvim.helpers.size_popup').open {
    title = ' Secterm · Size ',
    name = 'Secterm',
    list = sizes.list,
    get = function(mode)
      return sizes.name(mode)
    end,
    set = function(mode, name)
      sizes.set(mode, name)
    end,
    apply = function(mode)
      -- Float geometry only depends on the float preset; splits on v/h.
      if mode == 'float' or mode == 'all' then
        float.apply_geom()
      end
      if mode ~= 'float' or mode == 'all' then
        split.apply_size()
      end
    end,
  }
end

--- Forward resize_arrow to the split module so smart-splits can fall
--- through to the secterm float when no native split changed.
function M.resize_arrow(dir)
  return split.resize_arrow(dir)
end

--- Swap the focused secterm panel with the secterm on its `dir` side
--- ('left'/'right'/'up'/'down'). False when the focus isn't a secterm panel
--- or no secterm sits that way, so the caller can fall back to `wincmd`.
function M.swap(dir)
  return split.swap(dir)
end

--- Reset open panels to their preset size.
function M.reset_sizes()
  split.reset_sizes()
end

--- Reload open splits to apply a border-mode change. Pass 'vertical' or
--- 'horizontal' to limit; nil reloads both.
function M.reload_splits(direction)
  split.reload_all(direction)
end

--- Re-apply the terminal bg on the open float + all splits (called when the
--- secterm_dark_bg toggle flips).
function M.refresh_bg()
  float.refresh_bg()
  split.reload_all()
end

return M
