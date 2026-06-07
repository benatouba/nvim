local M = {}

M.setup = function()
  -- Server-specific native configs live in lsp/ and after/lsp/ runtime files.
  -- Keep this hook for future global vim.lsp.config() tweaks that must outrank
  -- runtime configs.
end

M.enable_nixos = function()
  if not O.is_nixos then
    return
  end

  -- Restrict filetypes before enabling (vim.lsp.config has highest priority).
  vim.lsp.config("lua_ls", { filetypes = { "lua" } })

  -- Ltex nervt
  -- vim.lsp.config("ltex_plus", {
  --   filetypes = { "bib", "tex", "latex", "markdown", "quarto", "rmd", "rst", "text", "typst" },
  -- })

  vim.lsp.enable({
    "hls",
    "marksman",
    "nil_ls",
    "nixd",
    "lua_ls",
    "basedpyright",
    "ruff",
    "ty",
    "jsonls",
    "ltex_plus",
    "matlab_ls",
    "oxlint",
    "ruby_lsp",
    "taplo",
    "texlab",
    "tinymist",
    "vtsls",
    "vue_ls",
    "yamlls",
  })
end

return M
