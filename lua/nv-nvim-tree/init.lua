vim.cmd([[
  let g:nvim_tree_width = 40 "30 by default
  let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
  let g:nvim_tree_gitignore = 1 "0 by default
  let g:nvim_tree_auto_open = 1 "0 by default, opens the tree when typing `vim $DIR` or `vim`
  let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
  let g:nvim_tree_auto_ignore_ft = [ 'startify', 'dashboard' ] "empty by default, don't auto open tree on specific filetypes.
  let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
  let g:nvim_tree_follow = 1 "0 by default, this option allows the cursor to be updated when entering a buffer
  let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
  let g:nvim_tree_hide_dotfiles = 1 "0 by default, this option hides files and folders starting with a dot `.`
  let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
  let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
  let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
  let g:nvim_tree_tab_open = 1 "0 by default, will open the tree when entering a new tab and the tree was previously open
  let g:nvim_tree_width_allow_resize  = 1 "0 by default, will not resize the tree when opening a file
  let g:nvim_tree_lsp_diagnostics = 1 "0 by default, will show lsp diagnostics in the signcolumn. See :help nvim_tree_lsp_diagnostics
]])
local tree_cb = require'nvim-tree.config'.nvim_tree_callback
    -- default mappings
    vim.g.nvim_tree_bindings = {
      { key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit") },
      { key = {"<2-RightMouse>", "<C-}>"},    cb = tree_cb("cd") },
      { key = "<C-v>",                        cb = tree_cb("vsplit") },
      { key = "<C-x>",                        cb = tree_cb("split") },
      { key = "<C-t>",                        cb = tree_cb("tabnew") },
      { key = "<",                            cb = tree_cb("prev_sibling") },
      { key = ">",                            cb = tree_cb("next_sibling") },
      { key = "P",                            cb = tree_cb("parent_node") },
      { key = "<BS>",                         cb = tree_cb("close_node") },
      { key = "<S-CR>",                       cb = tree_cb("close_node") },
      { key = "<Tab>",                        cb = tree_cb("preview") },
      { key = "K",                            cb = tree_cb("first_sibling") },
      { key = "J",                            cb = tree_cb("last_sibling") },
      { key = "I",                            cb = tree_cb("toggle_ignored") },
      { key = "H",                            cb = tree_cb("toggle_dotfiles") },
      { key = "R",                            cb = tree_cb("refresh") },
      { key = "a",                            cb = tree_cb("create") },
      { key = "d",                            cb = tree_cb("remove") },
      { key = "r",                            cb = tree_cb("rename") },
      { key = "<C->",                         cb = tree_cb("full_rename") },
      { key = "x",                            cb = tree_cb("cut") },
      { key = "c",                            cb = tree_cb("copy") },
      { key = "p",                            cb = tree_cb("paste") },
      { key = "y",                            cb = tree_cb("copy_name") },
      { key = "Y",                            cb = tree_cb("copy_path") },
      { key = "gy",                           cb = tree_cb("copy_absolute_path") },
      { key = "[c",                           cb = tree_cb("prev_git_item") },
      { key = "}c",                           cb = tree_cb("next_git_item") },
      { key = "-",                            cb = tree_cb("dir_up") },
      { key = "q",                            cb = tree_cb("close") },
      { key = "g?",                           cb = tree_cb("toggle_help") },
    }
return tree_cb
