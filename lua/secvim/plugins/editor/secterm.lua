-- While the SecAI float (or any secai panel) is focused, swallow the
-- secterm horizontal toggle so it doesn't pop up over the AI window.
local function focused_on_secai()
  return vim.bo.filetype:sub(1, 6) == 'secai'
end

return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_plugins/secterm',
  name = 'secterm',
  lazy = true,
  keys = {
    {
      '<c-\\>',
      function()
        require('secvim.sec_plugins.secterm').toggle_float()
      end,
      mode = { 'n', 'i', 'v', 't' },
      desc = 'Secterm: Toggle Float',
    },
    {
      '<S-z>',
      function()
        require('secvim.sec_plugins.secterm').toggle_float()
      end,
      mode = { 'n' },
      desc = 'Secterm: Toggle Float',
    },
    {
      '<S-x>',
      function()
        if focused_on_secai() then
          return
        end
        require('secvim.sec_plugins.secterm').toggle_horizontal('h_main', 17, 'Terminal')
      end,
      mode = { 'n' },
      desc = 'Secterm: Horizontal',
    },
    {
      '<leader>cii',
      function()
        require('secvim.sec_plugins.secterm').toggle_vertical('v_ci', 70, 'Terminal')
      end,
      desc = 'Secterm: Vertical Split',
    },
    {
      '<leader>cie',
      function()
        require('secvim.sec_plugins.secterm').toggle_horizontal('h_ci', 16, 'Terminal')
      end,
      desc = 'Secterm: Horizontal Split',
    },
    {
      '<leader>cic',
      function()
        require('secvim.sec_plugins.secterm').pick_close()
      end,
      desc = 'Secterm: Close Terminal (Pick)',
    },
    {
      '<leader>ciC',
      function()
        require('secvim.sec_plugins.secterm').close_all()
      end,
      desc = 'Secterm: Close All Terminals',
    },
  },
}
