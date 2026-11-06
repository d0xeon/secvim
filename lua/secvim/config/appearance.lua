local M = {}

local bg_cache = vim.fn.stdpath 'cache' .. '/secvim-background'
local cs_cache = vim.fn.stdpath 'cache' .. '/secvim-colorscheme'
local tp_cache = vim.fn.stdpath 'cache' .. '/secvim-transparent'

local SEC_THEMES = {
  secmin = true,
  secvintage = true,
  secnight = true,
  secjet = true,
  secwave = true,
}

M._reloaders = {}
M._transparent = nil

function M.get_mode()
  return vim.o.background
end

function M.get_colorscheme()
  local ok, content = pcall(vim.fn.readfile, cs_cache)
  local name = ok and content[1] or nil
  if name and SEC_THEMES[name] then
    return name
  end
  return nil
end

function M.get_transparent()
  if M._transparent == nil then
    local tp_ok, tp_content = pcall(vim.fn.readfile, tp_cache)
    M._transparent = tp_ok and tp_content[1] == 'true' or false
  end
  return M._transparent
end

-- toggle_transparent() removed — handled by snacks/toggles.lua

function M.setup()
  local ok, content = pcall(vim.fn.readfile, bg_cache)
  local mode = (ok and content[1] == 'light') and 'light' or 'dark'
  vim.o.background = mode

  local tp_ok, tp_content = pcall(vim.fn.readfile, tp_cache)
  M._transparent = tp_ok and tp_content[1] == 'true' or false

  -- Persist colorscheme on change, but never persist lazy.nvim's bootstrap
  -- fallback (habamax): that would pin the next startup to the fallback.
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
      local name = vim.g.colors_name
      if name and SEC_THEMES[name] then
        vim.fn.writefile({ name }, cs_cache)
      end
    end,
  })
end

function M.register_reloader(name, fn)
  M._reloaders[name] = fn
end

function M.reload()
  local name = vim.g.colors_name
  if name and M._reloaders[name] then
    M._reloaders[name]()
  elseif name then
    vim.cmd('colorscheme ' .. name)
  end
end

-- toggle() removed — handled by snacks/toggles.lua

return M
