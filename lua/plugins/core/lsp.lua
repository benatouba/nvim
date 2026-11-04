-- Core language support: server configs, and Mason off NixOS. Mason installs nothing
-- by itself here; the provisioning group adds that.
return {
  {
    "neovim/nvim-lspconfig",
    -- Loaded eagerly: its lsp/*.lua defaults must be on the runtime path before
    -- vim.lsp.enable() runs. Config priority: lsp/ -> after/lsp/ -> vim.lsp.config().
    lazy = false,
    dependencies = {
      "saghen/blink.cmp",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      require("lsp").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "InsertEnter", "CmdlineEnter", "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>pm", "<cmd>Mason<cr>", desc = "Info" },
      { "<leader>Lm", "<cmd>MasonLog<cr>", desc = "Log" },
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          pip = {
            upgrade_pip = true,
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
    -- Project-owned Python servers are enabled separately, never installed by Mason.
    opts = function()
      return {
        ensure_installed = require("lsp.servers").mason_servers(),
        automatic_enable = require("lsp.servers").mason_servers(),
      }
    end,
    enabled = not vim.g.is_nixos,
  },
}
