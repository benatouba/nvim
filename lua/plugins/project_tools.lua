-- Code owned by the opened project: direnv here, and project-local executables through
-- lua/lsp/resolve.lua and lua/util/python.lua, which check for this group.
return {
  {
    "direnv/direnv.vim",
    event = "BufReadPre",
    init = function()
      vim.g.direnv_silent_load = 1
    end,
  },
}
