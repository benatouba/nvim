-- npm i -g pyright
require'lspconfig'.pyright.setup {
    cmd = {DATA_PATH .. "/lsp_servers/pyright/node_modules/.bin/pyright-langserver", "--stdio"},
    on_attach = common_on_attach,
	 settings = {
      python = {
        analysis = {
		  typeCheckingMode = O.python.analysis.type_checking,
		  autoSearchPaths = O.python.analysis.auto_search_paths,
          useLibraryCodeForTypes = O.python.analysis.use_library_code_types
        }
      }
    }
}
