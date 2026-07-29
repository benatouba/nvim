-- Complements cssls rather than replacing it: this server knows Tailwind
-- (utility completions, hover showing the generated CSS, colour swatches,
-- conflicting-class and @apply linting), while cssls is what validates plain
-- CSS properties and values. Neither covers the other's ground.

local function resolve_cmd(root_dir, bin)
  while root_dir and root_dir ~= "/" do
    local local_cmd = root_dir .. "/node_modules/.bin/" .. bin
    if vim.fn.executable(local_cmd) == 1 then
      return { local_cmd, "--stdio" }
    end
    local devenv_cmd = root_dir .. "/.devenv/profile/bin/" .. bin
    if vim.fn.executable(devenv_cmd) == 1 then
      return { devenv_cmd, "--stdio" }
    end
    root_dir = vim.fn.fnamemodify(root_dir, ":h")
  end
  if vim.fn.executable(bin) == 1 then
    return { bin, "--stdio" }
  end
end

local M = {
  cmd = function(dispatchers, config)
    local resolved = resolve_cmd((config or {}).root_dir, "tailwindcss-language-server")
      or { "tailwindcss-language-server", "--stdio" }
    return vim.lsp.rpc.start(resolved, dispatchers)
  end,
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
