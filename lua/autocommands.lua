AddAutocommands({
	_general_settings = {
		{ "TextYankPost", "*", "lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 40})" },
		{ "BufWinEnter", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
		{ "BufRead", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
		{ "BufWinEnter,BufRead,BufNewFile", "*", "tnoremap <silent> <esc> <c-\\><c-n>" },
		{ "BufWinEnter,BufRead,BufNewFile", "*_p3d*", "setfiletype fortran" },
		{ "BufWinEnter,BufRead,BufNewFile", "*.pro", "setfiletype idlang" },
		{ "BufWinEnter,BufRead,BufNewFile", "*.bash*", "setfiletype bash" },
		{ "BufWinEnter,BufRead,BufNewFile", "*.R", "setfiletype r" },
		{ "BufWinEnter,BufRead,BufNewFile", "*.r", "setfiletype r" },
		{ "BufWinEnter,BufRead,BufNewFile", "*.Rmd", "setfiletype rmd" },
		{ "BufWinEnter,BufRead,BufNewFile", "*.rmd", "setfiletype rmd" },
		{ "BufWinEnter,BufRead,BufNewFile", "*.ipynb", "setfiletype ipynb" },
		{ "BufWinEnter,BufRead,BufNewFile", "w*_namelist*", "setfiletype fortran" },
		{ "BufWinEnter,BufRead,BufNewFile", "*swa*.conf*", "setfiletype i3config" },
		-- { "BufWritePost", "plugins.lua", "lua R('plugins')" },
		-- { "BufWritePost", "~/.config/nvim/init.lua", "lua require('functions').reload_config()" },
		{ "BufWritePre", "*", ":%s/\\s\\+$//e" },
		{ "BufNewFile", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
		-- { "VimLeavePre", "*", "set title set titleold=" },
		{ "BufWinEnter,BufRead,BufNewFile", "*.sls", "setf sls" },
		{ "BufWritePost", "*.py", "lua Pyflyby()" },
	},
	_markdown = { { "FileType", "markdown", "setlocal wrap" } },
	_buffer_bindings = {
		{ "FileType", "dashboard", "nnoremap <silent> <buffer> q :q<CR>" },
		{ "FileType", "lspinfo", "nnoremap <silent> <buffer> q :q<CR>" },
		{ "FileType", "floaterm", "nnoremap <silent> <buffer> q :q<CR>" },
		{ "FileType", "fugitive", "nnoremap <silent> <buffer> q :q<CR>" },
		{ "FileType", "qf", "nnoremap <silent> <buffer> q :q<CR>" },
		{ "FileType", "checkhealth,help,lsp-installer,qf,fugitive,lspinfo,dashboard", "nnoremap <silent> <buffer> q :q<CR>" },
		{ "FileType", "checkhealth,help,lsp-installer,qf,fugitive,lspinfo,dashboard", "nnoremap <silent> <buffer> <esc> :q<CR>" },
		-- {'buftype', 'nofile', 'nnoremap <silent> <buffer> q :q<CR>'},
	},
	firenvim = {
		{"BufEnter", "*ipynb_er-DIV*.txt", "set filetype=python"},
		{"BufEnter", "*ipynb_ontainer-DIV*.txt", "set filetype=markdown"}
		},
	-- jupyter = {
	-- 	{"FileType", "ipynb", "\\call jobstart('jupyter qtconsole --JupyterWidget.include_other_output=True')"}
	-- }
	soga = {
		{"BufWritePost", "manim*.py", "<cmd>!manim -pqg % RegressionTutorial<CR>"}
	}
})
