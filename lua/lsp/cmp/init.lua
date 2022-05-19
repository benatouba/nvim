local M = {}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

M.config = function()
	vim.o.completeopt = 'menu,menuone'
	-- local neogen_ok, neogen = pcall(require, "neogen")
	local cmp_ok, cmp = pcall(require, "cmp")
	local snip_ok, _ = pcall(require, "luasnip")
	if not cmp_ok then
		print("nvim-cmp not okay")
		return
	end
	if not snip_ok then
		print("luasnip not ok")
	end
	cmp.setup({
		view = {
			entries = { name = 'custom', selection_order = 'near_cursor'}
		},
		formatting = {
			format = require("lspkind").cmp_format({
				mode = 'symbol_text',
				maxwidth = 50,
				-- menu = {
				-- 	nvim_lsp = "[LSP]",
				-- 	buffer = "[Buf]",
				-- 	luasnip = "[Snip]",
				-- 	nvim_lua = "[Lua]",
				-- 	latex_symbols = "[Latex]",
				-- 	tmux = "[tmux]",
				-- 	cmp_git = "[Git]",
				-- 	orgmode = "[Org]",
				-- 	zsh = "[Zsh]",
				-- 	path = "[Path]",
				-- 	calc = "[Calc]",
				-- 	emoji = "[Emoji]",
				-- 	tags = "[Tag]",
				-- 	look = "[Look]",
				-- 	vim_dadbod_completion = "[DB]",
				-- },
			}),
		},
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
			["<C-e>"] = cmp.mapping.abort(),
			["<C-h>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-p>"] = cmp.mapping.select_prev_item(),
			-- ["<Tab>"] = cmp.mapping(function(fallback)
   --    if cmp.visible() then
   --      cmp.select_next_item()
   --    elseif snip.expand_or_jumpable() then
   --      snip.expand_or_jump()
   --    elseif has_words_before() then
   --      cmp.complete()
   --    else
   --      fallback()
   --    end
   --  end, { "i", "s" }),
			--
   --  ["<S-Tab>"] = cmp.mapping(function(fallback)
   --    if cmp.visible() then
   --      cmp.select_prev_item()
   --    elseif snip.jumpable(-1) then
   --      snip.jump(-1)
   --    else
   --      fallback()
   --    end
   --  end, { "i", "s" }),
		},
		-- --                 ﬘    m    

		sources = {
			{ name = 'copilot', priority = 1 },
			{ name = "nvim_lsp", },
			{ name = "nvim_lsp_document_symbol", },
			{ name = 'nvim_lsp_signature_help'},
			{ name = 'treesitter', },
			{ name = "nvim_lua", },
			{ name = "path" },
			-- { name = "cmp_git", },
			{ name = "tmux", },
			{ name = "orgmode" },
			{ name = "luasnip", },
			-- { name = 'zsh', },
			{ name = "calc", },
			{ name = "emoji", },
			{ name = "tags", },
			-- { name = "look", },
			{ name = "vim-dadbod-completion", },
			{ name = "buffer"},
		},
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})

	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
			-- { name = "nvim_lsp_document_symbol" },
		},
	})

	-- require("luasnip/loaders/from_vscode").lazy_load({paths={vim.fn.stdpath('config') .. "/snippets"}})
	require("luasnip/loaders/from_vscode").lazy_load()

	local cmp_git_ok, cmp_git = pcall(require, "cmp_git")
	if not cmp_git_ok then
		print("cmp_git not okay")
		return
	end
	cmp.setup.filetype('gitcommit', {
		sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
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
