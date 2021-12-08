local status_ok, dap = pcall(require, "dap")
if not status_ok then
	P("nvim-dap not okay")
	return
end

local data = {
	breakpoint = {
		text = "",
		texthl = "LspDiagnosticsSignError",
		linehl = "",
		numhl = "",
	},
	breakpoint_rejected = {
		text = "",
		texthl = "LspDiagnosticsSignHint",
		linehl = "",
		numhl = "",
	},
	stopped = {
		text = "",
		texthl = "LspDiagnosticsSignInformation",
		linehl = "DiagnosticUnderlineInfo",
		numhl = "LspDiagnosticsSignInformation",
	},
}

local mappings = {}
mappings["d"] = {
	name = "+Debug",
	b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
	c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
	C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
	d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
	g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
	i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
	o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
	O = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
	p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
	q = { "<cmd>lua require'dap'.stop()<cr>", "Quit" },
	r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
	s = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
}

local M = {}

M.config = function()
	vim.fn.sign_define("DapBreakpoint", data.breakpoint)
	vim.fn.sign_define("DapBreakpointRejected", data.breakpoint_rejected)
	vim.fn.sign_define("DapStopped", data.stopped)

	dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

	require("which-key").register(mappings, { mode = "n", prefix = "<leader>" })
end
return M
