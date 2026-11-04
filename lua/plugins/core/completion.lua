-- Core completion: blink.cmp and LuaSnip. Options live in lua/plugins/configs/blink.lua.
return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- tagged releases ship the prebuilt fuzzy matcher
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
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
      -- blink-native sources
      "mikavilpas/blink-ripgrep.nvim",
      "Kaiser-Yang/blink-cmp-git",
      "joelazar/blink-calc",
      "moyiz/blink-emoji.nvim",
      "disrupted/blink-cmp-conventional-commits",
      "alexandre-abrioux/blink-cmp-npm.nvim",
    },
    opts = function()
      return require("plugins.configs.blink").opts
    end,
  },
}
