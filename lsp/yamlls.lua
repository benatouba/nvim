vim.lsp.config("yamlls", {
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = true,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      -- schemas = require("schemastore").yaml.schemas(),
    },
  },
})
