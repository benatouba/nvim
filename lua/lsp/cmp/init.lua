local M = {}

local has_words_before = function ()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and
    vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end
local bufIsBig = function (bufnr)
  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  if ok and stats and stats.size > max_filesize then
    return true
  else
    return false
  end
end

M.config = function ()
  vim.opt.completeopt = { "menu", "menuone", }
  -- local neogen_ok, neogen = pcall(require, "neogen")
  local cmp_ok, cmp = pcall(require, "cmp")
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

  local default_cmp_sources = cmp.config.sources({
    -- { name = "copilot", priority = 8 },
    -- { name = "nvim_lsp_signature_help" },
    { name = "luasnip" },
    { name = "cmp_r" },
    { name = "orgmode", priority = 100 },
    { name = "lazydev", group_index = 0 },
    { name = "neorg" },
    { name = "npm", priority = 10, keyword_length = 4 },
    { name = "path", priority = 4 },
    { name = "nvim_lsp", keyword_length = 0, priority = 9 },
    { name = "treesitter", priority = 4, max_item_count = 7 },
    { name = "calc", priority = 3 },
    { name = "emoji", priority = 3, max_item_count = 7 },
    { name = "nvim_lua", priority = 5 },
    { name = "tags", priority = 1, keyword_length = 3 },
    { name = "tmux", priority = 4, option = { all_panes = true, label = " tmux" } },
    -- { name = "look", },
    -- { name = "vim-dadbod-completion" },
    { name = "rg", priority = 1, keyword_length = 3, max_item_count = 7 },
  })

  if O.codeium then
    table.insert(default_cmp_sources, { name = "codeium", priority = 1 })
  end

  cmp.setup({
    enabled = function ()
      -- disbable completion in telescope buffers
      if vim.bo.filetype == "TelescopePrompt" then
        return false
      end
      -- disable completion in comments
      local context = require("cmp.config.context")
      -- keep command mode completion enabled when cursor is in a comment
      if vim.api.nvim_get_mode().mode == "c" then
        return true
      else
        return not context.in_treesitter_capture("comment") and
          not context.in_syntax_group("Comment")
      end
    end,
    performance = {
      max_view_entries = 15,
    },
    snippet = {
      expand = function (args)
        require 'luasnip'.lsp_expand(args.body)
      end,
    },
    -- view = {
    -- 	entries = { name = "native" },
    -- },
    formatting = {
      -- fields = {
      --   cmp.ItemField.Abbr,
      --   cmp.ItemField.Kind,
      --   cmp.ItemField.Menu,
      -- },
      format = lspkind.cmp_format({
        mode = "symbol_text",
        maxwidth = {
          menu = 50, -- leading text (labelDetails)
          abbr = 50, -- actual suggestion item
        },
        ellipsis_char = '...',
        show_labelDetails = true,
        before = function (entry, vim_item)
          local word = entry:get_insert_text()
          local strings = vim.split(vim_item.kind, "%s", { trimempty = true })
          vim_item.kind = strings[1]
          vim_item.menu = strings[2]

          if entry.source.name == "copilot" then
            vim_item.kind = " "
            vim_item.menu = "Copilot"
            vim_item.kind_hl_group = "CmpItemKindCopilot"
            word = str.oneline(vim_item.abbr)
          elseif entry.source.name == "git" then
            vim_item.kind = "󰊢 Git"
            vim_item.kind_hl_group = "CmpItemKindFunction"
            word = str.oneline(vim_item.abbr)
          elseif entry.source.name == "neorg" then
            vim_item.kind = " Neorg"
            vim_item.kind_hl_group = "CmpItemKindText"
            word = str.oneline(vim_item.abbr)
          elseif entry.source.name == "treesitter" then
            vim_item.kind = " Treesitter"
            vim_item.kind_hl_group = "CmpItemKindText"
            word = str.oneline(vim_item.abbr)
          elseif entry.source.name == "dap" then
            vim_item.kind = " DAP"
            vim_item.kind_hl_group = "CmpItemKindText"
          elseif entry.source.name == "cmp_r" then
            vim_item.kind = "󰟔 R"
            -- vim_item.kind_hl_group = "CmpItemKindFunction"
          elseif entry.source.name == "tmux" then
            vim_item.kind = " Tmux"
            vim_item.kind_hl_group = "CmpItemKindText"
          elseif entry.source.name == "cmdline" then
            vim_item.kind = " Cmd"
            vim_item.kind_hl_group = "CmpItemKindFunction"
          elseif entry.source.name == "tags" then
            vim_item.kind = " Tags"
            vim_item.kind_hl_group = "CmpItemKindText"
          elseif entry.source.name == "cmdline_history" then
            vim_item.kind = " History"
            vim_item.kind_hl_group = "CmpItemKindFunction"
          elseif entry.source.name == "rg" then
            vim_item.kind = " Grep"
            vim_item.kind_hl_group = "CmpItemKindFunction"
          elseif entry.source.name == "Buffer" then
            vim_item.kind = " Buffer"
            vim_item.kind_hl_group = "CmpItemKindText"
          elseif vim_item.kind == "String" then
            vim_item.kind = " String"
            vim_item.kind_hl_group = "CmpItemKindText"
          elseif vim_item.kind == "Comment" then
            vim_item.kind = " Comment"
            vim_item.kind_hl_group = "CmpItemKindText"
          elseif entry.source.name == "emoji" then
            vim_item.kind = "ﲃ Emoji"
            vim_item.kind_hl_group = "CmpItemKindCopilot"
          elseif entry.source.name == "npm" then
            vim_item.kind = " npm"
            vim_item.kind_hl_group = "CmpItemKindNpm"
          elseif entry.source.name == "lua-latex-symbols" then
            vim_item.kind = " LaTeX"
            vim_item.kind_hl_group = "CmpItemKindSnippet"
          elseif entry.source.name == "Codeium" then
            vim_item.kind = " Codeium"
            vim_item.kind_hl_group = "CmpItemKindCopilot"
            word = str.oneline(vim_item.abbr)
          end


          -- Get the full snippet (and only keep first line)
          word = str.oneline(word)

          -- concatenates the string
          local max = 50
          if string.len(word) >= max then
            local before = string.sub(word, 1, math.floor((max - 3) / 2))
            word = before .. ".."
          end

          if
            entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
            and string.sub(vim_item.abbr, -1, -1) == "~"
          then
            word = word .. ".."
          end
          vim_item.abbr = word

          return vim_item
        end
      }),
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
    -- sorting = {
    --   priority_weight = 1.,
    --   comparators = {
    --     -- require("copilot_cmp").comparators.prioritize,
    --     -- require("copilot_cmp.comparators").score,
    --     compare.locality,
    --     compare.score,
    --     compare.offset,
    --     compare.exact,
    --     -- require("cmp-under-comparator").under,
    --     compare.kind,
    --     compare.sort_text,
    --     -- compare.recently_used,
    --     compare.order,
    --   },
    -- },
    mapping = cmp.mapping.preset.insert({
      ["<C-d>"] = function ()
        if not require("noice.lsp").scroll(4) then
          cmp.mapping.scroll_docs(4)
        end
      end,
      ["<C-u>"] = function ()
        if not require("noice.lsp").scroll(-4) then
          cmp.mapping.scroll_docs(-4)
        end
      end,
      ["<C-Space>"] = cmp.mapping(function ()
        if cmp.visible() then
          cmp.abort()
        else
          cmp.complete()
        end
      end, { "i", "s", "c" }),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-h>"] = cmp.mapping.abort(),
      ["<C-l>"] = cmp.mapping(function (fallback)
        local cp_ok, cp = pcall(require, "copilot.suggestion")
        local entry = cmp.get_selected_entry()
        if cmp.visible() and entry then
          cmp.confirm({
            select = false,
          })
        elseif cp_ok and cp.is_visible() then
          cp.accept()
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      ["<CR>"] = cmp.mapping(function (fallback)
        -- local _, cp = pcall(require, "copilot.suggestion")
        local entry = cmp.get_selected_entry()
        if cmp.visible() and entry then
          cmp.confirm({
            -- behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          })
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-j>"] = cmp.mapping(function (fallback)
        local cp_ok, cp = pcall(require, "copilot.suggestion")
        if cmp.visible() then
          cmp.select_next_item()
        elseif cp_ok and cp.is_visible() then
          cp.next()
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      ["<C-k>"] = cmp.mapping(function (fallback)
        local cp_ok, cp = pcall(require, "copilot.suggestion")
        if cmp.visible() then
          cmp.select_prev_item()
        elseif cp.is_visible() and cp_ok then
          cp.prev()
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-s>"] = cmp.mapping(function (fallback)
        if cmp.visible() then
          cmp.select_next_item()
          cmp.confirm()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<Tab>"] = cmp.mapping(function (fallback)
        local cp_ok, cp = pcall(require, "copilot.suggestion")
        local supermaven_ok, supermaven = pcall(require, "supermaven-nvim.completion_preview")
        local _, ls = pcall(require, "luasnip")
        local entry = cmp.get_selected_entry()
        if ls.locally_jumpable(1) then
          ls.jump(1)
        elseif cmp.visible() and not entry then
          cmp.select_next_item()
          cmp.confirm()
        elseif supermaven_ok and supermaven.has_suggestion() then
          supermaven.on_accept_suggestion()
        elseif not has_words_before() then
          fallback()
        elseif cp_ok and cp.is_visible() then
          cp.accept()
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      ["<S-Tab>"] = cmp.mapping(function (fallback)
        local _, luasnip = pcall(require, "luasnip")
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, { "i", "s", "c" }),
    }),
    sources = default_cmp_sources,
  })
  vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function (t)
      local sources = default_cmp_sources
      if not bufIsBig(t.buf) then
        sources[#sources + 1] = { name = "treesitter", group_index = 2 }
      end
      cmp.setup.buffer {
        sources = sources
      }
    end
  })

  cmp.setup.filetype({ "python" }, {
    sources = default_cmp_sources,
  })

  cmp.setup.filetype({ "tex", "plaintex" }, {
    -- formatting = {
    --   format = lspkind.cmp_format({
    --     mode = "symbol_text",
    --     maxwidth = {
    --       menu = 50, -- leading text (labelDetails)
    --       abbr = 50, -- actual suggestion item
    --     },
    --     ellipsis_char = '...',
    --     show_labelDetails = true,
    --     before = function (entry, vim_item)
    --       local word = entry:get_insert_text()
    --       local strings = vim.split(vim_item.kind, "%s", { trimempty = true })
    --       vim_item.kind = strings[1]
    --       vim_item.menu = strings[2]
    --
    --       if entry.source.name == "copilot" then
    --         vim_item.kind = " "
    --         vim_item.menu = "Copilot"
    --         vim_item.kind_hl_group = "CmpItemKindCopilot"
    --         word = str.oneline(vim_item.abbr)
    --       elseif entry.source.name == "git" then
    --         vim_item.kind = "󰊢 Git"
    --         vim_item.kind_hl_group = "CmpItemKindFunction"
    --         word = str.oneline(vim_item.abbr)
    --       elseif entry.source.name == "treesitter" then
    --         vim_item.kind = " Treesitter"
    --         vim_item.kind_hl_group = "CmpItemKindText"
    --         word = str.oneline(vim_item.abbr)
    --       elseif entry.source.name == "tmux" then
    --         vim_item.kind = " Tmux"
    --         vim_item.kind_hl_group = "CmpItemKindText"
    --       elseif entry.source.name == "cmdline" then
    --         vim_item.kind = " Cmd"
    --         vim_item.kind_hl_group = "CmpItemKindFunction"
    --       elseif entry.source.name == "tags" then
    --         vim_item.kind = " Tags"
    --         vim_item.kind_hl_group = "CmpItemKindText"
    --       elseif entry.source.name == "cmdline_history" then
    --         vim_item.kind = " History"
    --         vim_item.kind_hl_group = "CmpItemKindFunction"
    --       elseif entry.source.name == "rg" then
    --         vim_item.kind = " Grep"
    --         vim_item.kind_hl_group = "CmpItemKindFunction"
    --       elseif entry.source.name == "Buffer" then
    --         vim_item.kind = " Buffer"
    --         vim_item.kind_hl_group = "CmpItemKindText"
    --       elseif vim_item.kind == "String" then
    --         vim_item.kind = " String"
    --         vim_item.kind_hl_group = "CmpItemKindText"
    --       elseif vim_item.kind == "Comment" then
    --         vim_item.kind = " Comment"
    --         vim_item.kind_hl_group = "CmpItemKindText"
    --       elseif entry.source.name == "emoji" then
    --         vim_item.kind = "ﲃ Emoji"
    --         vim_item.kind_hl_group = "CmpItemKindCopilot"
    --       elseif entry.source.name == "lua-latex-symbols" then
    --         vim_item.kind = " LaTeX"
    --         vim_item.kind_hl_group = "CmpItemKindSnippet"
    --       elseif entry.source.name == "Codeium" then
    --         vim_item.kind = " Codeium"
    --         vim_item.kind_hl_group = "CmpItemKindCopilot"
    --         word = str.oneline(vim_item.abbr)
    --       elseif entry.source.name ~= 'vimtex' then
    --         vim_item.kind = " LaTeX"
    --       end
    --
    --
    --       word = str.oneline(word)
    --
    --       local max = 50
    --       if string.len(word) >= max then
    --         local before = string.sub(word, 1, math.floor((max - 3) / 2))
    --         word = before .. ".."
    --       end
    --
    --       if
    --         entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
    --         and string.sub(vim_item.abbr, -1, -1) == "~"
    --       then
    --         word = word .. ".."
    --       end
    --       vim_item.abbr = word
    --
    --       return vim_item
    --     end
    --   }),
    -- },
    sources = cmp.config.sources({
      { name = "luasnip" },
      { name = "vimtex" },
      { name = "nvim_lsp",   max_item_count = 5 },
      { name = "treesitter", max_item_count = 5 },
      { name = "calc" },
      { name = "path" },
      { name = "emoji",      max_item_count = 5 },
    })
  })

  -- cmp.setup.filetype({ "r", "rmd", "rmarkdown", "quarto", "rnoweb", "rhelp" }, {
  --   sources = cmp.config.sources({
  --     { name = "cmp_r" },
  --     { name = "path", priority = 4 },
  --     { name = "luasnip", max_item_count = 4, priority = 10 },
  --     { name = "treesitter", priority = 4, max_item_count = 7 },
  --     { name = "calc", priority = 3 },
  --     { name = "emoji", priority = 3, max_item_count = 7 },
  --     { name = "tags", priority = 1, keyword_length = 3 },
  --     { name = "rg", priority = 1, keyword_length = 3, max_item_count = 7 }
  --   })
  -- })

  cmp.setup.filetype({ "org", "orgagenda" }, {
    sources = cmp.config.sources({
      { name = "orgmode",    priority = 100 },
      { name = "treesitter", max_item_count = 5 },
      { name = "calc" },
      { name = "emoji",      max_item_count = 5 },
      { name = "rg",         max_item_count = 5 },
    })
  })

  cmp.setup.filetype({ "norg", "neorg" }, {
    sources = cmp.config.sources({
      { name = "neorg" },
      { name = "nvim_lsp" },
      { name = "treesitter", max_item_count = 10 },
      { name = "rg",         max_item_count = 5 },
      { name = "calc" },
      { name = "emoji",      max_item_count = 10 },
    })
  })
  cmp.setup.filetype({ "ipynb", "jupyter_python", "jupynium" }, {
    sources = cmp.config.sources({
      -- { name = "jupynium",   priority = 1000 },
      { name = "nvim_lsp" },
      -- { name = "nvim_lsp_signature_help" },
      { name = "treesitter", keyword_length = 3 },
      { name = "calc" },
      { name = "emoji" },
      { name = "tags",       keyword_length = 5, max_item_count = 5 },
      { name = "rg",         keyword_length = 5, max_item_count = 5 },
    }),
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
      {
        { name = "path" },
      },
      {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" }
          }
        }
      }),
  })

  for _, cmd_type in ipairs({ "?", "@" }) do
    cmp.setup.cmdline(cmd_type, {
      sources = cmp.config.sources({
        { name = "cmdline_history", max_item_count = 4 },
      }),
    })
  end

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    window = {
      completion = cmp.config.window.bordered({ autocomplete = true }),
    },
    sources = cmp.config.sources({
      { name = "rg",              max_item_count = 4 },
      { name = "cmdline_history", max_item_count = 4 },
    }),
  })

  cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
    sources = cmp.config.sources({
      { name = "git",        max_item_count = 10 },
      { name = "treesitter", max_item_count = 5 },
      { name = "calc" },
      { name = "emoji",      max_item_count = 10 },
    }),
  })

  local cmp_git_ok, cmp_git = pcall(require, "cmp_git")
  if not cmp_git_ok then
    vim.notify("cmp_git not okay")
    return
  end
  cmp_git.setup({
    filetypes = { "gitcommit", "octo", "NeogitCommitMessage", },
    gitlab = {
      hosts = { "gitlab.klima.tu-berlin.de", }
    }
  })
  -- local sign = function (opts)
  --   vim.fn.sign_define(opts.name, {
  --     texthl = opts.name,
  --     text = opts.text,
  --     numhl = "",
  --   })
  -- end

  -- sign({ name = "DiagnosticSignError", text = "✘" })
  -- sign({ name = "DiagnosticSignWarn", text = "▲" })
  -- sign({ name = "DiagnosticSignHint", text = "⚑" })
  -- sign({ name = "DiagnosticSignInfo", text = "" })

  _ = vim.cmd([[
	  augroup DadbodSql
		au!
		autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
	  augroup END
    augroup Rsources
    au!
    "autocmd FileType r,rmd,terminal lua require("cmp_r").setup({filetypes = {"r", "rmd", "quarto", "terminal"},})
    autocmd FileType r,rmd set conceallevel=0
    augroup END
	]])

  vim.keymap.set({ "n", "i", "s" }, "<c-f>", function ()
    if not require("noice.lsp").scroll(4) then
      return "<c-f>"
    end
  end, { silent = true, expr = true })

  vim.keymap.set({ "n", "i", "s" }, "<c-b>", function ()
    if not require("noice.lsp").scroll(-4) then
      return "<c-b>"
    end
  end, { silent = true, expr = true })
  require("cmp_r").setup({ filetypes = { "r", "rmd", "quarto", "terminal" }, })
  vim.cmd(
    [[ autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} }) ]]
  )
end

return M
