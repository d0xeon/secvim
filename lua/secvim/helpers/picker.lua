--- Picker helpers that respect the SecLayout code pane.
local M = {}

--- Open a project picker. When the SecLayout tab is active, plain <CR> opens
--- the selection in the layout's code window instead of replacing whatever
--- terminal pane currently has focus.
function M.pick(source, opts)
  local layout = package.loaded['secvim.sec_plugins.seclayout']
  if layout and layout.is_active and layout.is_active() then
    layout.pick(source, opts)
    return
  end
  local picker = require('snacks').picker
  if type(picker[source]) == 'function' then
    picker[source](opts)
  end
end

function M.files()
  M.pick 'files'
end

function M.git_files()
  M.pick 'git_files'
end

function M.recent()
  M.pick 'recent'
end

return M
