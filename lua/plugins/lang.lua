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
    lazy = false,
    dependencies = {
      "lewis6991/async.nvim",
    },
    opts = {},
    init = function()
      local keymap = vim.keymap

      keymap.set({ "n", "x" }, "<localleader>re", function()
        return require("refactoring").extract_func()
      end, { desc = "Extract Function", expr = true })
      -- `_` is the default textobject for "current line"
      keymap.set("n", "<localleader>ree", function()
        return require("refactoring").extract_func() .. "_"
      end, { desc = "Extract Function (line)", expr = true })

      keymap.set({ "n", "x" }, "<localleader>rE", function()
        return require("refactoring").extract_func_to_file()
      end, { desc = "Extract Function To File", expr = true })

      keymap.set({ "n", "x" }, "<localleader>rv", function()
        return require("refactoring").extract_var()
      end, { desc = "Extract Variable", expr = true })

      -- `_` is the default textobject for "current line"
      keymap.set("n", "<localleader>rvv", function()
        return require("refactoring").extract_var() .. "_"
      end, { desc = "Extract Variable (line)", expr = true })

      keymap.set({ "n", "x" }, "<localleader>ri", function()
        return require("refactoring").inline_var()
      end, { desc = "Inline Variable", expr = true })
      keymap.set({ "n", "x" }, "<localleader>rI", function()
        return require("refactoring").inline_func()
      end, { desc = "Inline function", expr = true })

      keymap.set({ "n", "x" }, "<localleader>rs", function()
        return require("refactoring").select_refactor()
      end, { desc = "Select refactor" })

      -- `iw` is the builtin textobject for "in word". You can use any other textobject or even create the keymap without any textobject if you prefer to provide one yourself each time that you use the keymap
      keymap.set({ "x", "n" }, "<localleader>pv", function()
        return require("refactoring.debug").print_var({ output_location = "below" }) .. "iw"
      end, { desc = "Debug print var below", expr = true })

      -- `iw` is the builtin textobject for "in word". You can use any other textobject or even create the keymap without any textobject if you prefer to provide one yourself each time that you use the keymap
      keymap.set({ "x", "n" }, "<localleader>pV", function()
        return require("refactoring.debug").print_var({ output_location = "above" }) .. "iw"
      end, { desc = "Debug print var above", expr = true })

      keymap.set({ "x", "n" }, "<localleader>pe", function()
        return require("refactoring.debug").print_exp({ output_location = "below" })
      end, { desc = "Debug print exp below", expr = true })
      -- `_` is the default textobject for "current line"
      keymap.set("n", "<localleader>pee", function()
        return require("refactoring.debug").print_exp({ output_location = "below" }) .. "_"
      end, { desc = "Debug print exp below", expr = true })

      keymap.set({ "x", "n" }, "<localleader>pE", function()
        return require("refactoring.debug").print_exp({ output_location = "above" })
      end, { desc = "Debug print exp above", expr = true })
      -- `_` is the default textobject for "current line"
      keymap.set("n", "<localleader>pEE", function()
        return require("refactoring.debug").print_exp({ output_location = "above" }) .. "_"
      end, { desc = "Debug print exp above", expr = true })

      keymap.set("n", "<localleader>pP", function()
        return require("refactoring.debug").print_loc({ output_location = "above" })
      end, { desc = "Debug print location", expr = true })
      keymap.set("n", "<localleader>pp", function()
        return require("refactoring.debug").print_loc({ output_location = "below" })
      end, { desc = "Debug print location", expr = true })

      keymap.set({ "x", "n" }, "<localleader>pc", function()
        -- `ag` is a custom textobject that selects the whole buffer. It's provided by plugins like `mini.ai` (requires manual configuration using `MiniExtra.gen_ai_spec.buffer()`).
        -- return require("refactoring.debug").cleanup { restore_view = true } .. "ag"

        -- this keymap doesn't select any textobject by default, so you need to provide one each time you use it.
        return require("refactoring.debug").cleanup({ restore_view = true })
      end, { desc = "Debug print clean", expr = true, remap = true })
    end,
    enabled = O.language_parsing and O.misc,
  },
}
