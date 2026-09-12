return {
  on_init = function(client)
    client.server_capabilities.callHierarchyProvider = false
    client.server_capabilities.codeActionProvider = true
    client.server_capabilities.declarationProvider = true
    client.server_capabilities.definitionProvider = true
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentHighlightProvider = true
    client.server_capabilities.documentLinkProvider = false
    client.server_capabilities.documentOnTypeFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.documentSymbolProvider = true
    client.server_capabilities.foldingRangeProvider = false
    client.server_capabilities.hoverProvider = true
    client.server_capabilities.implementationProvider = false
    client.server_capabilities.referencesProvider = true
    client.server_capabilities.renameProvider = true
    client.server_capabilities.typeDefinitionProvider = true
    client.server_capabilities.typeHierarchyProvider = false
    client.server_capabilities.workspaceSymbolProvider = true
  end,
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = { "ty.toml", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
}
