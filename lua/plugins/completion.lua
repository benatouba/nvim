-- Completion: blink.cmp with its sources. Options live in lua/plugins/configs/blink.lua.
return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- tagged releases ship the prebuilt fuzzy matcher
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
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
