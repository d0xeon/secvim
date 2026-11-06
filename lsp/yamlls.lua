return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.ansible' },
  root_markers = { '.git' },
  settings = {
    yaml = {
      schemaStore = { enable = false },
      validate = true,
      completion = true,
      hover = true,
    },
  },
}
