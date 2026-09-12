-- Telescope options. Kept as a module because of the mapping/previewer tables.
local M = {}

M.opts = function()
  local actions = require("telescope.actions")
  local sorters = require("telescope.sorters")
  local previewers = require("telescope.previewers")
  local trouble = require("trouble.sources.telescope")
  return {
    defaults = {
      find_command = { "rg", "--hidden", "--line-number", "--column", "--smart-case", "--color" },
      prompt_prefix = " ",
      selection_caret = " ",
      entry_prefix = " ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "descending",
      layout_strategy = "horizontal",
      file_sorter = sorters.get_fuzzy_file,
      file_ignore_patterns = { "parser.c", "*.ipynb" },
      generic_sorter = sorters.get_generic_fuzzy_sorter,
      path_display = {},
      winblend = 0,
      layout_config = {
        width = 0.75,
        horizontal = { mirror = false },
        vertical = { mirror = false },
        prompt_position = "bottom",
      },
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      use_less = true,
      set_env = { ["COLORTERM"] = "truecolor" },
      file_previewer = previewers.vim_buffer_cat.new,
      grep_previewer = previewers.vim_buffer_vimgrep.new,
      qflist_previewer = previewers.vim_buffer_qflist.new,
      buffer_previewer_maker = previewers.buffer_previewer_maker,
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          ["<c-h>"] = actions.which_key,
          ["<c-t>"] = trouble.open,
          ["<CR>"] = actions.select_default + actions.center,
        },
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          ["<c-t>"] = trouble.open,
        },
      },
    },
    pickers = {
      find_files = { find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden" } },
    },
    extensions = {
      projects = {
        detection_methods = { "lsp", "pattern", ".git", "Makefile", "*.sln", "build/env.sh" },
      },
      fzf = {
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  }
end

return M
