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
    vim.g.nvim_tree_bindings = {
      ["u"] = ":lua require'some_module'.some_function()<cr>",

      -- default mappings
      ["<CR>"]           = tree_cb("edit"),
      ["o"]              = tree_cb("edit"),
      ["<2-LeftMouse>"]  = tree_cb("edit"),
      ["<2-RightMouse>"] = tree_cb("cd"),
      ["<C-]>"]          = tree_cb("cd"),
      ["<C-v>"]          = tree_cb("vsplit"),
      ["<C-x>"]          = tree_cb("split"),
      ["<C-t>"]          = tree_cb("tabnew"),
      ["<"]              = tree_cb("prev_sibling"),
      [">"]              = tree_cb("next_sibling"),
      ["<BS>"]           = tree_cb("close_node"),
      ["<S-CR>"]         = tree_cb("close_node"),
      ["<Tab>"]          = tree_cb("preview"),
      ["I"]              = tree_cb("toggle_ignored"),
      ["H"]              = tree_cb("toggle_dotfiles"),
      ["R"]              = tree_cb("refresh"),
      ["a"]              = tree_cb("create"),
      ["d"]              = tree_cb("remove"),
      ["r"]              = tree_cb("rename"),
      ["<C-r>"]          = tree_cb("full_rename"),
      ["x"]              = tree_cb("cut"),
      ["c"]              = tree_cb("copy"),
      ["p"]              = tree_cb("paste"),
      ["y"]              = tree_cb("copy_name"),
      ["Y"]              = tree_cb("copy_path"),
      ["gy"]             = tree_cb("copy_absolute_path"),
      ["[c"]             = tree_cb("prev_git_item"),
      ["]c"]             = tree_cb("next_git_item"),
      ["-"]              = tree_cb("dir_up"),
      ["q"]              = tree_cb("close"),
    }
