return {
  cmd = { 'taplo', 'lsp', 'stdio' },
  filetypes = { 'toml' },
  root_markers = { 'Cargo.toml', 'pyproject.toml', 'foundry.toml', '.git' },
  settings = {
    evenBetterToml = {
      schema = { enabled = false },
    },
  },
}
