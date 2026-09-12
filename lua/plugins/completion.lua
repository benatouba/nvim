-- Completion: blink.cmp with its sources (options in lua/plugins/configs/blink.lua) and
-- LuaSnip for snippets (own snippets/ tree + friendly-snippets).
return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- tagged releases ship the prebuilt fuzzy matcher
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        -- jsregexp speeds up transformations; optional, and the make step is skipped on Nix
        build = (not vim.g.is_nixos) and "make install_jsregexp" or nil,
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = function()
          local types = require("luasnip.util.types")
          return {
            enable_autosnippets = true,
            history = true,
            ext_opts = {
              [types.choiceNode] = { active = { virt_text = { { "<-", "Error" } } } },
            },
          }
        end,
        config = function(_, opts)
          require("luasnip").setup(opts)
          local snippets = vim.fn.stdpath("config") .. "/snippets"
          -- friendly-snippets (from the runtimepath) plus the VSCode-format files listed in
          -- snippets/package.json, and the hand-written snippets/<filetype>.lua files
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippets } })
          require("luasnip.loaders.from_lua").lazy_load({ paths = { snippets } })
        end,
      },
      "onsails/lspkind.nvim",
      { "xzbdmw/colorful-menu.nvim", lazy = true },
      -- nvim-cmp sources bridged through blink.compat (sonicpi)
      { "saghen/blink.compat", version = "*", lazy = true, opts = { impersonate_nvim_cmp = false } },
      -- blink-native sources
      "mikavilpas/blink-ripgrep.nvim",
      "Kaiser-Yang/blink-cmp-git",
      "joelazar/blink-calc",
      "moyiz/blink-emoji.nvim",
      "disrupted/blink-cmp-conventional-commits",
      "mayromr/blink-cmp-dap",
      "alexandre-abrioux/blink-cmp-npm.nvim",
    },
    opts = function()
      return require("plugins.configs.blink").opts
    end,
  },
  {
    "xzbdmw/colorful-menu.nvim",
    lazy = true,
    opts = {
      ls = {
        lua_ls = { arguments_hl = "@comment" },
        gopls = { align_type_to_right = true, add_colon_before_type = false },
        ts_ls = { extra_info_hl = "@comment" },
        vtsls = { extra_info_hl = "@comment" },
        ["rust-analyzer"] = { extra_info_hl = "@comment", align_type_to_right = true },
        clangd = { extra_info_hl = "@comment", align_type_to_right = true, import_dot_hl = "@comment" },
        zls = { align_type_to_right = true },
        roslyn = { extra_info_hl = "@comment" },
        basedpyright = { extra_info_hl = "@comment" },
        fallback = true,
      },
      fallback_highlight = "@variable",
      max_width = 60,
    },
  },
}
