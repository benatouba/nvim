local M ={}

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.config = function()
  local neogen_ok, neogen = pcall(require, 'neogen')
  local cmp = require'cmp'
  cmp.setup {
    completion = {
      completeopt = 'menu,menuone,noinsert',
      -- autocomplete = false,
    },
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    -- preselect = false,
    -- documentation = {
    -- },
    sorting = {
      priority_weight = 2.,
      comparators = {},
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-u>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<C-h>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ['<Tab>'] = function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
        elseif neogen.jumpable() and neogen_ok then
          vim.fn.feedkeys(t("<cmd>lua require('neogen').jump_next()<CR>"), "")
        elseif check_back_space() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n')
        elseif vim.fn['vsnip#available']() == 1 then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-expand-or-jump)', true, true, true), '')
        else
          fallback()
        end
      end,
    },
    -- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
    -- vim.api.nvim_set_keymap("i", "<C-j>", "v:lua.tab_complete()", {expr = true})
    -- vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
    -- vim.api.nvim_set_keymap("s", "<C-j>", "v:lua.tab_complete()", {expr = true})
    -- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    -- vim.api.nvim_set_keymap("s", "<C-k>", "v:lua.s_tab_complete()", {expr = true})
    -- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    -- vim.api.nvim_set_keymap("s", "<C-k>", "v:lua.s_tab_complete()", {expr = true})
    -- vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    --
    -- vim.api.nvim_set_keymap("i", "<C-Space>", "cmp#complete()", { noremap = true, silent = true, expr = true })
    -- vim.api.nvim_set_keymap("i", "<CR>", "cmp#confirm({ 'keys': '<CR>', 'select': v:true })", { noremap = true, silent = true, expr = true })
    -- vim.api.nvim_set_keymap("i", "<C-h>", "cmp#close('<C-h>')", { noremap = true, silent = true, expr = true })
    -- vim.api.nvim_set_keymap("i", "<C-e>", "cmp#close('<C-e>')", { noremap = true, silent = true, expr = true })
    -- -- vim.api.nvim_set_keymap("i", "<ESC>", "cmp#close('<ESC>')", { noremap = true, silent = true, expr = true })
    -- vim.api.nvim_set_keymap("i", "<C-f>", "cmp#scroll({ 'delta': +4 })", { noremap = true, silent = true, expr = true })
    -- vim.api.nvim_set_keymap("i", "<C-d>", "cmp#scroll({ 'delta': -4 })", { noremap = true, silent = true, expr = true })

    -- --                 ﬘    m    

    sources = {
        { name = 'nvim_lua' },
        { name = 'path' },
            { name = 'nvim_lsp' },
            { name = 'tmux' },
            { name = 'buffer' },
            { name = 'orgmode' },
            { name = 'vsnip' },
            { name = 'calc' },
            { name = 'emoji' },
            { name = 'tags' },
            { name = 'look' },
            { name = 'vim-dadbod-completion' }
        },
  }
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

-- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

end

return M
