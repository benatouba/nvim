-- MATLAB LSP server
vim.lsp.config("matlab_ls", {
  settings = {
    MATLAB = {
      installPath = "~/.local/matlab/", -- Change this to your MATLAB installation path
      telemetry = false,
    },
  },
})

vim.lsp.enable("matlab_ls")
