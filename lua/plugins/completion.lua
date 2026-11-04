-- Completion: blink.cmp with its sources (options in lua/plugins/configs/blink.lua) and
-- LuaSnip for snippets (own snippets/ tree + friendly-snippets).
return {
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
        ty = { extra_info_hl = "@comment" },
        fallback = true,
      },
      fallback_highlight = "@variable",
      max_width = 60,
    },
  },
}
