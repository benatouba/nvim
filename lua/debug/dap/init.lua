local status_ok, dap = pcall(require, "dap")
if not status_ok then
	vim.notify("nvim-dap not okay")
	return
end

local data = {
	breakpoint = {
		text = "",
		texthl = "LspDiagnosticsSignError",
		linehl = "",
		numhl = "",
		priority = 200,
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
	B = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('BP Condition: '))<cr>", "Conditional Breakpoint" },
	c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
	C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
	d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
	g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
	i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
	l = {
		"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
		"Log Point Message",
	},
	o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
	O = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
	p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
	q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
	r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
	S = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
	s = {
		name = "search",
		b = { "<cmd>lua require'telescope'.extensions.dap.list_breakpoints{}<cr>", "Breakpoints" },
		c = { "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>", "Commands" },
		C = { "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>", "Configurations" },
		f = { "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>", "frames" },
		v = { "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>", "Variables" },
	},
	x = { "<cmd>lua require'dap'.clear_breakpoints()<cr>", "Toggle Repl" },
}

local M = {}

M.config = function()
	vim.fn.sign_define("DapBreakpoint", data.breakpoint)
	vim.fn.sign_define("DapBreakpointRejected", data.breakpoint_rejected)
	vim.fn.sign_define("DapStopped", data.stopped)

	dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
	require("nvim-dap-virtual-text").setup({
			virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
			all_frames = true,
		})
	require("which-key").register(mappings, { mode = "n", prefix = "<leader>" })

	dap.adapters.chrome = {
		type = "executable",
		command = "node",
		args = { DATA_PATH .. "/mason/packages/chrome-debug-adapter/src/chromeDebug.ts" },
	}
	dap.adapters.node2 = {
		type = "executable",
		command = "node",
		args = { DATA_PATH .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
	}

	local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
	dap.adapters.python = {
		type = "executable",
		command = mason_debugpy,
		args = { "-m", "debugpy.adapter" },
		cwd = vim.fn.getcwd(),
	}

	dap.configurations.python = {
		{
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "All Code",
			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

			program = "${file}", -- This configuration will launch the current file if used.
			justMyCode = false,
			pythonPath = function()
				-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
				-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
				-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
				local cwd = vim.fn.getcwd()
				local venv = Get_python_venv()
				if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
					return venv .. "/bin/python"
				elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
					return cwd .. "/venv/bin/python"
				elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				else
					return "python"
				end
			end,
			cwd = vim.fn.getcwd(),
		},
	}

	dap.configurations.javascript = {
		{
			type = "chrome",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}",
		},
	}

	dap.configurations.typescript = {
		{
			type = "chrome",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}",
		},
	}

	dap.configurations.vue = {
		{
			type = "chrome",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}",
		},
	}
	dap.configurations.vue = {
		{
			name = "Launch",
			type = "node2",
			request = "launch",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
		},
		{
			name = "Attach to process",
			type = "node2",
			request = "attach",
			processId = require("dap.utils").pick_process,
		},
	}
end
return M