return {
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
