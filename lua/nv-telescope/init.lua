local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
require('telescope').load_extension('project')
-- Global remapping
------------------------------
-- '--color=never',
require('telescope').setup {
    defaults = {
        find_command = {'grep', '--line-number', '--column', '--ignore-case', '--color'},
        prompt_position = "bottom",
        -- prompt_prefix = " ",
        prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_defaults = {horizontal = {mirror = false}, vertical = {mirror = false}},
        file_sorter = sorters.get_fzy_sorter,
		file_ignore_patterns = { 'parser.c' },
        file_ignore_patterns = {},
        generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
        shorten_path = true,
        winblend = 0,
        width = 0.75,
        preview_cutoff = 120,
        results_height = 1,
        results_width = 0.8,
        border = {},
        borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
        color_devicons = true,
        use_less = true,
        set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                -- To disable a keymap, put [map] = false
                -- So, to not map "<C-n>", just put
                -- ["<c-x>"] = false,
                ["<esc>"] = actions.close,

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
                -- ["<C-i>"] = my_cool_custom_action,
            }
        }
    },
    extensions = {
        project = {
            display_type = "full"
        },
		fzy_native = {
		  override_generic_sorter = true,
		  override_file_sorter = true,
		},
		fzf_writer = {
		  use_highlighter = false,
		  minimum_grep_characters = 6,
		},
		frecency = {
			show_scores = true,
			show_unindexed = false,
			ignore_patterns = {"*.git/*", "*/tmp/*", "*.svn/*"},
			workspaces = {
				["conf"] = vim.fn.environ()["HOME"] .. "/.config/nvim/",
				["nvim"] = vim.fn.environ()["HOME"] .. "/.config/nvim",
				["palm_mpich"] = "/sim/palm/mpich",
				["palm_intel"] = "/sim/palm/intel",
				["salt"] = "/srv",
			},
		},
		fzf = {
		  override_generic_sorter = false, -- override the generic sorter
		  override_file_sorter = true,     -- override the file sorter
		  case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
										   -- the default case_mode is "smart_case"
		}
	}
}
require('telescope').load_extension("fzy_native")
require('telescope').load_extension("fzf_writer")
-- require('telescope').load_extension("arecibo")
require('telescope').load_extension("fzf")
require('telescope').load_extension("frecency")
require('telescope').load_extension("cheat")

local M = {}
function M.oldfiles()
  if true then require('telescope').extensions.frecency.frecency() end
  if pcall(require('telescope').load_extension, 'frecency') then
  else
    require('telescope.builtin').oldfiles { layout_strategy = 'vertical' }
  end
end

return setmetatable({}, {
  __index = function(_, k)
    reloader()

    if M[k] then
      return M[k]
    else
      return require('telescope.builtin')[k]
    end
  end
})
