local M = {}

M.config = function ()
  local telescope_ok, telescope = pcall(require, "telescope")
  if not telescope_ok then
    vim.notify("Telescope could not be initiated")
    return
  end
  -- vim.api.nvim_create_augroup('telescope_previewer', {})
  -- vim.api.nvim_create_autocmd('TelescopePreviewerLoaded', {
  -- 	group = 'telescope_previewer',
  -- 	pattern = '*',
  -- 	command = 'setlocal wrap',
  -- })
  vim.cmd([[
	autocmd User TelescopePreviewerLoaded setlocal wrap
	]])

  local trouble_ok, trouble = pcall(require, "trouble.sources.telescope")
  if not trouble_ok then
    vim.notify("Trouble in trouble in telescope")
    return
  end

  local actions = require("telescope.actions")
  local sorters = require("telescope.sorters")
  local previewers = require "telescope.previewers"
  telescope.setup {
    defaults = {
      find_command = { "rg", "--hidden", "--line-number", "--column", "--smart-case", "--color" },
      prompt_prefix = " ",
      selection_caret = " ",
      entry_prefix = " ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "descending",
      layout_strategy = "horizontal",
      file_sorter = sorters.get_fuzzy_file,
      file_ignore_patterns = { "parser.c", "*.ipynb" },
      generic_sorter = require "telescope.sorters".get_generic_fuzzy_sorter,
      path_display = {},
      winblend = 0,
      layout_config = {
        width = 0.75,
        -- preview_cutoff = 120,
        horizontal = { mirror = false },
        vertical = { mirror = false },
        prompt_position = "bottom",
      },
      pickers = {
        find_files = {
          find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden" }
        },
      },
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      use_less = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = previewers.vim_buffer_cat.new,
      grep_previewer = previewers.vim_buffer_vimgrep.new,
      qflist_previewer = previewers.vim_buffer_qflist.new,

      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = previewers.buffer_previewer_maker,
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          -- To disable a keymap, put [map] = false
          -- So, to not map "<C-n>", just put
          ["<c-h>"] = actions.which_key,
          ["<c-t>"] = trouble.open,

          -- ["<esc>"] = actions.close,

          -- Otherwise, just set the mapping to the function that you want it to be.
          -- ["<C-i>"] = actions.select_horizontal,

          -- Add up multiple actions
          ["<CR>"] = actions.select_default + actions.center

          -- You can perform as many actions in a row as you like
          -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
        },
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          ["<c-t>"] = trouble.open,
          -- ["<C-i>"] = my_cool_custom_action,
        }
      }
    },
    extensions = {
      projects = {
        detection_methods = { "lsp", "pattern", ".git", "Makefile", "*.sln", "build/env.sh" }
      },
      fzy_native = {
        override_generic_sorter = true,
        override_file_sorter = true,
      },
      fzf_writer = {
        use_highlighter = true,
        minimum_grep_characters = 6,
      },
      frecency = {
        show_scores = true,
        show_unindexed = false,
        ignore_patterns = { "*.git/*", "*/tmp/*", "*.svn/*" },
        workspaces = {
          ["conf"] = vim.fn.environ()["HOME"] .. "/.config/nvim/",
          ["nvim"] = vim.fn.environ()["HOME"] .. "/.config/nvim",
          ["palm_mpich"] = "/sim/palm/mpich",
          ["palm_intel"] = "/sim/palm/intel",
          ["salt"] = "/srv",
        },
      },
      fzf = {
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      }
    }
  }
  telescope.load_extension("fzf")
  local wk_ok, wk = pcall(require, "which-key")
  if not wk_ok then
    print("Which-key not okay in telescope")
  end
  local maps = {
    { "<leader>b",  "<cmd>Telescope buffers theme=dropdown<cr>", desc = "Buffers" },
    { "<leader>s",  group = "Search" },
    { "<leader>sB", "<cmd>Telescope file_browser<cr>",           desc = "Browser" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>",              desc = "Man Pages" },
    { "<leader>sN", "<cmd>Noice telescope<cr>",                  desc = "Noice Notifications" },
    { "<leader>sR", "<cmd>Telescope registers<cr>",              desc = "Registers" },
    { "<leader>sb", "<cmd>Telescope git_branches<cr>",           desc = "Branches" },
    { "<leader>se", "<cmd>EcologSnacks<cr>",                     desc = "Env" },
    { "<leader>sC", "<cmd>Telescope colorscheme<cr>",            desc = "Colorscheme" },
    { "<leader>sf", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find File" },
    { "<leader>sg", "<cmd>Telescope git_files<cr>",              desc = "Git Files" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>",                desc = "Keymaps" },
    { "<leader>sm", "<cmd>Telescope marks<cr>",                  desc = "Marks" },
    { "<leader>so", "<cmd>Telescope oldfiles<cr>",               desc = "Open Recent File" },
    { "<leader>sp", "<cmd>Telescope projects<cr>",               desc = "Projects" },
    { "<leader>sq", "<cmd>Telescope quickfix<cr>",               desc = "Quickfix List" },
    { "<leader>st", "<cmd>Telescope live_grep<cr>",              desc = "Text" },
  }
  wk.add(maps)
end

return M
