vim.lsp.config("texlab", {
  settings = {
    texlab = {
      build = {
        args = { "-pdf", "-interaction", "nonstopmode", "-synctex", "1", "%f" },
        executable = "latexmk",
        forwardSearchAfter = false,
        onSave = false,
      },
      chktex = {
        onEdit = true,
        onOpenAndSave = true,
      },
      diagnosticsDelay = 300,
      forwardSearch = {
        args = {},
        executable = "zathura",
        onSave = false,
      },
      formatterLineLength = 120,
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = false,
        replacement = "-rv",
      },
    },
  },
})
