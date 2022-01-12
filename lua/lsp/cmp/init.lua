local M = {}

local check_back_space = function()
	local col = vim.fn.col(".") - 1
	if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
		return true
	else
		return false
	end
end

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.config = function()
	local neogen_ok, neogen = pcall(require, "neogen")
	local cmp_ok, cmp = pcall(require, "cmp")
	local snip_ok, snip = pcall(require, "luasnip")
	if not cmp_ok then
		print("nvim-cmp not okay")
		return
	end
	if not snip_ok then
		print("luasnip not ok")
	end
	cmp.setup({
		completion = {
			completeopt = "menu,noselect",
			-- autocomplete = false,
		},
		snippet = {
			expand = function(args)
				snip.lsp_expand(args.body)
			end,
		},
		formatting = {
			format = require("lspkind").cmp_format({
				with_text = false,
				maxwidth = 50,
				menu = {
					buffer = "[Buf]",
					nvim_lsp = "[LSP]",
					luasnip = "[Snip]",
					nvim_lua = "[Lua]",
					latex_symbols = "[Latex]",
					tmux = "[tmux]",
					cmp_git = "[Git]",
					orgmode = "[Org]",
					zsh = "[Zsh]",
					path = "[Path]",
					calc = "[Calc]",
					emoji = "[Emoji]",
					tags = "[Tag]",
					look = "[Look]",
					vim_dadbod_completion = "[DB]",
				},
			}),
		},
		experimental = {
			-- I like the new menu better! Nice work hrsh7th
			native_menu = false,

			-- Let's play with this for a day or two
			ghost_text = false,
		},
		-- preselect = false,
		-- documentation = {
		-- },
		sorting = {
			priority_weight = 2.,
			comparators = {
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
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-u>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.close(),
			["<C-h>"] = cmp.mapping.close(),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}),
			["<Tab>"] = cmp.mapping(function(fallback)
				if snip.expand_or_jumpable() then
					vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
				elseif vim.fn.pumvisible() == 1 then
					vim.fn.feedkeys(t("<C-n>"), "n")
				elseif check_back_space() then
					vim.fn.feedkeys(t("<Tab>"), "n")
				elseif neogen.jumpable() and neogen_ok then
					vim.fn.feedkeys(t("<cmd>lua require('neogen').jump_next()<CR>"), "")
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if snip.jumpable(-1) then
					vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
				elseif vim.fn.pumvisible() == 1 then
					vim.fn.feedkeys(t("<up>"), "n")
				elseif neogen.jumpable() and neogen_ok then
					vim.fn.feedkeys(t("<cmd>lua require('neogen').jump_prev()<CR>"), "")
				else
					fallback()
				end
			end, { "i", "s" }),
		},
		-- --                 ﬘    m    

		sources = {
			{ name = "nvim_lsp", max_item_count = 20 },
			{ name = "nvim_lsp_document_symbol", max_item_count = 10},
			{ name = 'treesitter', max_item_count = 10, keyword_length = 3},
			{ name = "nvim_lua", max_item_count = 10 },
			{ name = "path" },
			{ name = "cmp_git", max_item_count = 10 },
			{ name = "tmux", max_item_count = 10 },
			{ name = "orgmode" },
			{ name = "luasnip", max_item_count = 10 },
			-- { name = 'zsh', max_item_count = 10  },
			{ name = "calc", max_item_count = 10 },
			{ name = "emoji", max_item_count = 10 },
			{ name = "tags", max_item_count = 10 },
			{ name = "look", keyword_length = 4, max_item_count = 10 },
			{ name = "vim-dadbod-completion", max_item_count = 10 },
			{ name = "buffer", keyword_length = 6, max_item_count = 10 },
		},
	})

	--     local source = {
	--         path = {kind = "   (Path)"},
	--         buffer = {kind = "   (Buffer)"},
	--         calc = {kind = "   (Calc)"},
	--         -- vsnip = {kind = "   (Snippet)"},
	--         nvim_lsp = {kind = "   (LSP)"},
	--         -- nvim_lua = {kind = "  "},
	--         nvim_lua = true,
	--         spell = {kind = "   (Spell)"},
	--         tags = false,
	--         -- vim_dadbod_completion = true,
	--         -- snippets_nvim = {kind = "  "},
	--         -- ultisnips = {kind = "  "},
	--         treesitter = {kind = "  "},
	--         emoji = {kind = " ﲃ  (Emoji)", filetypes={"markdown", "text"}}
	--         -- for emoji press : (idk if that in compe tho)
	--     }
	--
	--     if O.snippets then
	--         table.insert(source, { vsnip = {kind = "   (Snippet)"}})
	--     else
	--         table.insert(source, { vsnip = false})
	--     end
	--
	--     if O.org then
	--         table.insert(source, { orgmode = true })
	--     end
	--
	-- -- require'compe'.setup {
	--     local opt = {
	--     enabled = O.auto_complete,
	--     autocomplete = true,
	--     debug = false,
	--     min_length = 1,
	--     preselect = 'enable',
	--     throttle_time = 80,
	--     source_timeout = 200,
	--     incomplete_delay = 400,
	--     max_abbr_width = 100,
	--     max_kind_width = 100,
	--     max_menu_width = 100,
	--     documentation = true,
	--     source = source
	--     }
	--
	--   local status_ok, compe = pcall(require, "cmp")
	--   if not status_ok then
	--     return
	--   end
	--
	--
	-- -- cmp.setup(opt)
	--
	-- local t = function(str)
	--     return vim.api.nvim_replace_termcodes(str, true, true, true)
	-- end
	--
	-- local check_back_space = function()
	--     local col = vim.fn.col('.') - 1
	--     if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
	--         return true
	--     else
	--         return false
	--     end
	-- end

	-- -- Use (s-)tab to:
	-- --- move to prev/next item in completion menuone
	-- --- jump to prev/next snippet's placeholder
	-- _G.tab_complete = function()
	--     if vim.fn.pumvisible() == 1 then
	--         return t "<C-n>"
	--     elseif vim.fn.call("vsnip#available", {1}) == 1 and O.snippets then
	--         return t "<Plug>(vsnip-expand-or-jump)"
	--     elseif check_back_space() then
	--         return t "<Tab>"
	--     else
	--         return vim.fn['cmp#complete']()
	--     end
	-- end
	-- _G.s_tab_complete = function()
	--     if vim.fn.pumvisible() == 1 then
	--         return t "<C-p>"
	--     elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 and O.snippets then
	--         return t "<Plug>(vsnip-jump-prev)"
	--     else
	--         return t "<S-Tab>"
	--     end
	-- end

	cmp.setup.cmdline(":", {
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})

	cmp.setup.cmdline("/", {
		sources = {
			{ name = "buffer" },
			{ name = "nvim_lsp_document_symbol" },
		},
	})

	-- require("luasnip/loaders/from_vscode").lazy_load({paths={vim.fn.stdpath('config') .. "/snippets"}})
	require("luasnip/loaders/from_vscode").lazy_load()

	local cmp_git_ok, cmp_git = pcall(require, "cmp_git")
	if not cmp_git_ok then
		print("cmp_git not okay")
		return
	end
	cmp_git.setup({
		-- defaults
		filetypes = { "gitcommit" },
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
end
return M
