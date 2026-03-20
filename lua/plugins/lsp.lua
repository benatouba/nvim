return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "saghen/blink.compat",
        version = "*",
        event = "VeryLazy",
        opts = {
          impersonate_nvim_cmp = false,
        },
      },
      {
        "saghen/blink.cmp",
        enabled = true,
        version = "*",
        build = "cargo build --release",
        event = "VeryLazy",
        dependencies = {
          "rafamadriz/friendly-snippets",
          "mikavilpas/blink-ripgrep.nvim",
          "Kaiser-Yang/blink-cmp-git",
          "hrsh7th/cmp-nvim-lua",
          "joelazar/blink-calc",
          "hrsh7th/cmp-emoji",
          "onsails/lspkind.nvim",
          {
            "rcarriga/cmp-dap",
            ft = { "dap-repl", "dapui_watches", "dapui_hover" },
          },
          {
            "philosofonusus/ecolog.nvim",
            keys = {
              { "<leader>Eg", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
              { "<leader>Ep", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
              { "<leader>Es", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
              { "<leader>se", "<cmd>EcologTelescope<cr>", desc = "Env" },
              { "<leader>ev", "<cmd>Ecolog list<cr>", desc = "List env variables" },
              { "<leader>ef", "<cmd>Ecolog files select<cr>", desc = "Select env file" },
            },
            event = { "InsertEnter", "CmdlineEnter", "BufNewFile", "BufReadPre" },
            opts = {
              picker = { backend = "telescope" },
              integrations = { lsp = false },
            },
          },
        },
        opts = require("lsp.blink").opts,
        opts_extend = { "sources.default" },
      },
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
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        gitcommit = { "commitmsgfmt" },
        jsonc = { "jq", stop_after_first = true },
        lua = { "stylua", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        nix = { "nixfmt", stop_after_first = true },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports", "docformatter", stop_after_first = false },
        quarto = { "injected" },
        r = { "air", stop_after_first = true },
        rmd = { "injected" },
        scss = { "oxfmt" },
        tex = { "latexindent", stop_after_first = true },
        javascript = { "oxfmt" },
        typescript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        vue = { "oxfmt" },
        json = { "oxfmt" },
        html = { "oxfmt" },
        css = { "oxfmt" },
        typst = { "typstyle", stop_after_first = true },
        yaml = { "yamlfmt", stop_after_first = true },
        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.api.nvim_create_autocmd("InsertLeave", {
        pattern = "*COMMIT_EDITMSG*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf, timeout_ms = 2500, lsp_format = "never" })
        end,
      })
    end,
    ft = { "gitcommit" },
    keys = {
      { "<leader>Lf", "<cmd>ConformInfo<cr>", desc = "Conform Info" },
      {
        "<leader>lf",
        '<cmd>lua require("conform").format({ lsp_format = "fallback", timeout_ms = 5000 })<cr>',
        desc = "Format",
      },
    },
    enabled = O.language_parsing,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        NeogitCommitMessage = { "commitlint" },
        c = { "compiler" },
        gitcommit = { "commitlint" },
        htmldjango = { "djlint" },
        jinja = { "djlint" },
        markdown = { "alex" },
        nix = { "statix" },
        tex = { "proselint" },
        zsh = { "zsh" },
        [".*/.github/workflows/.*%.yml"] = { "yaml.ghaction" },
      }
      local ns = require("lint").get_namespace("commitlint")
      vim.diagnostic.config({ virtual_text = true, signs = true, update_in_insert = true }, ns)
      vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = "lint",
        callback = function()
          require("lint").try_lint()
        end,
      })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = "lint",
        callback = function()
          require("lint").try_lint("editorconfig-checker")
        end,
      })
      vim.api.nvim_create_autocmd({ "TextChanged" }, {
        group = "lint",
        pattern = "*COMMIT_EDITMSG*",
        callback = function()
          require("lint").try_lint("commitlint")
        end,
      })
    end,
    enabled = O.language_parsing,
  },
}
