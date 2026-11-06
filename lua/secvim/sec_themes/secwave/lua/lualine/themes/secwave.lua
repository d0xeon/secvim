local theme = require('secwave.colors').setup().theme
local secwave = {}

-- Like every other sec theme's lualine styling: only the mode chip (`a`,
-- and `z` when present) changes colour per vim mode. The branch/git section
-- (`b`) and everything right of it keep one constant bg/fg across every
-- mode — kanagawa's own upstream theme varies `b`'s bg/fg per mode too
-- (diff.change for normal, ui.bg for insert/visual/...), which reads as the
-- whole statusline recolouring instead of just the mode label.
local fg_on_accent = theme.ui.bg_m3
local bg = theme.ui.bg
local fg = theme.syn.comment

-- Centre bar: the <leader>lqy toggle (default ON) keeps the y/centre bar
-- transparent — it blends with the editor bg (NONE in transparent mode). When
-- off, it restores the original solid bg_p1 bar. Same pattern as secnight
-- and secjet's lualine themes.
local transparent = require('secwave').config.transparent
local ok_t, toggles = pcall(require, 'secvim.config.toggles')
local center
if not ok_t or toggles.get 'lualine_bar_y_transparent' then
  center = transparent and 'NONE' or bg
else
  -- Always the solid bar here, even in transparent mode: this is the OFF
  -- state, so it must stay visually distinct from the ON branch above (which
  -- already owns the "NONE in transparent mode" behavior).
  center = theme.ui.bg_p1
end

secwave.normal = {
  a = { bg = theme.syn.fun, fg = fg_on_accent },
  b = { bg = bg, fg = fg },
  c = { bg = center, fg = theme.ui.fg },
}

secwave.insert = {
  a = { bg = theme.diag.ok, fg = fg_on_accent },
  b = { bg = bg, fg = fg },
}

secwave.command = {
  a = { bg = theme.syn.operator, fg = fg_on_accent },
  b = { bg = bg, fg = fg },
}

secwave.visual = {
  a = { bg = theme.syn.keyword, fg = fg_on_accent },
  b = { bg = bg, fg = fg },
}

secwave.replace = {
  a = { bg = theme.syn.constant, fg = fg_on_accent },
  b = { bg = bg, fg = fg },
}

secwave.inactive = {
  a = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
  b = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim, gui = 'bold' },
  c = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
}

if vim.g.secwave_lualine_bold then
  for _, mode in pairs(secwave) do
    mode.a.gui = 'bold'
  end
end

return secwave
