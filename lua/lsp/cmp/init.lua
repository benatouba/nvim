local M = {}

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

M.config = function()
	require("luasnip.loaders.from_vscode").lazy_load()
	-- vim.o.completeopt = "menu,menuone"
	-- local neogen_ok, neogen = pcall(require, "neogen")
	local cmp_ok, cmp = pcall(require, "cmp")
	local snip_ok, luasnip = pcall(require, "luasnip")
	if not cmp_ok then
		P("nvim-cmp not okay")
		return
	end
	if not snip_ok then
		P("luasnip not ok")
	end
	cmp.setup({
		completion = {
			autocomplete = true,
		},
		view = {
			entries = { name = "native" },
		},
		formatting = {
			format = function(entry, vim_item)
				-- if entry.source.name == "copilot" then
				-- 	vim_item.kind = "[]"
				-- 	vim_item.kind_hl_group = "CmpItemKindCopilot"
				-- 	return vim_item
				-- end
				return require("lspkind").cmp_format({
					mode = "symbol",
					maxwidth = 50,
				})(entry, vim_item)
			end,
			fields = { "menu", "abbr", "kind" },
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		sorting = {
			-- priority_weight = 2,
			comparators = {
				-- require("copilot_cmp.comparators").prioritize,
				-- require("copilot_cmp.comparators").score,
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				require("cmp-under-comparator").under,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},
		mapping = {
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			-- ["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-u>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<C-h>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}),
			["<C-n>"] = cmp.mapping.select_next_item(select_opts),
			["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
			["<C-f>"] = cmp.mapping(function(fallback)
				if luasnip.jumpable(1) then
					luasnip.jump(1)
				else
					fallback()
				end
			end, { "i", "s" }),
			["<C-b>"] = cmp.mapping(function(fallback)
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		},
		-- --                 ﬘    m    

		sources = {
			-- { name = "copilot", group_index = 2 },
			{ name = "nvim_lsp", keyword_length = 1 },
			{ name = "nvim_lsp_document_symbol", keyword_length = 4 },
			{ name = "nvim_lsp_signature_help", keyword_length = 2 },
			{ name = "luasnip", keyword_length = 2 },
			{ name = "treesitter", keyword_length = 3 },
			{ name = "nvim_lua", keyword_length = 3 },
			{ name = "path", keyword_length = 2 },
			-- { name = "cmp_git", },
			-- { name = "tmux" },
			-- { name = "orgmode" },
			-- { name = 'zsh', },
			{ name = "calc" },
			{ name = "emoji" },
			-- { name = "tags" },
			-- { name = "look", },
			-- { name = "vim-dadbod-completion" },
			{ name = "buffer", keyword_length = 5 },
		},
	})

	-- vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg = "#6CC644"})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		window = {
			completion = cmp.config.window.bordered(),
			-- documentation = cmp.config.window.bordered(),
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
			-- completion = cmp.config.window.bordered(),
			-- documentation = cmp.config.window.bordered(),
		},
		sources = {
			{ name = "buffer" },
			-- { name = "nvim_lsp_document_symbol" },
		},
	})

	-- require("luasnip/loaders/from_vscode").lazy_load({paths={vim.fn.stdpath('config') .. "/snippets"}})

	local cmp_git_ok, _ = pcall(require, "cmp_git")
	if not cmp_git_ok then
		P("cmp_git not okay")
		return
	end
	cmp.setup.filetype("gitcommit", {
		sources = cmp.config.sources({
			{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
		}, {
			{ name = "buffer" },
		}),
		github = {
			issues = {
				filter = "all", -- assigned, created, mentioned, subscribed, all, repos
				limit = 100,
				state = "open", -- open, closed, all
			},
			mentions = {
				limit = 100,
			},
		},
		gitlab = {
			issues = {
				limit = 100,
				state = "opened", -- opened, closed, all
			},
			mentions = {
				limit = 100,
			},
		},
	})

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
	vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded'}
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'rounded'}
)
end

return M
