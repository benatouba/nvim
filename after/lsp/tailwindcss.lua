-- Complements cssls rather than replacing it: this server knows Tailwind
-- (utility completions, hover showing the generated CSS, colour swatches,
-- conflicting-class and @apply linting), while cssls is what validates plain
-- CSS properties and values. Neither covers the other's ground.

local M = {
  cmd = require("lsp.resolve").rpc("tailwindcss-language-server"),
  -- Tailwind v4 configures itself in CSS (@theme in the stylesheet) and often
  -- ships no tailwind.config.*, so root detection cannot rely on one existing.
  root_markers = {
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "postcss.config.js",
    "package.json",
    ".git",
  },
  settings = {
    tailwindCSS = {
      -- class strings also live inside tailwind-variants/cva calls, which is
      -- how @nuxt/ui components are written
      classFunctions = { "cn", "cva", "tv" },
      validate = true,
    },
  },
}

return M
