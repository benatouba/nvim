local M = {}

M.config = function()
	local isOk, hlslens = pcall(require, "hlslens")
	if not isOk then
		vim.notify("hlslens not okay")
		return
	end
	hlslens.setup({
		calm_down = true,
	})
	local function map(mode, lhs, rhs, opts)
		local options = { remap = false, silent = true }
		if opts then
			options = vim.tbl_extend("force", options, opts)
		end
		vim.keymap.set(mode, lhs, rhs, options)
	end

	map("n", "n", "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>", {})
	map("n", "N", "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>", {})
	map("n", "g*", "g*<Cmd>lua require('hlslens').start()<CR>", {})
	map("n", "g#", "g#<Cmd>lua require('hlslens').start()<CR>", {})

	map("n", "*", "", {
		callback = function()
			vim.fn.execute("normal! *N")
			hlslens.start()
		end,
	})

	map("n", "#", "", {
		callback = function()
			vim.fn.execute("normal! #N")
			hlslens.start()
		end,
	})
end

return M