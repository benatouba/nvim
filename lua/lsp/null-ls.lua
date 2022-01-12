local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
	print("null-ls not okay")
	return
end
-- local helpers = require("null-ls.helpers")

local sources = {
	null_ls.builtins.formatting.prettier.with({
		method = null_ls.methods.FORMAT_ON_SAVE,
	}),
	null_ls.builtins.formatting.stylua,
	-- null_ls.builtins.completion.spell,
	-- null_ls.builtins.diagnostics.proselint,
	null_ls.builtins.hover.dictionary,
	null_ls.builtins.formatting.black.with({
		method = null_ls.methods.FORMAT_ON_SAVE,
		filetypes = { "python" },
	}),
	null_ls.builtins.formatting.isort,
	null_ls.builtins.diagnostics.flake8,
	-- null_ls.builtins.diagnostics.eslint,
	-- null_ls.builtins.diagnostics.pylint,
	-- null_ls.builtins.code_actions.refactoring
}

local M = {}
M.config = function()
	-- null_ls.register(markdownlint)
	null_ls.setup({
		sources = sources,
		options = {
			on_attach = function(client)
				if client.resolved_capabilities.document_formatting then
					vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
				end
			end,
		},
	})
end

return M
