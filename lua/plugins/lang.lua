return {
  {
    "davidgranstrom/scnvim",
    ft = { "supercollider", "scd" },
    cmd = {
      "SCNvimStart",
      "SCNvimStop",
      "SCNvimRecompile",
      "SCNvimGenerateAssets",
      "SCNvimHardstop",
    },

    init = function()
      vim.g.scnvim_postwin_syntax_hl = 1
      vim.g.scnvim_scdoc = 1
      vim.g.scnvim_postwin_orientation = "v"
      vim.g.scnvim_postwin_direction = "right"
      vim.g.scnvim_postwin_size = 50
      vim.g.scnvim_postwin_auto_toggle = 1
    end,
    keys = {
      { "<leader>ms", "<cmd>SCNvimStart<cr>", desc = "SuperCollider start" },
      { "<leader>mS", "<cmd>SCNvimStop<cr>", desc = "SuperCollider stop" },
      { "<leader>mr", "<cmd>SCNvimRecompile<cr>", desc = "SuperCollider recompile" },
      { "<leader>mh", "<cmd>SCNvimHardstop<cr>", desc = "SuperCollider hard stop" },
      { "<leader>ma", "<cmd>SCNvimGenerateAssets<cr>", desc = "SuperCollider generate assets" },
    },
    config = function()
      local scnvim = require("scnvim")
      local map = scnvim.map
      local map_expr = scnvim.map_expr

      scnvim.setup({
        keymaps = {
          ["<M-e>"] = map("editor.send_line", { "i", "n" }),
          ["<C-e>"] = {
            map("editor.send_block", { "i", "n" }),
            map("editor.send_selection", "x"),
          },
          ["<CR>"] = map("postwin.toggle"),
          ["<M-CR>"] = map("postwin.toggle", "i"),
          ["<M-L>"] = map("postwin.clear", { "n", "i" }),
          ["<C-k>"] = map("signature.show", { "n", "i" }),
          ["<F12>"] = map("sclang.hard_stop", { "n", "x", "i" }),
          ["<leader>mt"] = map("sclang.start"),
          ["<leader>mT"] = map("sclang.recompile"),
          ["<leader>mk"] = map("sclang.stop"),
          ["<F1>"] = map_expr("s.boot"),
          ["<F2>"] = map_expr("s.meter"),
        },
        postwin = {
          float = {
            enabled = true,
          },
        },
      })
    end,
  },
  {
    "tidalcycles/vim-tidal",
    ft = { "tidal" },
    keys = {
      { "<leader>mt", "<cmd>TidalLaunch<cr>", desc = "Tidal launch" },
      { "<leader>mq", "<cmd>TidalQuit<cr>", desc = "Tidal quit" },
      { "<leader>mb", "<cmd>TidalBoot<cr>", desc = "Tidal boot" },
    },
    init = function()
      vim.g.tidal_target = "terminal"
      vim.g.tidal_ghci = "ghci"
      vim.g.tidal_boot = "BootTidal.hs"
      vim.g.tidal_sc_enable = 0
    end,
    enabled = false,
  },
  {
    "grddavies/tidal.nvim",
    ft = { "tidal", "scd" },
    opts = {
      boot = {
        tidal = {
          cmd = "ghci",
          args = { "-v0" },
          file = vim.api.nvim_get_runtime_file("bootfiles/BootTidal.hs", false)[1],
          enabled = true,
        },
        sclang = {
          cmd = "sclang",
          args = {},
          file = vim.api.nvim_get_runtime_file("bootfiles/BootSuperDirt.scd", false)[1],
          enabled = true,
        },
        split = "v",
      },
    },
  },
  {
    "magicmonty/sonicpi.nvim",
    ft = { "sonicpi" },
    cmd = {
      "SonicPiStart",
      "SonicPiStop",
      "SonicPiSendBuffer",
      "SonicPiEval",
    },
    keys = {
      { "<leader>mp", "<cmd>SonicPiStart<cr>", desc = "Sonic Pi start" },
      { "<leader>mP", "<cmd>SonicPiStop<cr>", desc = "Sonic Pi stop" },
      { "<leader>me", "<cmd>SonicPiEval<cr>", mode = { "n", "v" }, desc = "Sonic Pi eval" },
      { "<leader>mB", "<cmd>SonicPiSendBuffer<cr>", desc = "Sonic Pi send buffer" },
    },
    dependencies = {
      "saghen/blink.compat",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("sonicpi").setup({
        server_dir = vim.env.SONIC_PI_SERVER_DIR or "",
        lsp_diagnostics = true,
      })
    end,
  },
  {
    "R-nvim/R.nvim",
    ft = { "r", "rmd" },
    config = function()
      require("misc.r-nvim").config()
    end,
  },
  { "saltstack/salt-vim", ft = "sls", enabled = O.salt },
  { "Glench/Vim-Jinja2-Syntax", ft = { "sls", "Jinja2" }, enabled = O.salt },
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      require("misc.vimtex").config()
    end,
    enabled = O.latex,
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = { "typst" },
    version = false,
    opts = {},
    keys = {
      { "<localleader>tt", "<cmd>TypstPreviewToggle<cr>", desc = "Typst Preview Toggle" },
    },
  },
  {
    "wllfaria/ledger.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "hledger", "ledger" },
    opts = {
      extensions = {
        "ledger",
        "hledger",
        "journal",
      },
      completion = {
        cmp = { enabled = false },
      },
      snippets = {
        cmp = { enabled = false },
        luasnip = { enabled = false },
        native = { enabled = true },
      },
      keymaps = {
        snippets = {
          new_posting = { "tt" },
          new_account = { "acc" },
          new_posting_today = { "td" },
          new_commodity = { "cm" },
        },
        reports = {},
      },
      diagnostics = {
        lsp_diagnostics = true,
        strict = false,
      },
    },
  },
  {
    "vuki656/package-info.nvim",
    config = function()
      require("misc.package_info").config()
    end,
    enabled = O.webdev and O.misc,
    ft = { "json" },
  },
  {
    "danymat/neogen",
    opts = require("misc.neogen").opts,
    dependencies = "nvim-treesitter/nvim-treesitter",
    enabled = O.language_parsing,
    event = "InsertEnter",
  },
  {
    "ThePrimeagen/refactoring.nvim",
    event = "InsertEnter",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require("misc.refactoring").config()
    end,
    keys = require("misc.refactoring").maps,
    enabled = O.language_parsing and O.misc,
  },
}
