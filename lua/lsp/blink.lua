local M = {}

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
  keymap = {
    preset = "default",
    -- ["<CR>"] = { "select_and_accept", "fallback" },
    ["<C-l>"] = { "select_and_accept", "fallback" },
    -- ["<Tab>"] = {},
    ["<Up>"] = {},
    ["<Down>"] = {},
  },

  completion = {
    accept = {
      auto_brackets = {
        enabled = true,
      },
    },

    trigger = {
      show_on_trigger_character = true,
    },
    list = {
      selection = {
        preselect = true,
        auto_insert = true,
      },
    },
    menu = {
      border = "single",
      cmdline_position = function()
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
          { "label", gap = 1 },
          { "kind_icon", "source_name" },
        },
        components = {
          label = {
            text = function(ctx)
              return require("colorful-menu").blink_components_text(ctx)
            end,
            highlight = function(ctx)
              return require("colorful-menu").blink_components_highlight(ctx)
            end,
          },
          kind_icon = {
            text = function(item)
              local kind = require("lspkind").symbol_map[item.kind] or ""
              return kind .. " "
            end,
            highlight = "CmpItemKind",
          },
          kind = {
            text = function(item)
              return item.kind
            end,
            highlight = "CmpItemKind",
          },
        },
      },
    },
    documentation = { auto_show = true, auto_show_delay_ms = 100, window = { border = "single" } },
  },
  signature = { enabled = false, window = { border = "single" } },
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = "mono",
  },
  cmdline = {
    enabled = true,
    completion = {
      menu = {
        auto_show = function(ctx)
          if ctx.mode == "cmdline" and string.find(ctx.line, "/") ~= nil then
            return true
          end
          return false
        end,
      },
    },
    keymap = {
      preset = "cmdline",
      ["<C-l>"] = { "select_and_accept" },
    },
  },
  sources = {
    default = function(ctx)
      local success, node = pcall(vim.treesitter.get_node)
      if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
        return { "buffer" }
      else
        return {
          "ecolog",
          "lsp",
          "path",
          "snippets",
          "dap",
          "git",
          "ripgrep",
          "calc",
          "emoji",
        }
      end
    end,
    per_filetype = {
      gitcommit = { "lsp", "git", "snippets", "emoji", "calc", "path" },
      lua = function()
        if string.find(vim.fn.getcwd(), "nvim") then
          return { "lazydev", inherit_defaults = true }
        else
          return { inherit_defaults = true }
        end
      end,
      -- python = { "ledger", inherit_defaults = true },
      markdown = function()
        if string.find(vim.fn.getcwd(), "vivere") then
          return { "ecolog", "lsp", "path", "snippets", "emoji", "calc" }
        else
          return { inherit_defaults = true }
        end
      end,
      octo = { "lsp", "git", "emoji", "calc" },
      org = { "lsp", "orgmode", "path", "snippets", "ripgrep", "emoji", "calc" },
      quarto = { inherit_defaults = true, "cmp_r" },
      r = { inherit_defaults = true, "cmp_r" },
      rmd = { inherit_defaults = true, "cmp_r" },
      sql = { "lsp", "dadbod", "snippets" },
      terminal = { "path", "cmp_r" },
      ["dap-repl"] = { "dap" },
      ["dapui_watches"] = { "dap" },
      ["dapui_hover"] = { "dap" },
    },
    providers = {
      orgmode = {
        name = "Orgmode",
        module = "orgmode.org.autocompletion.blink",
        fallbacks = { "buffer" },
      },
      buffer = {
        opts = {
          enable_in_ex_commands = true,
        },
      },
      calc = {
        name = "Calc",
        module = "blink-calc",
      },
      ecolog = { name = "ecolog", module = "ecolog.integrations.cmp.blink_cmp" },
      dap = {
        name = "dap",
        module = "blink.compat.source",
      },
      cmp_r = {
        name = "cmp_r",
        module = "blink.compat.source",
        opts = {
          filetypes = { "r", "rmd", "quarto", "terminal" },
        },
      },
      nvim_lua = {
        name = "nvim_lua",
        module = "blink.compat.source",
      },
      emoji = {
        name = "emoji",
        module = "blink.compat.source",
      },
      path = {
        opts = {
          get_cwd = function(_)
            return vim.fn.getcwd()
          end,
        },
      },
      -- ledger = {
      --   name = "ledger",
      --   module = "blink-cmp-ledger",
      --   -- opts = {
      --   --   enabled = true,
      --   --   max_items = 20,
      --   --   min_keyword_length = 1,
      --   --   score_offset = 85,
      --   -- },
      -- },
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
        score_offset = 1000,
      },
      git = {
        module = "blink-cmp-git",
        name = "Git",
        should_show_items = function()
          return vim.o.filetype == "gitcommit"
        end,
        opts = {},
      },
      snippets = {
        should_show_items = function(ctx)
          return ctx.trigger.initial_kind ~= "trigger_character"
        end,
      },
      ripgrep = {
        module = "blink-ripgrep",
        name = "Ripgrep",
        -- the options below are optional, some default values are shown
        ---@module "blink-ripgrep"
        ---@type blink-ripgrep.Options
        opts = {
          prefix_min_len = 5,
          project_root_marker = { ".git", "package.json", ".root", "pyproject.toml", "refile.org" },
          backend = {
            context_size = 5,
            ripgrep = {
              search_casing = "--smart-case",
              max_filesize = "5M",
              project_root_fallback = true,
            },
          },
          fallback_to_regex_highlighting = true,
          debug = false,
        },
        transform_items = function(_, items)
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
