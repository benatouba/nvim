local M = {}

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
  keymap = {
    preset = 'default',
    ['<CR>'] = { 'accept', 'fallback' },
    ['<Up>'] = {},
    ['<Down>'] = {},
  },

  completion = {
    accept = {
      auto_brackets = {
        enabled = true,
      },
    },

    list = {
      selection = {
        preselect = function (ctx)
          return require('blink.cmp').snippet_active({ direction = 1 })
        end,
      },
    },
    menu = {
      border = 'single',
      cmdline_position = function ()
        if vim.g.ui_cmdline_pos ~= nil then
          local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
          return { pos[1] - 1, pos[2] }
        end
        local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
        return { vim.o.lines - height, 0 }
      end,
      -- nvim-cmp style menu
      draw = {
        columns = {
          { "label",     gap = 1 },
          { "kind_icon", "source_name" }
        },
        components = {
          label = {
            text = function (ctx)
              return require("colorful-menu").blink_components_text(ctx)
            end,
            highlight = function (ctx)
              return require("colorful-menu").blink_components_highlight(ctx)
            end,
          },
          kind_icon = {
            text = function (item)
              local kind = require('lspkind').symbol_map[item.kind] or ''
              return kind .. ' '
            end,
            highlight = 'CmpItemKind',
          },
          kind = {
            text = function (item)
              return item.kind
            end,
            highlight = 'CmpItemKind',
          },
        },
      },
    },
    documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = 'single' } },
  },
  signature = { enabled = true, window = { border = 'single' } },
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = 'mono'
  },
  sources = {
    default = { 'ecolog', 'lsp', 'path', 'snippets', "ripgrep", "calc", "emoji", },
    per_filetype = {
      org = { "lsp", 'orgmode', 'path', 'snippets', "ripgrep",  "emoji", "calc", },
      markdown = { "lsp",  "snippets", "emoji", "calc", },
      gitcommit = { "lsp", 'git', "snippets", "emoji", "calc", },
      sql = { "lsp", 'dadbod', "snippets", },
      lua = { "lsp", 'lazydev', "path", "snippets", "nvim_lua", "calc", },
      octo = { "lsp", 'git', "emoji", "calc", },
      r = { "lsp", 'cmp_r', "path", "snippets", "calc", },
      rmd = { "lsp", 'cmp_r', "path", "snippets", "calc", },
      quarto = { "lsp", 'cmp_r', "path", "snippets", "calc", },
      terminal = { "path", "cmp_r" },
      ["dap-repl"] = { "dap", },
      ["dapui_watches"] = { "dap", },
      ["dapui_hover"] = { "dap", },
    },
    providers = {
      orgmode = {
        name = 'Orgmode',
        module = 'orgmode.org.autocompletion.blink',
        fallbacks = { 'buffer' },
      },
      ecolog = { name = 'ecolog', module = 'ecolog.integrations.cmp.blink_cmp' },
      dap = {
        name = "dap",
        module = "blink.compat.source",
      },
      cmp_r = {
        name = "cmp_r",
        module = "blink.compat.source",
        opts = {
          filetypes = { "r", "rmd", "quarto", "terminal" }
        }
      },
      nvim_lua = {
        name = "nvim_lua",
        module = "blink.compat.source",
      },
      calc = {
        name = "calc",
        module = "blink.compat.source",
      },
      emoji = {
        name = "emoji",
        module = "blink.compat.source",
      },
      -- cmp_rolodex = {
      --   name = "cmp_rolodex",
      --   module = "blink.compat.source",
      --   opts = {
      --     filename = os.getenv("HOME") .. "/documents/rolodex_db.json",
      --     schema_ver = "latest",
      --     encryption = "plaintext",
      --   },
      -- },
      dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
      git = {
        module = 'blink-cmp-git',
        name = 'Git',
        should_show_items = function ()
          return vim.o.filetype == 'gitcommit'
        end,
        opts = {

        },
      },
      snippets = {
        should_show_items = function (ctx)
          return ctx.trigger.initial_kind ~= 'trigger_character'
        end
      },
      ripgrep = {
        module = "blink-ripgrep",
        name = "Ripgrep",
        -- the options below are optional, some default values are shown
        ---@module "blink-ripgrep"
        ---@type blink-ripgrep.Options
        opts = {
          prefix_min_len = 4,
          context_size = 5,
          max_filesize = "5M",
          project_root_marker = { ".git", "package.json", ".root", "pyproject.toml" },
          project_root_fallback = true,
          search_casing = "--smart-case",
          additional_rg_options = {},
          fallback_to_regex_highlighting = true,
          ignore_paths = {},
          additional_paths = {},
          debug = false,
        },
        transform_items = function (_, items)
          for _, item in ipairs(items) do
            item.labelDetails = {
              description = " rg ",
            }
          end
          return items
        end,
      },
    },
  },
}

return M
