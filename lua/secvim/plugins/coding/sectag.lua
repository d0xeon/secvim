return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_plugins/sectag',
  name = 'sectag',
  -- Kept in sync with sectag/config.lua M.filetypes; inlined so the spec
  -- import does not require the module at startup.
  ft = {
    'html',
    'htmldjango',
    'xml',
    'svg',
    'php',
    'blade',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
    'astro',
    'templ',
    'eruby',
    'handlebars',
    'twig',
  },
  config = function()
    require('secvim.sec_plugins.sectag').setup()
  end,
  -- <leader>kr is buffer-local (set on attach), toggles in snacks/toggles/sectag.lua
}
