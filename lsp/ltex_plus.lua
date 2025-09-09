vim.lsp.config("ltex_plus", {
  settings = {
    ltex = {
      language = "en-US",
      diagnosticSeverity = "information",
      sentenceCacheSize = 2000,
      additionalRules = {
        enablePickyRules = true,
        motherTongue = "de-DE",
      },
      load_langs = { "en-US" },
      path = vim.fn.stdpath("config") .. "/spell/",
    },
  },
})
