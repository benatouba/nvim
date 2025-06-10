vim.lsp.config("ts_ls", {
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/home/ben/.local/share/pnpm/global/5/node_modules/@vue/typescript-plugin", -- if this is installed locally, local installation will be used
        languages = { "javascript", "typescript", "vue" },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})
