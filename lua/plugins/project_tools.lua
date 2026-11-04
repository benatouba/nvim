-- Load the project's direnv environment. Executable resolution in lua/lsp/resolve.lua
-- and lua/util/python.lua is always available, independently of this integration.
return {
  {
    "direnv/direnv.vim",
    event = "BufReadPre",
    init = function()
      vim.g.direnv_silent_load = 1
    end,
  },
}
