local M = {}

M.opts = {
  lazy_load = false,
  user_default_options = {
    names_opts = {
      uppercase = true,
    },
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    AARRGGBB = true, -- 0xAARRGGBB hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = true, -- Enable all CSS *features*:
    -- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn
    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    -- Tailwind colors.  boolean|'normal'|'lsp'|'both'.  True sets to 'normal'
    tailwind = true, -- Enable tailwind colors
    tailwind_opts = { -- Options for highlighting tailwind names
      update_names = true, -- When using tailwind = 'both', update tailwind names from LSP results.  See tailwind section
    },
    -- parsers can contain values used in `user_default_options`
    sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
  },
}

return M
