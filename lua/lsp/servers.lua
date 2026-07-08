local M = {}

local function safe_config(name, cfg)
  local ok = pcall(vim.lsp.config, name, cfg)
  if not ok then
    vim.notify(string.format("Failed to configure %s", name), vim.log.levels.WARN)
  end
end

-- Load user lsp/*.lua config files and register them with vim.lsp.config().
-- This is necessary because Neovim's rtp auto-discovery merges lsp/*.lua files
-- in rtp order (last wins via vim.tbl_deep_extend("force")), which means
-- nvim-lspconfig defaults can silently override user configs.
-- vim.lsp.config() calls have the highest priority in the merge hierarchy.
local function load_user_lsp_configs()
  local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
  local handle = vim.uv.fs_scandir(lsp_dir)
  if not handle then
    return
  end
  while true do
    local name, kind = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    if kind == "file" and name:match("%.lua$") then
      local server_name = name:gsub("%.lua$", "")
      local loader, err = loadfile(lsp_dir .. "/" .. name)
      if loader then
        local ok, config = pcall(loader)
        if ok and type(config) == "table" then
          vim.lsp.config(server_name, config)
        elseif not ok then
          vim.notify(string.format("Error loading user lsp config %s: %s", name, tostring(config)), vim.log.levels.WARN)
        end
      elseif err then
        vim.notify(string.format("Failed to load user lsp config file %s: %s", name, err), vim.log.levels.WARN)
      end
    end
  end
end

M.setup = function()
  load_user_lsp_configs()

  -- Inline overrides for servers that don't have lsp/*.lua files.
  safe_config("cssmodules_ls", {
    on_init = function(client)
      client.server_capabilities.definitionProvider = true
    end,
  })
  safe_config("r_language_server", {
    on_init = function(client)
      client.server_capabilities.completionProvider = false
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  })
end

M.enable_nixos = function()
  if not O.is_nixos then
    return
  end

  -- lua_ls is auto-configured via lsp/lua_ls.lua (merged with nvim-lspconfig default).
  -- docker_language_server handles both Dockerfile and docker-compose YAML.

  vim.lsp.enable({
    "basedpyright",
    "codebook",
    "docker_language_server",
    "hls",
    "jsonls",
    "lua_ls",
    "marksman",
    "matlab_ls",
    "nil_ls",
    "nixd",
    "oxlint",
    "ruby_lsp",
    "ruff",
    "taplo",
    "texlab",
    "tinymist",
    "ts_ls",
    "ty",
    "vtsls",
    "vue_ls",
    "yamlls",
  })
end

return M
