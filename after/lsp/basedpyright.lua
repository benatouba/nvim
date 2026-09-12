return {
  on_init = function(client)
    client.server_capabilities.declarationProvider = true
    client.server_capabilities.definitionProvider = true
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.hoverProvider = true
    client.server_capabilities.referencesProvider = true
    client.server_capabilities.renameProvider = false
  end,
  settings = {
    basedpyright = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        inlayHints = {
          genericTypes = true,
          chainedCallHints = true,
          memberVariableTypeHints = true,
          parameterHints = true,
          typeHints = true,
        },
      },
      disableOrganizeImports = true,
    },
  },
}
