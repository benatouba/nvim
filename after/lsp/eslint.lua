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
    -- Kept save-time behavior (#8): ESLint auto-fix on save, scoped to
    -- buffers where eslint actually attaches (buffer-local BufWritePre).
    -- Replicates upstream's LspEslintFixAll (our override replaces the
    -- default on_attach that would otherwise define it), then runs it.
    vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
      client:request_sync("workspace/executeCommand", {
        command = "eslint.applyAllFixes",
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = vim.lsp.util.buf_versions[bufnr],
          },
        },
      }, nil, bufnr)
    end, {})
    local group = vim.api.nvim_create_augroup("ben_eslint_fix", { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.cmd("LspEslintFixAll")
      end,
      desc = "ESLint: apply all fixes before write",
    })
  end,
}
