local M = {}

M.config = function()
	local status_ok, noice = pcall(require, "noice")
	if not status_ok then
		vim.notify("noice not ok", vim.log.levels.ERROR)
		return
	end
	noice.setup({
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = false,
				["vim.lsp.util.stylize_markdown"] = false,
				["cmp.entry.get_documentation"] = false,
			},
			-- hover = {
			-- 	enabled = false
			-- },
			-- signature = {
			-- 	enabled = false
			-- },
		},
		-- you can enable a preset for easier configuration
		presets = {
			bottom_search = true,                                   -- use a classic bottom cmdline for search
			command_palette = false,                                -- position the cmdline and popupmenu together
			long_message_to_split = true,                           -- long messages will be sent to a split
			inc_rename = true,                                     -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = false,                                  -- add a border to hover docs and signature help
		},
		cmdline = {
			enabled = true,
			view = "cmdline"
		}
	})
end

return M
