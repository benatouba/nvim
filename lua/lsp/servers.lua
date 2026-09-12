local M = {}

-- Servers to enable. Their configs come from nvim-lspconfig's lsp/*.lua defaults,
-- overridden by after/lsp/<name>.lua in this repo (native runtimepath discovery).
-- On NixOS the binaries come from Nix; elsewhere mason-lspconfig installs this list.
M.servers = {
  "basedpyright",
  "codebook",
  "cssls",
  "docker_language_server",
  "hls",
  "html",
  "jsonls",
  "kotlin_language_server",
  "lemminx",
  "lua_ls",
  "marksman",
  "matlab_ls",
  "nil_ls",
  "nixd",
  "oxlint",
  "ruby_lsp",
  "ruff",
  -- "tailwindcss",
  "taplo",
  "texlab",
  "tinymist",
  -- "ts_ls",
  "ty",
  "vtsls",
  "vue_ls",
  "yamlls",
}

M.enable = function()
  if vim.g.is_nixos then
    vim.lsp.enable(M.servers)
  end
  -- non-NixOS: mason-lspconfig enables everything it installs (automatic_enable)
end

return M
