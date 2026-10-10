-- Language-specific plugins: live coding (SuperCollider, Tidal, Sonic Pi), R, LaTeX, Typst,
-- ledger, package.json, annotations, refactoring.
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
      { "<leader>Ms", "<cmd>SCNvimStart<cr>", desc = "SuperCollider start", ft = { "supercollider", "scd" } },
      { "<leader>MS", "<cmd>SCNvimStop<cr>", desc = "SuperCollider stop", ft = { "supercollider", "scd" } },
      { "<leader>Mc", "<cmd>SCNvimRecompile<cr>", desc = "SuperCollider recompile", ft = { "supercollider", "scd" } },
      { "<leader>Mh", "<cmd>SCNvimHardstop<cr>", desc = "SuperCollider hard stop", ft = { "supercollider", "scd" } },
      {
        "<leader>Ma",
        "<cmd>SCNvimGenerateAssets<cr>",
        desc = "SuperCollider generate assets",
        ft = { "supercollider", "scd" },
      },
    },
    opts = function()
      local scnvim = require("scnvim")
      local map = scnvim.map
      local map_expr = scnvim.map_expr
      return {
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
          ["<F1>"] = map_expr("s.boot"),
          ["<F2>"] = map_expr("s.meter"),
        },
        postwin = { float = { enabled = true } },
      }
    end,
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
      { "<leader>Mp", "<cmd>SonicPiStart<cr>", desc = "Sonic Pi start", ft = "sonicpi" },
      { "<leader>MP", "<cmd>SonicPiStop<cr>", desc = "Sonic Pi stop", ft = "sonicpi" },
      { "<leader>Me", "<cmd>SonicPiEval<cr>", mode = { "n", "v" }, desc = "Sonic Pi eval", ft = "sonicpi" },
      { "<leader>MB", "<cmd>SonicPiSendBuffer<cr>", desc = "Sonic Pi send buffer", ft = "sonicpi" },
    },
    dependencies = {
      "saghen/blink.compat",
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      return { server_dir = vim.env.SONIC_PI_SERVER_DIR or "", lsp_diagnostics = true }
    end,
  },
  {
    "R-nvim/R.nvim",
    ft = { "r", "rmd" },
    init = function()
      vim.g.rout_follow_colorscheme = true
    end,
    opts = function()
      local opts = {
        R_args = { "--quiet", "--no-save" },
        objbr_mappings = { -- Object browser keymap
          c = "class",
          ["<localleader>gg"] = "head({object}, n = 15)",
          v = function()
            require("r.browser").toggle_view()
          end,
        },
        Rout_more_colors = true,
        Rout_follow_colorscheme = true,
        hook = {
          on_filetype = function()
            vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true })
            vim.keymap.set("v", "<Enter>", "<Plug>RSendSelection", { buffer = true })
          end,
        },
        min_editor_width = 72,
        rconsole_width = 78,
        disable_cmds = { "RClearConsole", "RCustomStart", "RSPlot", "RSaveClose" },
        auto_start = "always",
        view_df = { open_app = "terminal:vd" },
      }
      -- alias r "R_AUTO_START=true nvim"
      if vim.env.R_AUTO_START == "true" then
        opts.auto_start = 1
        opts.objbr_auto_start = true
      end
      return opts
    end,
  },
  {
    "lervag/vimtex",
    -- Upstream warns against plugin-manager lazy-loading (inverse search needs the
    -- global command); its own filetype/autoload machinery already defers the work.
    lazy = false,
    init = function()
      require("plugins.configs.vimtex").init()
    end,
    config = function()
      require("plugins.configs.vimtex").config()
    end,
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = { "typst" },
    version = false,
    -- On NixOS the preview binaries come from Nix (pkgs.tinymist, pkgs.websocat);
    -- pointing the plugin at them keeps it from downloading GitHub releases.
    opts = function()
      local bins = {}
      for _, tool in ipairs({ "tinymist", "websocat" }) do
        if vim.fn.executable(tool) == 1 then
          bins[tool] = vim.fn.exepath(tool)
        end
      end
      if vim.g.is_nixos and next(bins) == nil then
        vim.notify("typst-preview needs tinymist and websocat from Nix (nixpkgs)", vim.log.levels.WARN)
      end
      return { dependencies_bin = bins }
    end,
    keys = {
      { "<localleader>tt", "<cmd>TypstPreviewToggle<cr>", desc = "Typst Preview Toggle", ft = "typst" },
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
      completion = { cmp = { enabled = false } },
      snippets = { cmp = { enabled = false }, luasnip = { enabled = false }, native = { enabled = true } },
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
    ft = { "json" },
    keys = {
      { "<leader>lpa", "<cmd>lua require('package-info').install()<cr>", desc = "Add", ft = "json" },
      { "<leader>lpc", "<cmd>lua require('package-info').change_version()<cr>", desc = "Change version", ft = "json" },
      { "<leader>lpd", "<cmd>lua require('package-info').delete()<cr>", desc = "Delete", ft = "json" },
      { "<leader>lph", "<cmd>lua require('package-info').hide()<cr>", desc = "Hide", ft = "json" },
      { "<leader>lpi", "<cmd>lua require('package-info').install()<cr>", desc = "Install", ft = "json" },
      { "<leader>lps", "<cmd>lua require('package-info').show()<cr>", desc = "Show", ft = "json" },
      { "<leader>lpt", "<cmd>lua require('package-info').toggle()<cr>", desc = "Toggle", ft = "json" },
      { "<leader>lpu", "<cmd>lua require('package-info').update()<cr>", desc = "Update", ft = "json" },
    },
    opts = {
      package_manager = "pnpm",
      hide_up_to_date = true,
    },
  },
  {
    "danymat/neogen",
    opts = {
      enabled = true,
      languages = {
        lua = { template = { annotation_convention = "emmylua" } },
        python = { template = { annotation_convention = "google_docstrings" } },
        javascript = { template = { annotation_convention = "jsdoc" } },
        typescript = { template = { annotation_convention = "tsdoc" } },
        vue = { template = { annotation_convention = "jsdoc" } },
      },
    },
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "InsertEnter",
    keys = {
      { "<leader>nn", "<cmd>lua require('neogen').generate()<CR>", desc = "Auto" },
      { "<leader>nc", "<cmd>lua require('neogen').generate({ type = 'class'})<CR>", desc = "Class" },
      { "<leader>nf", "<cmd>lua require('neogen').generate({ type = 'func'})<CR>", desc = "Function" },
      { "<leader>nt", "<cmd>lua require('neogen').generate({ type = 'type'})<CR>", desc = "Type" },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "lewis6991/async.nvim" },
    opts = {},
    keys = function()
      local r = function()
        return require("refactoring")
      end
      local dbg = function()
        return require("refactoring.debug")
      end
      -- `_` is the built-in textobject for the current line, `iw` for the word under the cursor
      return {
        {
          "<localleader>re",
          function()
            return r().extract_func()
          end,
          mode = { "n", "x" },
          expr = true,
          desc = "Extract Function",
        },
        {
          "<localleader>ree",
          function()
            return r().extract_func() .. "_"
          end,
          expr = true,
          desc = "Extract Function (line)",
        },
        {
          "<localleader>rE",
          function()
            return r().extract_func_to_file()
          end,
          mode = { "n", "x" },
          expr = true,
          desc = "Extract Function To File",
        },
        {
          "<localleader>rv",
          function()
            return r().extract_var()
          end,
          mode = { "n", "x" },
          expr = true,
          desc = "Extract Variable",
        },
        {
          "<localleader>rvv",
          function()
            return r().extract_var() .. "_"
          end,
          expr = true,
          desc = "Extract Variable (line)",
        },
        {
          "<localleader>ri",
          function()
            return r().inline_var()
          end,
          mode = { "n", "x" },
          expr = true,
          desc = "Inline Variable",
        },
        {
          "<localleader>rI",
          function()
            return r().inline_func()
          end,
          mode = { "n", "x" },
          expr = true,
          desc = "Inline function",
        },
        {
          "<localleader>rs",
          function()
            r().select_refactor()
          end,
          mode = { "n", "x" },
          desc = "Select refactor",
        },
        {
          "<localleader>pv",
          function()
            return dbg().print_var({ output_location = "below" }) .. "iw"
          end,
          mode = { "n", "x" },
          expr = true,
          desc = "Debug print var below",
        },
        {
          "<localleader>pV",
          function()
            return dbg().print_var({ output_location = "above" }) .. "iw"
          end,
          mode = { "n", "x" },
          expr = true,
          desc = "Debug print var above",
        },
        {
          "<localleader>pe",
          function()
            return dbg().print_exp({ output_location = "below" })
          end,
          mode = { "n", "x" },
          expr = true,
          desc = "Debug print exp below",
        },
        {
          "<localleader>pee",
          function()
            return dbg().print_exp({ output_location = "below" }) .. "_"
          end,
          expr = true,
          desc = "Debug print exp below (line)",
        },
        {
          "<localleader>pE",
          function()
            return dbg().print_exp({ output_location = "above" })
          end,
          mode = { "n", "x" },
          expr = true,
          desc = "Debug print exp above",
        },
        {
          "<localleader>pEE",
          function()
            return dbg().print_exp({ output_location = "above" }) .. "_"
          end,
          expr = true,
          desc = "Debug print exp above (line)",
        },
        {
          "<localleader>pP",
          function()
            return dbg().print_loc({ output_location = "above" })
          end,
          expr = true,
          desc = "Debug print location above",
        },
        {
          "<localleader>pp",
          function()
            return dbg().print_loc({ output_location = "below" })
          end,
          expr = true,
          desc = "Debug print location below",
        },
        {
          "<localleader>pc",
          function()
            return dbg().cleanup({ restore_view = true })
          end,
          mode = { "n", "x" },
          expr = true,
          remap = true,
          desc = "Debug print clean",
        },
      }
    end,
  },
}
