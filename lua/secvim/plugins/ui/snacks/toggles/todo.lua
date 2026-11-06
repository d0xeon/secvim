local toggles = require 'secvim.config.toggles'

local function sectodo()
  return require 'secvim.helpers.sectodo'
end

return function()
  Snacks.toggle({
    name = 'Todo Comments',
    get = function()
      return toggles.get 'todo_comments'
    end,
    set = function(state)
      sectodo().set_enabled(state)
    end,
  }):map '<leader>lh'

  Snacks.toggle({
    name = 'Todo Background',
    get = function()
      return toggles.get 'todo_comments_bg'
    end,
    set = function(state)
      sectodo().set_bg(state)
    end,
  }):map '<leader>lqcb'

  Snacks.toggle({
    name = 'Todo Foreground',
    get = function()
      return toggles.get 'todo_comments_fg'
    end,
    set = function(state)
      sectodo().set_fg(state)
    end,
  }):map '<leader>lqcf'
end
