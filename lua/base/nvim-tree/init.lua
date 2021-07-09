local M = {}

M.config = function()
  local g = vim.g

  vim.o.termguicolors = true
  g.nvim_tree_width = 40 -- 30 by default
  g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' } -- empty by default
  g.nvim_tree_gitignore = 1 -- 0 by default
  g.nvim_tree_auto_open = 1 -- 0 by default, opens the tree when typing `vim $DIR` or `vim`
  g.nvim_tree_auto_close = 1 -- 0 by default, closes the tree when it's the last window
  g.nvim_tree_auto_ignore_ft = { 'startify', 'dashboard' } -- empty by default, don't auto open tree on specific filetypes.
  g.nvim_tree_quit_on_open = 1 -- 0 by default, closes the tree when you open a file
  g.nvim_tree_follow = 1 -- 0 by default, this option allows the cursor to be updated when entering a buffer
  g.nvim_tree_indent_markers = 1 -- 0 by default, this option shows indent markers when folders are open
  g.nvim_tree_hide_dotfiles = 1 -- 0 by default, this option hides files and folders starting with a dot `.`
  g.nvim_tree_git_hl = 1 -- 0 by default, will enable file highlight for git attributes (can be used without the icons).
  g.nvim_tree_highlight_opened_files = 1 -- 0 by default, will enable folder and file icon highlight for opened files/directories.
  g.nvim_tree_root_folder_modifier = ':~' -- This is the default. See :help filename-modifiers for more options
  g.nvim_tree_tab_open = 1 -- 0 by default, will open the tree when entering a new tab and the tree was previously open
  g.nvim_tree_width_allow_resize  = 1 -- 0 by default, will not resize the tree when opening a file
  g.nvim_tree_lsp_diagnostics = 1 -- 0 by default, will show lsp diagnostics in the signcolumn. See :help nvim_tree_lsp_diagnostics

    g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 1,
  }

  vim.g.nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
      unstaged = "",
      staged = "S",
      unmerged = "",
      renamed = "➜",
      deleted = "",
      untracked = "U",
      ignored = "◌",
    },
    folder = {
      default = "",
      open = "",
      empty = "",
      empty_open = "",
      symlink = "",
    },
  }

local tree_cb = require'nvim-tree.config'.nvim_tree_callback

  vim.g.nvim_tree_bindings = {
    { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
    { key = "h", cb = tree_cb "close_node" },
    { key = "v", cb = tree_cb "vsplit" },
  }
end

local view = require "nvim-tree.view"

M.toggle_tree = function()
  if view.win_open() then
    require("nvim-tree").close()
    if package.loaded["bufferline.state"] then
      require("bufferline.state").set_offset(0)
    end
  else
    if package.loaded["bufferline.state"] then
      -- require'bufferline.state'.set_offset(31, 'File Explorer')
      require("bufferline.state").set_offset(31, "")
    end
    require("nvim-tree").find_file(true)
  end
end

return M
