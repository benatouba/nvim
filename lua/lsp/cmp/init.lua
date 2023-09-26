local M = {}

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

M.config = function()
	-- require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip").filetype_extend("vue", { "html", "javascript", "nuxt_html", "nuxt_js_ts", "vue", })
	require("luasnip").filetype_extend("python", { "django", "django/django_rest" })

	vim.opt.completeopt = { "menu", "menuone", "noselect" }
	-- local neogen_ok, neogen = pcall(require, "neogen")
	local cmp_ok, cmp = pcall(require, "cmp")
	local snip_ok, luasnip = pcall(require, "luasnip")
	local lspkind_ok, lspkind = pcall(require, "lspkind")
	local types = require("cmp.types")
	local str = require("cmp.utils.str")
	if not cmp_ok then
		vim.notify("nvim-cmp not okay")
		return
	end
	if not lspkind_ok then
		vim.notify("lspkind not ok")
	end
	if not snip_ok then
		vim.notify("luasnip not ok")
	end

	luasnip.config.setup({
		region_check_events = "CursorMoved",
		delete_check_events = "TextChanged",
	})

	cmp.setup({
		enabled = function()
			-- enable autocompletion in nvim-dap
			if require("cmp_dap").is_dap_buffer() then
				return true
			end

			-- disbable completion in telescope buffers
			if vim.fn.buftype == "prompt" then
				return false
			end
			-- disable completion in comments
			local context = require("cmp.config.context")
			-- keep command mode completion enabled when cursor is in a comment
			if vim.api.nvim_get_mode().mode == "c" then
				return true
			else
				return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
			end
		end,
		-- view = {
		-- 	entries = { name = "native" },
		-- },
		formatting = {
			fields = {
				cmp.ItemField.Kind,
				cmp.ItemField.Abbr,
				cmp.ItemField.Menu,
			},
			format = lspkind.cmp_format({
				with_text = false,
				before = function(entry, vim_item)
					if entry.source.name == "copilot" then
						vim_item.kind = "[] Copilot"
						vim_item.kind_hl_group = "CmpItemKindCopilot"
						return vim_item
					end
					-- Get the full snippet (and only keep first line)
					local word = entry:get_insert_text()
					if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
						word = vim.lsp.util.parse_snippet(word)
					end
					word = str.oneline(word)

					-- concatenates the string
					local max = 50
					if string.len(word) >= max then
						local before = string.sub(word, 1, math.floor((max - 3) / 2))
						word = before .. "..."
					end

					if
						entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
						and string.sub(vim_item.abbr, -1, -1) == "~"
					then
						word = word .. "~"
					end
					vim_item.abbr = word

					return vim_item
				end,
			}),
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		window = {
			completion = cmp.config.window.bordered({
				autocomplete = true,
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
				scrollbar = "║",
			}),
			documentation = cmp.config.window.bordered({
				autocomplete = true,
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
				scrollbar = "║",
			}),
		},
		sorting = {
			-- priority_weight = 2,
			comparators = {
				-- require("copilot_cmp").comparators.prioritize,
				-- require("copilot_cmp.comparators").score,
				require("cmp-under-comparator").under,
				-- cmp.config.compare.exact,
				-- cmp.config.compare.kind,
				-- cmp.config.compare.offset,
				-- cmp.config.compare.score,
				-- cmp.config.compare.sort_text,
				-- cmp.config.compare.length,
				-- cmp.config.compare.order,
			},
		},
		mapping = cmp.mapping.preset.insert {
			["<C-d>"] = function()
				if not require("noice.lsp").scroll(4) then
					cmp.mapping.scroll_docs(4)
				end
			end,
			["<C-u>"] = function()
				if not require("noice.lsp").scroll(-4) then
					cmp.mapping.scroll_docs(-4)
				end
			end,
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<C-h>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({
				-- behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<Tab>"] = cmp.mapping(function(fallback)
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif cmp.visible() then
					cmp.select_next_item()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if luasnip.expand_or_jumpable() then
					luasnip.jump(-1)
				elseif cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		},
		-- --                 ﬘    m    

		sources = {
			{ name = "copilot" },
			-- { name = "nvim_lsp_signature_help" },
			{ name = "path" },
			{ name = "luasnip",                max_item_count = 4 },
			{ name = "nvim_lsp",               keyword_length = 0 },
			{ name = "treesitter" },
			{ name = "calc" },
			{ name = "emoji" },
			{ name = "nvim_lua" },
			{ name = "tags" },
			{ name = "tmux" },
			{ name = 'zsh', },
			-- { name = "look", },
			-- { name = "vim-dadbod-completion" },
			{ name = "buffer" },
		},
	})

	cmp.setup.filetype({ "org", "orgagenda" }, {
		sources = {
			{ name = "orgmode",   priority = 100 },
			{ name = "luasnip" },
			{ name = "nvim_lsp" },
			{ name = "treesitter" },
			{ name = "calc" },
			{ name = "emoji" },
		}
	})

	cmp.setup.filetype({ "norg" }, {
		sources = {
			{ name = "neorg",     priority = 100 },
			{ name = "luasnip" },
			{ name = "nvim_lsp" },
			{ name = "treesitter" },
			{ name = "calc" },
			{ name = "emoji" },
		},
	})
	cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
		sources = {
			{ name = "dap" },
		},
	})
	-- vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg = "#6CC644"})
	cmp.setup.filetype({ "ipynb", "jupyter_python", "jupynium" }, {
		sources = {
			-- { name = "jupynium",   priority = 1000 },
			{ name = "luasnip" },
			{ name = "nvim_lsp" },
			-- { name = "nvim_lsp_signature_help" },
			{ name = "treesitter", keyword_length = 3 },
			{ name = "calc" },
			{ name = "emoji" },
			{ name = "tags",       keyword_length = 5, max_item_count = 5 },
			{ name = "buffer",     keyword_length = 5, max_item_count = 5 },
		},
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		window = {
			completion = cmp.config.window.bordered({ autocomplete = true }),
		},
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})

	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		window = {
			completion = cmp.config.window.bordered({ autocomplete = true }),
		},
		sources = {
			{ name = "nvim_lsp_document_symbol" },
			{ name = "buffer" },
		},
	})

	-- require("luasnip/loaders/from_vscode").lazy_load({paths={vim.fn.stdpath('config') .. "/snippets"}})

	cmp.setup.filetype("gitcommit", {
		sources = {
			{ name = "git" },
		},
	})

	local cmp_git_ok, cmp_git = pcall(require, "cmp_git")
	if not cmp_git_ok then
		vim.notify("cmp_git not okay")
		return
	end
	cmp_git.setup()
	-- cmp.config.sources({
	-- 			{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	-- 		}, {
	-- 			{ name = "buffer" },
	-- 		}),
	-- 		github = {
	-- 			issues = {
	-- 				filter = "all", -- assigned, created, mentioned, subscribed, all, repos
	-- 				limit = 100,
	-- 				state = "open", -- open, closed, all
	-- 			},
	-- 			mentions = {
	-- 				limit = 100,
	-- 			},
	-- 		},
	-- 		gitlab = {
	-- 			issues = {
	-- 				limit = 100,
	-- 				state = "opened", -- opened, closed, all
	-- 			},
	-- 			mentions = {
	-- 				limit = 100,
	-- 			},
	-- 		},
	--
	local sign = function(opts)
		vim.fn.sign_define(opts.name, {
			texthl = opts.name,
			text = opts.text,
			numhl = "",
		})
	end

	sign({ name = "DiagnosticSignError", text = "✘" })
	sign({ name = "DiagnosticSignWarn", text = "▲" })
	sign({ name = "DiagnosticSignHint", text = "⚑" })
	sign({ name = "DiagnosticSignInfo", text = "" })

	_ = vim.cmd([[
	  augroup DadbodSql
		au!
		autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
	  augroup END
	]])

	_ = vim.cmd([[
	  augroup CmpZsh
		au!
		autocmd Filetype zsh lua require'cmp'.setup.buffer { sources = { { name = "zsh" }, } }
	  augroup END
	]])
	-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

	-- vim.lsp.handlers["textDocument/signatureHelp"] =
	-- 		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
	-- gray
	-- vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
	-- -- blue
	-- vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
	-- vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
	-- -- light blue
	-- vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
	-- vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
	-- vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
	-- -- pink
	-- vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
	-- vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
	-- -- front
	-- vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
	-- vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
	-- vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })
	vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
		if not require("noice.lsp").scroll(4) then
			return "<c-f>"
		end
	end, { silent = true, expr = true })

	vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
		if not require("noice.lsp").scroll(-4) then
			return "<c-b>"
		end
	end, { silent = true, expr = true })
end

return M