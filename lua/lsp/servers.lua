local M = {}

-- Servers to enable. Their configs come from nvim-lspconfig's lsp/*.lua defaults,
-- overridden by after/lsp/<name>.lua in this repo (native runtimepath discovery).
-- On NixOS binaries come from Nix; elsewhere Mason installs editor-owned servers.
-- Nix has a single server (nixd, for completion and options); formatting is owned
-- by Conform (nixfmt), never by a language server.
M.servers = {
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

local project_servers = { "ruff", "ty" }

M.mason_servers = function()
  return vim.tbl_filter(function(server)
    return not vim.tbl_contains(project_servers, server)
  end, M.servers)
end

M.enable = function()
  if vim.g.is_nixos then
    vim.lsp.enable(M.servers)
  else
    vim.lsp.enable(project_servers)
  end
  -- non-NixOS: Mason enables only the editor-owned subset.
end

return M
