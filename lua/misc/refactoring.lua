local M = {}

M.config = function ()
  local ref_ok, ref = pcall(require, "refactoring")
  if not ref_ok then
    vim.notify("Refactoring.nvim not okay")
    return
  end
  ref.setup()
  -- load refactoring Telescope extension
  require("telescope").load_extension("refactoring")
end

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
M.maps = function ()
  local wk_ok, wk = pcall(require, "which-key")
  if not wk_ok then
    vim.notify("which-key not ok in refactoring.nvim")
    return
  end

  wk.add({
    {
      mode = { "x" },
      { "<leader>r", group = "+Refactor" },
      { "<leader>rb", function () require("refactoring").refactor("Extract Block") end, desc = "Extract Block" },
      { "<leader>rB", function () require("refactoring").refactor("Extract Block to File") end, desc = "Extract Block to File" },
      { "<leader>rf", function () require("refactoring").refactor("Extract Function") end, desc = "Extract Function" },
      { "<leader>rF", function () require("refactoring").refactor("Extract Function To File") end, desc = "Extract Function to File" },
      { "<leader>ri", function () require("refactoring").refactor("Inline Variable") end, desc = "Inline Variable" },
      { "<leader>rI", function () require("refactoring").refactor("Inline Function") end, desc = "Inline Function" },
      { "<leader>rv", function () require("refactoring").refactor("Extract Variable") end, desc = "Extract Variable" },
      { "<leader>rt", function () require("telescope").extensions.refactoring.refactors() end, desc = "Extract to Telescope" },
      { "<leader>rr", function () require("refactoring").select_refactor() end, desc = "Select Refactor" },
    },
    { "<leader>r", group = "+Refactor" },
    { "<leader>rb", function () require("refactoring").refactor("Extract Block") end, desc = "Extract Block" },
    { "<leader>rf", function () require("refactoring").refactor("Extract Function") end, desc = "Extract Function" },
    { "<leader>ri", function () require("refactoring").refactor("Inline Variable") end, desc = "Inline Variable" },
  })
end

return M
