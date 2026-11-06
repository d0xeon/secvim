--- Snacks explorer helpers.
--- The explorer is a picker in a sidebar layout, so "go to the sidebar" means
--- focusing an open picker, and "close it" means closing that picker. `<C-b>`
--- toggles from anywhere; `<leader>e` focuses from the editor and closes when
--- the cursor is already inside the sidebar.
local M = {}

local function snacks()
  local ok, mod = pcall(require, 'snacks')
  if not ok then
    return nil
  end
  return mod
end

local function active()
  local mod = snacks()
  if not mod then
    return nil
  end
  return mod.picker.get({ source = 'explorer' })[1]
end

local function current_inside(picker)
  local cur = vim.api.nvim_get_current_win()
  if picker.layout and picker.layout.root and picker.layout.root.win == cur then
    return true
  end
  for _, win in pairs((picker.layout and picker.layout.wins) or {}) do
    if win.win == cur then
      return true
    end
  end
  return false
end

function M.open()
  local mod = snacks()
  if mod then
    mod.explorer()
  end
end

function M.toggle()
  local mod = snacks()
  if not mod then
    return
  end
  local pickers = mod.picker.get { source = 'explorer' }
  if #pickers > 0 then
    for _, picker in ipairs(pickers) do
      picker:close()
    end
  else
    mod.explorer()
  end
end

--- Focus the sidebar from the editor; close it when already focused.
function M.smart()
  local picker = active()
  if not picker then
    M.open()
    return
  end
  if current_inside(picker) then
    picker:close()
  else
    picker:focus()
  end
end

return M
