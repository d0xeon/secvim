return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_plugins/secpreview',
  name = 'secpreview',
  config = function()
    require('secvim.sec_plugins.secpreview').setup()
  end,
  keys = {
    {
      'gp',
      function()
        require('secvim.sec_plugins.secpreview').definition()
      end,
      desc = 'Secpreview: Definition',
    },
    {
      'gP',
      function()
        require('secvim.sec_plugins.secpreview').close_all()
      end,
      desc = 'Secpreview: Close All',
    },
    -- {
    --   'gpt',
    --   function()
    --     require('secvim.sec_plugins.secpreview').type_definition()
    --   end,
    --   desc = 'Secpreview: Type Definition',
    -- },
    -- {
    --   'gpi',
    --   function()
    --     require('secvim.sec_plugins.secpreview').implementation()
    --   end,
    --   desc = 'Secpreview: Implementation',
    -- },
    -- {
    --   'gpD',
    --   function()
    --     require('secvim.sec_plugins.secpreview').declaration()
    --   end,
    --   desc = 'Secpreview: Declaration',
    -- },
    -- {
    --   'gpr',
    --   function()
    --     require('secvim.sec_plugins.secpreview').references()
    --   end,
    --   desc = 'Secpreview: References',
    -- },
  },
}
