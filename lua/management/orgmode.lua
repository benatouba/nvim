local org_ok, org = pcall(require, "orgmode")
if not org_ok then
	P("orgmode not okay")
	return
end

local ts_ok, tsp = pcall(require, "nvim-treesitter.parsers")
if not ts_ok then
	P("treesitter not okay in orgmode.nvim")
	return
end
local parser_config = tsp.get_parser_configs()
parser_config.org = {
	install_info = {
		url = "https://github.com/milisims/tree-sitter-org",
		revision = "main",
		files = { "src/parser.c", "src/scanner.cc" },
	},
	filetype = "org",
}

require("nvim-treesitter.configs").setup({
	-- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
	highlight = {
		enable = true,
		-- disable = { "org" }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
		additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
	},
	ensure_installed = { "org" }, -- Or run :TSUpdate org
})

O.org.org_timestamp_up = "+"
O.org.org_timestamp_down = "-"
org.setup_ts_grammar()
org.setup(O.org)
