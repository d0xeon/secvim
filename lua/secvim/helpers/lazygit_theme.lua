--- Canonical lazygit theme for Secvim.
---
--- Snacks derives the lazygit theme from Neovim highlight groups (MatchParen,
--- FloatBorder, Function, Identifier, Special, Visual, DiagnosticError, ...).
--- Those groups are *syntax* colors, so they differ between secmin and
--- secvintage — which made lazygit look inconsistent (secvintage dark used
--- red/gold accents and a light-blue selection instead of secmin's neutral
--- look). Overriding them per-theme would wreck code highlighting in the editor.
---
--- Instead we point Snacks' lazygit theme at dedicated `SecLg*` groups defined
--- here, so lazygit renders IDENTICALLY across colorschemes. Values mirror the
--- secmin look (the canonical reference), background-aware for dark/light.
---
--- Exceptions: secnight is strictly monochrome, so the canonical palette's
--- blue/purple accents clash with it, and secjet mirrors the JetBrains IDE
--- chrome. Both define their own SecLg* values in their overrides.lua (normal
--- and transparent modes alike); apply() skips the canonical values while one
--- of them is active so theirs win.
---
--- The palette follows the surface lazygit actually renders on, not just
--- `background`: Force Dark BG pins the float to #000 in light mode, and the
--- light palette's near-black text on that is unreadable, so a forced-black
--- float gets the dark palette.
local M = {}

--- Themes that ship their own SecLg* palette in overrides.lua.
local owns_lazygit_palette = { secnight = true, secjet = true }

local api = vim.api

-- Dark palette (from secmin dark).
local dark = {
  c241 = '#bbbbbb', -- Special/symbol — lazygit uses color 241 heavily
  active = '#abb2bf', -- active/searching border (MatchParen)
  cherryBg = '#c1c1c1', -- cherry-picked commit bg marker (Identifier)
  cherryFg = '#b392f0', -- cherry-picked commit fg (Function)
  default = '#c1c1c1', -- default text (Normal fg)
  inactive = '#4c4c4c', -- inactive border (FloatBorder)
  options = '#b392f0', -- options/help text (Function)
  selected = '#4c4c4c', -- selected line bg (Visual)
  unstaged = '#FF7A84', -- unstaged changes (DiagnosticError)
}

-- Light palette (from secmin light).
local light = {
  c241 = '#a1a1a1',
  active = '#383A42',
  cherryBg = '#616161',
  cherryFg = '#9966cc',
  default = '#383A42',
  inactive = '#C0C0C0',
  options = '#9966cc',
  selected = '#D6E4F0',
  unstaged = '#d6656a',
}

--- Snacks lazygit `theme` table — points every entry at a SecLg* group so the
--- generated lazygit-theme.yml is theme-independent.
M.theme = {
  [241] = { fg = 'SecLg241' },
  activeBorderColor = { fg = 'SecLgActive', bold = true },
  cherryPickedCommitBgColor = { fg = 'SecLgCherryBg' },
  cherryPickedCommitFgColor = { fg = 'SecLgCherryFg' },
  defaultFgColor = { fg = 'SecLgDefault' },
  inactiveBorderColor = { fg = 'SecLgInactive' },
  optionsTextColor = { fg = 'SecLgOptions' },
  searchingActiveBorderColor = { fg = 'SecLgActive', bold = true },
  selectedLineBgColor = { bg = 'SecLgSelected' },
  unstagedChangesColor = { fg = 'SecLgUnstaged' },
}

--- Whether lazygit renders on a dark surface: either the editor is in dark mode,
--- or Force Dark BG pins the float to #000 while in light mode.
local function on_dark_surface()
  if vim.o.background ~= 'light' then
    return true
  end
  local ok, term_bg = pcall(require, 'secvim.helpers.term_bg')
  return ok and term_bg.is_black 'lazygit' or false
end

--- The SecLg* values a palette-owning theme declares for `mode`, so a
--- forced-black float in light mode can borrow that theme's own dark values
--- instead of falling back to the canonical ones.
local function theme_palette(theme, mode)
  local ok, overrides = pcall(require, 'secvim.plugins.ui.colorschemes.' .. theme .. '.overrides')
  if not ok then
    return {}
  end
  local transparent = false
  local ok_appearance, appearance = pcall(require, 'secvim.config.appearance')
  if ok_appearance then
    transparent = appearance.get_transparent()
  end
  local ok_groups, groups = pcall(overrides.get, mode, transparent)
  if not ok_groups or type(groups) ~= 'table' then
    return {}
  end
  local hls = {}
  for name, attrs in pairs(groups) do
    if name:sub(1, 6) == 'SecLg' then
      hls[name] = attrs
    end
  end
  return hls
end

--- (Re)define the SecLg* highlight groups for the current surface. Called on
--- setup and whenever the colorscheme/background changes, so Snacks reads fresh
--- colors when it regenerates the theme file (it does so on ColorScheme).
function M.apply()
  local dark_surface = on_dark_surface()
  local theme = vim.g.colors_name
  -- Themes that own their SecLg* values (set in their overrides.lua) must not
  -- be clobbered with the canonical palette. Their overrides already track
  -- `background`, so only a forced-black float in light mode needs a hand: pull
  -- in the same theme's dark values.
  if owns_lazygit_palette[theme] then
    if dark_surface and vim.o.background == 'light' then
      for name, attrs in pairs(theme_palette(theme, 'dark')) do
        api.nvim_set_hl(0, name, attrs)
      end
    end
    return
  end
  local p = dark_surface and dark or light
  api.nvim_set_hl(0, 'SecLg241', { fg = p.c241 })
  api.nvim_set_hl(0, 'SecLgActive', { fg = p.active, bold = true })
  api.nvim_set_hl(0, 'SecLgCherryBg', { fg = p.cherryBg })
  api.nvim_set_hl(0, 'SecLgCherryFg', { fg = p.cherryFg })
  api.nvim_set_hl(0, 'SecLgDefault', { fg = p.default })
  api.nvim_set_hl(0, 'SecLgInactive', { fg = p.inactive })
  api.nvim_set_hl(0, 'SecLgOptions', { fg = p.options })
  api.nvim_set_hl(0, 'SecLgSelected', { bg = p.selected })
  api.nvim_set_hl(0, 'SecLgUnstaged', { fg = p.unstaged })
end

--- Re-apply the palette after the Force Dark BG toggle flipped. Snacks caches
--- lazygit-theme.yml and only marks it stale on ColorScheme, so re-applying the
--- scheme is what makes the new colors reach the next lazygit open.
function M.refresh()
  M.apply()
  local ok, appearance = pcall(require, 'secvim.config.appearance')
  if ok then
    appearance.reload()
  end
end

function M.float_winhl()
  return require('secvim.helpers.term_bg').float_winhl 'lazygit'
end

function M.setup()
  M.apply()
  local group = api.nvim_create_augroup('SecvimLazygitTheme', { clear = true })
  api.nvim_create_autocmd('ColorScheme', {
    group = group,
    callback = function()
      M.apply()
    end,
  })
  api.nvim_create_autocmd('OptionSet', {
    group = group,
    pattern = 'background',
    callback = function()
      M.apply()
    end,
  })
end

return M
