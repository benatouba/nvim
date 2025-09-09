vim.lsp.config("tinymist", {
  settings = {
    exportPdf = "onType",
    outputPath = "$root/target/$dir/$name",
    preview = {
      background = {
        enabled = true,
      },
      refresh = "onType",
    },
  },
  filetypes = { "typst" },
})
