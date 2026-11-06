return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
        extraArgs = { '--all-targets' },
      },
      cargo = { allFeatures = true },
      procMacro = { enable = true },
      inlayHints = {
        bindingModeHints = { enable = false },
        closureReturnTypeHints = { enable = 'with_block' },
        lifetimeElisionHints = { enable = 'skip_trivial' },
      },
      imports = {
        granularity = { group = 'module' },
        prefix = 'self',
      },
    },
  },
}
