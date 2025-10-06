vim.lsp.config("basedpyright", {
  -- before_init = function(_, config)
  --   config.settings.python.pythonPath = Get_python_venv() .. "/bin/python"
  --   config.settings.basedpyright.analysis.stubPath = vim.fs.joinpath(
  --     -- vim.fn.expand(vim.fn.stdpath("data")),
  --     -- "lazy",
  --     -- "python-type-stubs",
  --     -- "stubs"
  --     vim.fs.joinpath(vim.fn.expand("~"), ".local", "src", "python-type-stubs", "stubs")
  --   )
  -- end,
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
})
