local vue = require("lsp.vue")

local function root_dir(bufnr, on_dir)
  local project_root = vue.node_root_dir(bufnr)
  if not project_root then
    return
  end

  if not vue.resolve_vtsls_cmd(project_root) then
    return
  end

  on_dir(project_root)
end

return {
  cmd = function(dispatchers, config)
    local cmd = vue.resolve_vtsls_cmd(config.root_dir) or { "vtsls", "--stdio" }
    return vim.lsp.rpc.start(cmd, dispatchers)
  end,
  init_options = {
    hostInfo = "neovim",
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  root_dir = root_dir,
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
  },
  on_attach = function(client, bufnr)
    if vim.bo[bufnr].filetype == "vue" then
      client.server_capabilities.semanticTokensProvider = nil
      client.server_capabilities.documentHighlightProvider = false
    end
  end,
  before_init = function(_, config)
    local vue_language_server_path, fallback_tsdk = vue.resolve_paths(config.root_dir)
    local tsdk = vue.workspace_tsdk(config.root_dir) or fallback_tsdk

    if tsdk then
      config.settings = config.settings or {}
      config.settings.typescript = config.settings.typescript or {}
      config.settings.typescript.tsdk = tsdk
    end

    if vue_language_server_path then
      config.settings = config.settings or {}
      config.settings.vtsls = config.settings.vtsls or {}
      config.settings.vtsls.tsserver = config.settings.vtsls.tsserver or {}
      config.settings.vtsls.tsserver.globalPlugins = {
        {
          name = "@vue/typescript-plugin",
          location = vue_language_server_path,
          languages = { "vue" },
          configNamespace = "typescript",
          enableForWorkspaceTypeScriptVersions = true,
        },
      }
    end
  end,
}
