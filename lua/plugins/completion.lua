return {
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter" },
    config = function()
      require("lsp.copilot").config()
    end,
    enabled = tonumber(string.sub(Capture("node --version"), 2, 3)) >= 20 and O.copilot,
  },
  {
    "Exafunction/codeium.vim",
    config = function()
      require("lsp.codeium").config()
    end,
    enabled = O.codeium,
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = { "InsertEnter" },
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-l>",
          clear_suggestion = "<C-h>",
          accept_word = "<C-a>",
        },
        ignore_filetypes = { "env" },
        color = {
          cterm = 244,
        },
      })
    end,
    enabled = O.supermaven,
  },
}
