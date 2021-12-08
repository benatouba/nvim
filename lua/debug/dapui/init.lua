local ok, dapui = pcall(require, "dapui")
if not ok then
	P("nvim-dap-ui not okay")
	return
end

local M = {}
local mappings = {}
mappings["du"] = {
	name = "+UI",
	["o"] = { "<cmd>lua require('dapui').open()<cr>", "Open UI" },
	["c"] = { "<cmd>lua require('dapui').close()<cr>", "Close UI" },
	["t"] = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle UI" },
	["f"] = { "<cmd>lua require('dapui').float_element()<cr>", "Open Floating Info" },
	["e"] = { "<cmd>lua require('dapui').eval()<cr>", "Evaluate Expression" },
}
M.config = function()
	dapui.setup()
	require("which-key").register(mappings, { mode = "n", prefix = "<leader>" })
end

return M
