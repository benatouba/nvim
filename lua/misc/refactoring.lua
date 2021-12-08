local ref_ok, ref = pcall(require, "refactoring")
if not ref_ok then
	print("Refactoring.nvim not okay")
	return
end
ref.setup({})

-- telescope refactoring helper
local function refactor(prompt_bufnr)
	local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
	require("telescope.actions").close(prompt_bufnr)
	require("refactoring").refactor(content.value)
end

-- for the sake of simplicity in this example
-- you can extract this function and the helper above
-- and then require the file and call the extracted function
-- in the mappings below
M = {}
M.refactors = function()
	local opts = require("telescope.themes").get_cursor() -- set personal telescope options
	require("telescope.pickers").new(opts, {
		prompt_title = "refactors",
		finder = require("telescope.finders").new_table({
			results = require("refactoring").get_refactors(),
		}),
		sorter = require("telescope.config").values.generic_sorter(opts),
		attach_mappings = function(_, map)
			map("i", "<CR>", refactor)
			map("n", "<CR>", refactor)
			return true
		end,
	}):find()
end

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
	P("which-key not ok in refactoring.nvim")
	return
end

local mappings = {
	["r"] = {
		name = "+refactor",
		e = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>", "Extract Function" },
		f = {
			"<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>",
			"Extract Function to File",
		},
		t = { " <Esc><Cmd>lua M.refactors()<CR>", "Extract to Telescope" },
	},
}
wk.register(mappings, { expr = false, prefix = "<leader>", mode = "v" })
