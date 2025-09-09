local M = {}

M.config = function()
  local ref_ok, ref = pcall(require, "refactoring")
  if not ref_ok then
    vim.notify("Refactoring.nvim not okay")
    return
  end
  ref.setup()
  -- load refactoring Telescope extension
  require("telescope").load_extension("refactoring")
end
M.maps = {
  {
    "<leader>Rb",
    function()
      require("refactoring").refactor("Extract Block")
    end,
    desc = "Extract Block",
    mode = { "x", "n" },
    expr = true,
  },
  {
    "<leader>RB",
    function()
      require("refactoring").refactor("Extract Block to File")
    end,
    desc = "Extract Block to File",
    mode = { "x", "n" },
    expr = true,
  },
  {
    "<leader>Rf",
    function()
      require("refactoring").refactor("Extract Function")
    end,
    desc = "Extract Function",
    mode = { "x", "n" },
    expr = true,
  },
  {
    "<leader>RF",
    function()
      require("refactoring").refactor("Extract Function To File")
    end,
    desc = "Extract Function to File",
    mode = { "x", "n" },
    expr = true,
  },
  {
    "<leader>Ri",
    function()
      require("refactoring").refactor("Inline Variable")
    end,
    desc = "Inline Variable",
    mode = { "x", "n" },
    expr = true,
  },
  {
    "<leader>RI",
    function()
      require("refactoring").refactor("Inline Function")
    end,
    desc = "Inline Function",
    mode = { "x", "n" },
    expr = true,
  },
  {
    "<leader>Rv",
    function()
      require("refactoring").refactor("Extract Variable")
    end,
    desc = "Extract Variable",
    mode = { "x", "n" },
    expr = true,
  },
  {
    "<leader>Rt",
    function()
      require("telescope").extensions.refactoring.refactors()
    end,
    desc = "Extract to Telescope",
    mode = { "x", "n" },
    expr = true,
  },
  {
    "<leader>Rr",
    function()
      require("refactoring").select_refactor()
    end,
    desc = "Select Refactor",
    mode = { "x", "n" },
    expr = true,
  },
}

-- telescope refactoring helper
-- local function refactor(prompt_bufnr)
-- 	local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
-- 	require("telescope.actions").close(prompt_bufnr)
-- 	require("refactoring").refactor(content.value)
-- end

-- M.refactors = function()
-- 	local opts = require("telescope.themes").get_cursor() -- set personal telescope options
-- 	require("telescope.pickers").new(opts, {
-- 		prompt_title = "refactors",
-- 		finder = require("telescope.finders").new_table({
-- 			results = require("refactoring").get_refactors(),
-- 		}),
-- 		sorter = require("telescope.config").values.generic_sorter(opts),
-- 		attach_mappings = function(_, map)
-- 			map("i", "<CR>", refactor)
-- 			map("n", "<CR>", refactor)
-- 			return true
-- 		end,
-- 	}):find()
-- end
--

return M
