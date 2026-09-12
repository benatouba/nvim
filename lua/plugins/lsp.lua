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
    -- mason-lspconfig v2: install the shared server list and let it call vim.lsp.enable().
    opts = function()
      return {
        ensure_installed = require("lsp.servers").servers,
        automatic_enable = true,
      }
    end,
    enabled = not vim.g.is_nixos,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = { "LspAttach", "InsertEnter", "CmdlineEnter" },
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
    keys = {
      -- gI is the native implementation lookup from lua/lsp/attach.lua (buffer-local, wins anyway)
      { "ga", "<cmd>Lspsaga code_action<CR>", desc = "Code Action" },
      { "gF", "<cmd>Lspsaga finder def+ref<CR>", desc = "Finder" },
      { "go", "<cmd>Lspsaga outline<CR>", desc = "Outline" },
      { "gp", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek" },
      { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next Diagnostic" },
      { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Prev Diagnostic" },
      { "<leader>ld", "<cmd>Lspsaga goto_definition<cr>", desc = "Definitions" },
    },
    opts = function()
      local cp_ok, cp = pcall(require, "catppuccin.groups.integrations.lsp_saga")
      return {
        code_action = {
          num_shortcut = true,
          show_server_name = true,
          extend_gitsigns = true,
          keys = { quit = { "q", "<ESC>" }, exec = "<CR>" },
        },
        lightbulb = { enable = false },
        hover = { enable = true, max_width = 0.6, open_link = "gx", open_browser = "!brave" },
        ui = {
          title = true,
          border = "rounded",
          lines = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          winblend = 0,
          expand = "",
          collapse = "",
          code_action = "💡",
          incoming = " ",
          outgoing = " ",
          hover = " ",
          kind = cp_ok and cp.custom_kind() or nil,
        },
        request_timeout = 5000,
      }
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    enabled = function()
      return vim.g.lazydev_enabled ~= false
    end,
    ---@class lazydev.Config
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = vim.fn.stdpath("config") .. "/lua", words = { "^config%.", "^plugins%.", "^lsp%." } },
      },
      integrations = { cmp = false }, -- completion goes through blink's lazydev source
    },
  },
  {
    "dmmulroy/tsc.nvim",
    ft = { "typescript", "typescriptreact", "vue" },
    keys = { { "<leader>lt", "<cmd>TSC<CR>", desc = "Typecheck (tsc)" } },
    opts = { use_trouble_qflist = true, use_diagnostics = true },
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
    opts = {},
  },
}
