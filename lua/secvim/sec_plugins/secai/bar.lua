--- SecAI bar - Title chip rendered on the top border of the CLI window
local M = {}

local api = vim.api
local chip_bar = require 'secvim.helpers.chip_bar'
local chip = chip_bar.new { ns = 'secai_chip' }
local hex = chip_bar.hex
local get_time = chip_bar.get_time

local ICON = ''
local CLOCK = chip_bar.CLOCK

function M.setup_hl()
  local normal = api.nvim_get_hl(0, { name = 'Normal' })
  local fb = api.nvim_get_hl(0, { name = 'FloatBorder' })

  local nfg = hex(normal.fg) or '#cdd6f4'
  local border_fg = hex(fb and fb.fg) or nfg

  api.nvim_set_hl(0, 'SecaiBarIcon', { fg = '#A9B2C0', bold = true })
  api.nvim_set_hl(0, 'SecaiBarName', { fg = nfg, bold = true })
  api.nvim_set_hl(0, 'SecaiBarTool', { fg = '#7B8394', italic = true })
  api.nvim_set_hl(0, 'SecaiBarTime', { fg = '#7B8394' })
  api.nvim_set_hl(0, 'SecaiBarBracket', { fg = border_fg })

  local review_fg = '#f9e2af'
  local okp, palette = pcall(require, 'secvim.helpers.palette')
  if okp then
    local p = palette.get()
    review_fg = p.yellow or p.pink or review_fg
  end
  api.nvim_set_hl(0, 'SecaiBarReview', { fg = review_fg, bold = true })
end

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('SecaiBarHl', { clear = true }),
  callback = function()
    M.setup_hl()
  end,
})

function M.chip_enabled()
  return chip_bar.toggle('secai_title', true)
end

function M.time_enabled()
  return chip_bar.toggle('secai_time', true)
end

function M.autoinsert_enabled()
  return chip_bar.toggle('secai_autoinsert', true)
end

--- Master Review toggle (default true). Gates the pending-review badge.
function M.review_enabled()
  return chip_bar.toggle('secai_review', true)
end

--- Whether the pending-review count badge is shown (default true).
function M.badge_enabled()
  return chip_bar.toggle('secai_review_badge', true)
end

local REVIEW_ICON = '󰈈'

--- The pending-review badge text (icon + count), or nil when it should not
--- show: feature off, badge hidden, a review already open, or nothing pending.
--- Reads the cached count from review.lua synchronously.
local function pending_badge()
  if not M.review_enabled() or not M.badge_enabled() then
    return nil
  end
  local ok, review = pcall(require, 'secvim.sec_plugins.secai.review')
  if not ok then
    return nil
  end
  if review.is_open and review.is_open() then
    return nil
  end
  local n = review.pending_count and review.pending_count() or 0
  if not n or n <= 0 then
    return nil
  end
  return REVIEW_ICON .. ' ' .. n
end

local function tool_label(tool_name)
  if not tool_name then
    return 'SecAI'
  end
  local ok, tools = pcall(require, 'secvim.sec_plugins.secai.tools')
  if ok then
    local t = tools.get(tool_name)
    if t then
      return 'SecAI · ' .. t.label
    end
  end
  return 'SecAI'
end

local function inline_segments(tool_name)
  local segs = {
    { ' ', 'SecaiBarBracket' },
    { ICON .. '  ', 'SecaiBarIcon' },
    { tool_label(tool_name), 'SecaiBarName' },
  }
  if M.time_enabled() then
    table.insert(segs, { ' ', 'SecaiBarBracket' })
    table.insert(segs, { get_time(), 'SecaiBarTime' })
  end
  local badge = pending_badge()
  if badge then
    table.insert(segs, { '  ', 'SecaiBarBracket' })
    table.insert(segs, { badge, 'SecaiBarReview' })
  end
  table.insert(segs, { ' ', 'SecaiBarBracket' })
  return segs
end

local function banner_segments(width, tool_name)
  local label = tool_label(tool_name)
  local badge = pending_badge()
  local left_text = ' ' .. ICON .. '  ' .. label
  if badge then
    left_text = left_text .. '  ' .. badge
  end
  local left_w = vim.api.nvim_strwidth(left_text)

  local segs = {
    { ' ', 'SecaiBarBracket' },
    { ICON, 'SecaiBarIcon' },
    { '  ', 'SecaiBarBracket' },
    { label, 'SecaiBarName' },
  }
  if badge then
    table.insert(segs, { '  ', 'SecaiBarBracket' })
    table.insert(segs, { badge, 'SecaiBarReview' })
  end

  if M.time_enabled() then
    local right_text = ' ' .. CLOCK .. ' ' .. get_time() .. ' '
    local right_w = vim.api.nvim_strwidth(right_text)
    local pad = width - left_w - right_w
    if pad < 1 then
      pad = 1
    end
    table.insert(segs, { string.rep(' ', pad), 'SecaiBarBracket' })
    table.insert(segs, { ' ' .. CLOCK .. ' ', 'SecaiBarIcon' })
    table.insert(segs, { get_time(), 'SecaiBarTime' })
    table.insert(segs, { ' ', 'SecaiBarBracket' })
  else
    local pad = width - left_w
    if pad < 1 then
      pad = 1
    end
    table.insert(segs, { string.rep(' ', pad), 'SecaiBarBracket' })
  end

  return segs
end

function M.chip_segments(width, tool_name)
  local ok, themes = pcall(require, 'secvim.sec_plugins.secai.themes')
  if ok then
    local t = themes.current()
    -- Petal is rendered as a borderless banner (full-width, text on the left)
    if t.layout == 'banner' or t.name == 'petal' then
      return banner_segments(width or 0, tool_name)
    end
  end
  return inline_segments(tool_name)
end

function M.chip_plain(width, tool_name)
  return chip_bar.segs_text(M.chip_segments(width, tool_name))
end

function M.write_chip_buf(buf, width, tool_name)
  if not buf or not api.nvim_buf_is_valid(buf) then
    return
  end
  chip.clear(buf)

  local ok, themes = pcall(require, 'secvim.sec_plugins.secai.themes')
  local theme = ok and themes.current() or nil

  if theme and theme.layout == 'stem' then
    local segs = banner_segments(width or 0, tool_name)
    local text = chip_bar.segs_text(segs)
    local sep = string.rep('─', width or 0)
    api.nvim_buf_set_lines(buf, 0, -1, false, { text, sep })
    chip.apply_segs(buf, 0, segs)
    api.nvim_buf_set_extmark(buf, chip.ns, 1, 0, {
      end_row = 1,
      end_col = #sep,
      hl_group = 'SecaiBarBracket',
    })
  else
    chip.write_line(buf, M.chip_segments(width, tool_name))
  end
end

function M._stop_timer()
  chip.stop_timer()
end

function M.attach(win, buf, refresh_fn)
  M.setup_hl()
  chip.track(win, { buf = buf, refresh = refresh_fn })
end

function M.detach(win)
  chip.untrack(win)
end

--- Esc-hint winbar fragment showing the terminal escape shortcuts.
--- Uses dedicated hint groups instead of Comment/Normal so the bg tracks the
--- window: when secai_dark_bg forces #000 in light mode, the hint blends in
--- (Comment is NOT remapped by the window's winhl, so it would otherwise keep
--- the theme's light bg and show light boxes around the keys).
function M.esc_hint()
  local term_bg = require 'secvim.helpers.term_bg'
  local text_fg, key_fg, bg
  if term_bg.is_black 'secai' then
    -- Match SecaiNormal (#000 bg / dim light fg) so the hint blends in.
    text_fg, key_fg, bg = '#d4d0c8', '#7B8394', '#000000'
  else
    local normal = api.nvim_get_hl(0, { name = 'Normal' })
    local comment = api.nvim_get_hl(0, { name = 'Comment' })
    text_fg = hex(normal.fg)
    key_fg = hex(comment.fg) or text_fg
    bg = hex(normal.bg) -- nil → NONE (transparent / falls back to WinBar)
  end
  api.nvim_set_hl(0, 'SecaiHintKey', { fg = key_fg, bg = bg })
  api.nvim_set_hl(0, 'SecaiHintText', { fg = text_fg, bg = bg })
  -- Leading space lives inside SecaiHintText so it picks up the hint bg —
  -- otherwise that first cell uses WinBar (→ light Normal) and shows a light
  -- sliver to the left of "Esc" when the bg is forced dark.
  return '%#SecaiHintText# %#SecaiHintKey#Esc%#SecaiHintText# → Normal  %#SecaiHintKey#│%#SecaiHintText#  %#SecaiHintKey#Esc Esc%#SecaiHintText# → Cancel CLI'
end

return M
