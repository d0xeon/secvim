local toggles = require 'secvim.config.toggles'

local function refresh()
  local ok, secmaximize = pcall(require, 'secvim.sec_plugins.secmaximize')
  if ok then
    secmaximize.refresh()
  end
end

return function()
  Snacks.toggle({
    name = 'Secmaximize Lualine',
    wk_desc = { enabled = 'Hide ', disabled = 'Show ' },
    get = function()
      return toggles.get 'secmaximize_lualine'
    end,
    set = function(state)
      toggles.set('secmaximize_lualine', state)
      refresh()
    end,
  }):map '<leader>laml'

  Snacks.toggle({
    name = 'Secmaximize Badge',
    wk_desc = { enabled = 'Hide ', disabled = 'Show ' },
    get = function()
      return toggles.get 'secmaximize_badge'
    end,
    set = function(state)
      toggles.set('secmaximize_badge', state)
      refresh()
    end,
  }):map '<leader>lamb'

  -- Display: ON = "max" text + icon, OFF = icon only
  Snacks.toggle({
    name = 'Secmaximize Name',
    wk_desc = { enabled = 'Icon only ', disabled = 'Show name ' },
    get = function()
      return toggles.get 'secmaximize_name'
    end,
    set = function(state)
      toggles.set('secmaximize_name', state)
      refresh()
    end,
  }):map '<leader>lamn'

  -- Badge border picker: none / rounded / straight (persisted)
  vim.keymap.set('n', '<leader>lqx', function()
    local borders = {
      { name = 'none', label = 'None', glyph = '󰝤' },
      { name = 'rounded', label = 'Rounded', glyph = '󰐝' },
      { name = 'single', label = 'Straight', glyph = '󰝘' },
    }
    local current = toggles.get 'secmaximize_border'
    vim.ui.select(borders, {
      prompt = 'Secmaximize · select border',
      kind = 'secmaximize_border',
      format_item = function(b)
        return b.glyph .. '  ' .. b.label .. (b.name == current and ' ●' or '')
      end,
    }, function(choice)
      if not choice then
        return
      end
      toggles.set('secmaximize_border', choice.name)
      refresh()
      Snacks.notify.info('Secmaximize border: ' .. choice.label)
    end)
  end, { desc = 'Secmaximize: Select Border' })
end
