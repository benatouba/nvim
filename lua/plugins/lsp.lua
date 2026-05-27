return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "b0o/SchemaStore.nvim",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("lsp").config()
    end,
    enabled = O.lsp,
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
    opts = {
      auto_install = false,
    },
    enabled = O.lsp and not O.is_nixos,
  },
  {
    "nvimdev/lspsaga.nvim",
    keys = {
      { "gI", "<cmd>Lspsaga finder imp<CR>", desc = "Implementation" },
      { "ga", "<cmd>Lspsaga code_action<CR>", desc = "Code Action" },
      { "gF", "<cmd>Lspsaga finder def+ref<CR>", desc = "Finder" },
      { "go", "<cmd>Lspsaga outline<CR>", desc = "Outline" },
      { "gp", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek" },
      { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next Diagnostic" },
      { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Prev Diagnostic" },
      { "<leader>ld", "<cmd>Lspsaga goto_definition<cr>", desc = "Definitions" },
    },
    event = { "LspAttach", "InsertEnter", "CmdlineEnter" },
    opts = require("lsp.lspsaga"),
    dependencies = {
      "nvim-web-devicons",
      "nvim-treesitter",
    },
  },
  {
    "xzbdmw/colorful-menu.nvim",
    opts = require("lsp.colorful-menu").opts,
  },
  {
    "folke/lazydev.nvim",
    ---@class lazydev.Config
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = vim.fn.stdpath("config") .. "/lua", words = { "^ben%." } },
      },
      cmp = {
        enable = false,
      },
    },
    ft = "lua",
    enabled = function(root_dir)
      return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
    end,
  },
  {
    "dmmulroy/tsc.nvim",
    enabled = O.typescript,
    ft = { "typescript", "typescriptreact", "vue" },
    config = function()
      require("tsc").setup({
        use_trouble_qflist = true,
        use_diagnostics = true,
      })
      vim.keymap.set("n", "<leader>lt", ":TSC<CR>")
    end,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    enabled = O.typescript,
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
    config = function()
      require("ts-error-translator").setup()
    end,
  },
}
