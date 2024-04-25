local M = {}

local has_words_before = function ()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and
    vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end
local bufIsBig = function (bufnr)
  local max_filesize = 100 * 1024  -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  if ok and stats and stats.size > max_filesize then
    return true
  else
    return false
  end
end

M.config = function ()
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip").filetype_extend("vue",
    { "html", "nuxt_html", "nuxt_script", "script", "style", "vue", })
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

  -- require("cmp-npm").setup({})
  local compare = cmp.config.compare
  local default_cmp_sources = cmp.config.sources({
    { name = "copilot", priority = 8 },
    -- { name = "nvim_lsp_signature_help" },
    { name = "neorg" },
    { name = "npm", priority = 10, keyword_length = 4 },
    { name = "path", priority = 4 },
    { name = "luasnip", max_item_count = 4, priority = 10 },
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

  cmp.setup({
    enabled = function ()
      -- enable autocompletion in nvim-dap
      local cmp_dap_ok, cmp_dap = pcall(require, "cmp_dap")
      if cmp_dap_ok and cmp_dap.is_dap_buffer() then
        return true
      end

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
          end
          if entry.source.name == "git" then
            vim_item.kind = "󰊢 Git"
            vim_item.kind_hl_group = "CmpItemKindFunction"
            word = str.oneline(vim_item.abbr)
          end
          if entry.source.name == "neorg" then
            vim_item.kind = " Neorg"
            vim_item.kind_hl_group = "CmpItemKindText"
            word = str.oneline(vim_item.abbr)
          end
          if entry.source.name == "treesitter" then
            vim_item.kind = " Treesitter"
            vim_item.kind_hl_group = "CmpItemKindText"
            word = str.oneline(vim_item.abbr)
          end
          if entry.source.name == "dap" then
            vim_item.kind = " DAP"
            vim_item.kind_hl_group = "CmpItemKindText"
          end
          if entry.source.name == "tmux" then
            vim_item.kind = " Tmux"
            vim_item.kind_hl_group = "CmpItemKindText"
          end
          if entry.source.name == "cmdline" then
            vim_item.kind = " Cmd"
            vim_item.kind_hl_group = "CmpItemKindFunction"
          end
          if entry.source.name == "tags" then
            vim_item.kind = " Tags"
            vim_item.kind_hl_group = "CmpItemKindText"
          end
          if entry.source.name == "cmdline_history" then
            vim_item.kind = " History"
            vim_item.kind_hl_group = "CmpItemKindFunction"
          end
          if entry.source.name == "rg" then
            vim_item.kind = " Grep"
            vim_item.kind_hl_group = "CmpItemKindFunction"
          end
          if entry.source.name == "Buffer" then
            vim_item.kind = " Buffer"
            vim_item.kind_hl_group = "CmpItemKindText"
          end
          if vim_item.kind == "String" then
            vim_item.kind = " String"
            vim_item.kind_hl_group = "CmpItemKindText"
          end
          if vim_item.kind == "Comment" then
            vim_item.kind = " Comment"
            vim_item.kind_hl_group = "CmpItemKindText"
          end
          if entry.source.name == "emoji" then
            vim_item.kind = "ﲃ Emoji"
            vim_item.kind_hl_group = "CmpItemKindCopilot"
          end
          if entry.source.name == "npm" then
            vim_item.kind = " npm"
            vim_item.kind_hl_group = "CmpItemKindNpm"
          end
          if entry.source.name == "lua-latex-symbols" then
            vim_item.kind = " LaTeX"
            vim_item.kind_hl_group = "CmpItemKindSnippet"
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
    snippet = {
      expand = function (args)
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
      priority_weight = 1.,
      comparators = {
        -- require("copilot_cmp").comparators.prioritize,
        -- require("copilot_cmp.comparators").score,
        require("cmp-under-comparator").under,
        compare.score,
        compare.locality,
        compare.recently_used,
        compare.offset,
        compare.order,
        -- compare.exact,
        -- compare.kind,
        -- compare.sort_text,
        -- compare.length,
      },
    },
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
      ["<C-l>"] = cmp.mapping(function(fallback)
        local _, cp = pcall(require, "copilot.suggestion")
        local entry = cmp.get_selected_entry()
        if cmp.visible() and entry then
          cmp.confirm({
            select = false,
          })
        elseif cp.is_visible() then
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
        -- elseif cp.is_visible() then
        --   cp.accept()
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      ["<C-n>"] = cmp.mapping(function (fallback)
        local _, cp = pcall(require, "copilot.suggestion")
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif cp.is_visible() then
          cp.next()
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      ["<C-p>"] = cmp.mapping(function (fallback)
        local _, cp = pcall(require, "copilot.suggestion")
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif cp.is_visible() then
          cp.prev()
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<Tab>"] = cmp.mapping(function (fallback)
        local _, cp = pcall(require, "copilot.suggestion")
        local entry = cmp.get_selected_entry()
        if cmp.visible() and entry then
          cmp.confirm()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif not has_words_before() then
          fallback()
        elseif cp.is_visible() then
          cp.accept()
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      ["<S-Tab>"] = cmp.mapping(function (fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.jump(-1)
        elseif cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s", "c" }),
    }),
    sources = default_cmp_sources,
    --                 ﬘    m    
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
  cmp.setup.filetype({ "tex", "plaintex" }, {
    sources = cmp.config.sources({
      { name = "lua-latex-symbols", option = { cache = true }, priority = 10 },
      { name = "luasnip" },
      { name = "nvim_lsp", max_item_count = 5 },
      { name = "treesitter", max_item_count = 5 },
      { name = "calc" },
      { name = "path" },
      { name = "emoji", max_item_count = 5 },
    })
  })

  cmp.setup.filetype({ "org", "orgagenda" }, {
    sources = cmp.config.sources({
      { name = "orgmode", priority = 100 },
      { name = "luasnip" },
      { name = "nvim_lsp" },
      { name = "treesitter", max_item_count = 5 },
      { name = "calc" },
      { name = "emoji", max_item_count = 5 },
    })
  })

  cmp.setup.filetype({ "norg", "neorg" }, {
    sources = cmp.config.sources({
      { name = "neorg" },
      { name = "luasnip" },
      { name = "nvim_lsp" },
      { name = "treesitter", max_item_count = 10 },
      { name = "rg", max_item_count = 5 },
      { name = "calc" },
      { name = "emoji", max_item_count = 10 },
    })
  })
  cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = cmp.config.sources({
      { name = "dap" },
    })
  })
  cmp.setup.filetype({ "ipynb", "jupyter_python", "jupynium" }, {
    sources = cmp.config.sources({
      -- { name = "jupynium",   priority = 1000 },
      { name = "luasnip" },
      { name = "nvim_lsp" },
      -- { name = "nvim_lsp_signature_help" },
      { name = "treesitter", keyword_length = 3 },
      { name = "calc" },
      { name = "emoji" },
      { name = "tags", keyword_length = 5, max_item_count = 5 },
      { name = "rg", keyword_length = 5, max_item_count = 5 },
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
      { name = "rg", max_item_count = 4 },
      { name = "cmdline_history", max_item_count = 4 },
    }),
  })

  cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
    sources = cmp.config.sources({
      { name = "git", max_item_count = 10 },
      { name = "luasnip" },
      { name = "treesitter", max_item_count = 5 },
      { name = "calc" },
      { name = "emoji", max_item_count = 10 },
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
  local sign = function (opts)
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
end

return M
