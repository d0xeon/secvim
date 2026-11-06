local M = {}

local cache_file = vim.fn.stdpath 'cache' .. '/secvim-toggles'

local defaults = {
  lualine = true,
  lualine_theme = true,
  lualine_separator = 'rounded', -- rounded | bar | arrow | slant
  lualine_bar_y_transparent = true, -- true (default) = y/centre bar transparent, blends with theme bg; false = original solid #1a1a1a bar
  -- Borderless: paint a tool's borders the same colour as its bg, in every
  -- sec theme. One per tool, All flips them together. See
  -- secvim.config.borderless.
  borderless_whichkey = false,
  borderless_snacks = false,
  borderless_secpick = false,
  borderless_blink = false,
  borderless_secterm = false,
  borderless_secai = false,
  borderless_notify = false,
  -- Invert Backgrounds: swap a theme's editor surface with its explorer/tab
  -- chrome surface. One per theme, see
  -- secvim.config.invert_bg.
  secjet_invert = false,
  secmin_invert = false,
  secvintage_invert = false,
  dropbar = true,
  autosave = false,
  virtual_text_current_line = false,
  spell = false,
  spelllang = 'en',
  relativenumber = true,
  linenumber = true,
  indent = true,
  scroll = true,
  dim = false,
  wrap = false,
  cursor_block = true,
  cursorline = true,
  -- Autocmd toggles
  lastpos = false,
  autoread = true, -- reload buffers changed on disk (SecAI, git, etc.) on focus/idle
  dotenv_syntax = true,
  no_auto_comment = true,
  autosave_focuslost = true,
  snacks_explorer = false,
  snacks_explorer_focus = false,
  lsp_ref_highlights = true,
  dbout_no_folding = true,
  copilot = false,
  copilot_lualine = true, -- show the copilot icon on lualine
  incline = true,
  bufferline = true,
  picker_hidden = false,
  picker_ignored = true,
  picker_layout = 'default',
  picker_preview = true,
  picker_border = 'rounded',
  whichkey_preset = 'modern',
  whichkey_border = 'single',
  explorer_right = false,
  explorer_preview = false,
  -- SecAI
  secai_position = 'right',
  secai_size = 'default',
  secai_theme = 'garland',
  secai_title = true,
  secai_time = true,
  secai_autoinsert = true,
  secai_auto_focus = true,
  secai_vertical_border = true,
  secai_horizontal_border = true,
  secai_dark_bg = true, -- light mode: force #000
  secai_dark_bg_dm = false, -- dark mode: force #000
  secai_review = true, -- master switch for the Review feature
  secai_auto_review = false, -- auto-open the AI-changes review
  secai_review_badge = true, -- show the pending-review count on the chip
  -- Secmaximize
  secmaximize_lualine = true, -- show the zoom indicator on lualine
  secmaximize_badge = true, -- show the floating zoom badge on the buffer
  secmaximize_name = true, -- show the "max" text (true) or icon only (false)
  secmaximize_border = 'rounded', -- badge border: none | rounded | single
  -- Seczen (distraction-free mode) — persisted across sessions
  seczen = false,
  git_blame = true,
  render_markdown = true,
  render_markdown_theme = 'none', -- none | lazy | obsidian
  image_preview = false,
  -- Todo Comments
  todo_comments = true,
  todo_comments_bg = true,
  todo_comments_fg = false,
  -- Secterm
  secterm_title = true,
  secterm_time = true,
  secterm_theme = 'garland',
  secterm_size = 'default',
  secterm_autoinsert = true, -- insert mode when a terminal opens
  secterm_focus_insert = true, -- insert mode when focus lands on it
  secterm_vertical_border = false,
  secterm_horizontal_border = false,
  secterm_name_full = true,
  secterm_icon_visible = true,
  secterm_icon_style = 'terminal', -- 'sec' | 'terminal'
  secterm_dark_bg = true, -- light mode: force #000
  secterm_dark_bg_dm = false, -- dark mode: force #000
  -- Sectag
  sectag = true, -- master switch: off disables the whole plugin
  sectag_close = true, -- auto close tag
  sectag_rename = true, -- auto live rename tag
  -- Yazi / Lazygit background overrides (force #000, same light+dark scheme)
  yazi_dark_bg = true, -- light mode: force #000
  yazi_dark_bg_dm = false, -- dark mode: force #000
  lazygit_dark_bg = true, -- light mode: force #000
  lazygit_dark_bg_dm = false, -- dark mode: force #000
  -- Dropbar
  dropbar_compact = false, -- false = full path (16 segments), true = parent + filename only
  dropbar_path_preview = true,
  -- Dashboard gif (chafa)
  dashboard_gif = false,
  dashboard_gif_name = 'gopher.gif',
  dashboard_gif_height = 8,
  dashboard_gif_width = 20,
  dashboard_gif_indent = 50,
}

M._state = nil

--- The single Borderless toggle became one per tool: carry its state over once
--- and drop the old key from the cache.
function M._migrate_borderless()
  if M._state.theme_borderless == nil then
    return
  end
  local on = M._state.theme_borderless == true
  M._state.theme_borderless = nil
  if on then
    for key in pairs(defaults) do
      if key:sub(1, 11) == 'borderless_' then
        M._state[key] = true
      end
    end
  end
  M._save()
end

function M._load()
  if M._state then
    return M._state
  end
  local ok, content = pcall(vim.fn.readfile, cache_file)
  if ok and content[1] then
    local decoded = vim.json.decode(content[1])
    if decoded then
      M._state = vim.tbl_deep_extend('force', vim.deepcopy(defaults), decoded)
      M._migrate_borderless()
      return M._state
    end
  end
  M._state = vim.deepcopy(defaults)
  return M._state
end

function M._save()
  local json = vim.json.encode(M._state)
  vim.fn.writefile({ json }, cache_file)
end

function M.get(key)
  local state = M._load()
  return state[key]
end

function M.set(key, value)
  local state = M._load()
  state[key] = value
  M._save()
end

--- Like get(), but with a fallback when the module may not be loaded yet or
--- the key is unset. Lets callers drop the pcall(require) + nil-check dance.
function M.get_or(key, default)
  local value = M.get(key)
  if value == nil then
    return default
  end
  return value
end

--- Set several keys with a single disk write (set() writes the whole JSON
--- file per call, so batch updates like "force dark bg: all" should not pay
--- one write per key).
function M.set_many(values)
  local state = M._load()
  for key, value in pairs(values) do
    state[key] = value
  end
  M._save()
end

function M.toggle(key)
  local state = M._load()
  state[key] = not state[key]
  M._save()
  return state[key]
end

return M
