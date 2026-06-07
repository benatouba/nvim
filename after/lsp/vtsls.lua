local vue = require("lsp.vue")

local function root_dir(bufnr, on_dir)
  local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
  root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
    or vim.list_extend(root_markers, { ".git" })

  local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
  local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
  local project_root = vim.fs.root(bufnr, root_markers)

  if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
    return
  end

  if deno_root and (not project_root or #deno_root >= #project_root) then
    return
  end

  on_dir(project_root or vim.fn.getcwd())
end

return {
  cmd = { "vtsls", "--stdio" },
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
  on_new_config = function(new_config, root)
    local vue_language_server_path, fallback_tsdk = vue.resolve_paths()
    local tsdk = vue.workspace_tsdk(root) or fallback_tsdk

    new_config.settings = new_config.settings or {}
    new_config.settings.vtsls = new_config.settings.vtsls or {}
    new_config.settings.vtsls.autoUseWorkspaceTsdk = true

    if tsdk then
      new_config.settings.typescript = new_config.settings.typescript or {}
      new_config.settings.typescript.tsdk = tsdk
    end

    if vue_language_server_path then
      new_config.settings.vtsls.tsserver = new_config.settings.vtsls.tsserver or {}
      new_config.settings.vtsls.tsserver.globalPlugins = {
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
  on_attach = function(client, bufnr)
    if vim.bo[bufnr].filetype == "vue" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
}
