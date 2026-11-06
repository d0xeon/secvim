local toggles = require 'secvim.config.toggles'

--- No-op until Sectag loads: with no html/jsx buffer open there is nothing
--- to re-attach, the new state is read on load.
local function refresh()
  if package.loaded['secvim.sec_plugins.sectag'] then
    require('secvim.sec_plugins.sectag').refresh()
  end
end

return function()
  Snacks.toggle({
    name = 'Sectag',
    wk_desc = { enabled = 'Disable ', disabled = 'Enable ' },
    get = function()
      return toggles.get 'sectag'
    end,
    set = function(state)
      toggles.set('sectag', state)
      refresh()
    end,
  }):map '<leader>lv'

  Snacks.toggle({
    name = 'Sectag Auto Close Tag',
    wk_desc = { enabled = 'Disable ', disabled = 'Enable ' },
    get = function()
      return toggles.get 'sectag_close'
    end,
    set = function(state)
      toggles.set('sectag_close', state)
      refresh()
    end,
  }):map '<leader>latc'

  Snacks.toggle({
    name = 'Sectag Auto Live Rename Tag',
    wk_desc = { enabled = 'Disable ', disabled = 'Enable ' },
    get = function()
      return toggles.get 'sectag_rename'
    end,
    set = function(state)
      toggles.set('sectag_rename', state)
      refresh()
    end,
  }):map '<leader>latr'
end
