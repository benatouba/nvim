local M = {
  cmd = function(dispatchers, _config)
    return vim.lsp.rpc.start({ "lua-language-server" }, dispatchers)
  end,
  filetypes = { "lua" },
  root_markers = vim.fn.has("nvim-0.11.3") == 1 and {
    { ".emmyrc.json", ".luarc.json", ".luarc.jsonc" },
    { ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" },
    { ".git" },
  } or {
    ".emmyrc.json",
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return -- Project manages its own settings via .luarc.json
      end
    end
    -- Inject Neovim runtime knowledge (only for nvim config or projects without .luarc.json)
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      workspace = {
        library = { vim.env.VIMRUNTIME },
      },
    })
  end,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        maxPreload = 10000,
        preloadFileSize = 1000,
        telemetry = { enable = false },
      },
      runtime = {
        version = "LuaJIT",
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
    },
  },
}

return M
