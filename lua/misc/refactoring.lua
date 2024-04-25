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

  local xmaps = {
    ["r"] = {
      name = "+Refactor",
      b = {
        function ()
          require("refactoring").refactor("Extract Block")
        end,
        "Extract Block",
      },
      B = {
        function ()
          require("refactoring").refactor("Extract Block to File")
        end,
        "Extract Block To File",
      },
      f = {
        function ()
          require("refactoring").refactor("Extract Function")
        end,
        "Extract Function",
      },
      F = {
        function ()
          require("refactoring").refactor("Extract Function To File")
        end,
        "Extract Function to File",
      },
      i = {
        function ()
          require("refactoring").refactor("Inline Variable")
        end,
        "Inline Variable",
      },
      I = {
        function ()
          require("refactoring").refactor("Inline Function")
        end,
        "Inline Function",
      },
      v = {
        function ()
          require("refactoring").refactor("Extract Variable")
        end,
        "Extract Variable",
      },
      t = {
        function ()
          require("telescope").extensions.refactoring.refactors()
        end,
        "Extract to Telescope",
      },
      r = {
        function ()
          require("refactoring").select_refactor()
        end,
        "Select Refactor",
      },
    },
  }
  wk.register(xmaps, { expr = false, silent = true, prefix = "<leader>", mode = "x" })

  local nmaps = {
    ["r"] = {
      name = "+Refactor",
      b = {
        function ()
          require("refactoring").refactor("Extract Block")
        end,
        "Block",
      },
      f = {
        function ()
          require("refactoring").refactor("Extract Block to File")
        end,
        "Block to File",
      },
      i = {
        function ()
          require("refactoring").refactor("Inline Variable")
        end,
        "Inline variable",
      },
    },
  }
  wk.register(nmaps, { expr = false, silent = true, prefix = "<leader>", mode = "n" })
end

return M

