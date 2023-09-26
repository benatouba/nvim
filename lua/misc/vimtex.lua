local M = {}

M.config = function()
	vim.g.vimtex_view_method = 'zathura'
	vim.g.vimtex_quickfix_open_on_warning = 0
	-- vim.g.vimtex_compiler_latexmk_engines = { _ = '-pdflatex' }
	-- vim.g.tex_comment_nospell = 1
	-- vim.g.vimtex_compiler_progname = 'nvr'
	-- vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]
	-- vim.g.vimtex_view_general_options_latexmk = '--unique'
	local augroup = vim.api.nvim_create_augroup("VimtexGroup", { clear = true })
	vim.api.nvim_create_autocmd("User", {
		pattern = "VimtexEventInitPost",
		group = augroup,
		command = "VimtexCompile",
	})
end

return M