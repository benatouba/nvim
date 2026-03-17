return {
  settings = {
    -- This is the magic bullet for ESLint v9 / Flat Config:
    useESLintClass = true,
    
    experimental = {
      useFlatConfig = true,
    },
    
    workingDirectories = { mode = "auto" },
    
    -- By explicitly listing 'vue' here instead of leaving it 'on',
    -- the server is forced to lint the file and will visibly throw an 
    -- error in Neovim if it fails, rather than failing silently.
    validate = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
    },
  },
  on_attach = function(client, bufnr)
    -- Optional: Auto-fix on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
}
