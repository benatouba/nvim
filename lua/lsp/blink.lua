local M = {}

-- local function on_blink_cmp_git_error(return_value, standard_error)
--   if return_value == 0 and type(standard_error) == "string" and standard_error:match("^%* Request") then
--     return false
--   end
--
--   return require("blink-cmp-git.default.common").default_on_error(return_value, standard_error)
-- end
--
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
          { "label", gap = 0 },
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
          "lsp",
          "path",
          "snippets",
          "git",
          "ripgrep",
          "calc",
          "emoji",
        }
      end
    end,
    per_filetype = {
      sonicpi = { "sonicpi", inherit_defaults = true },
      gitcommit = { "conventional_commits", "lsp", "git", "snippets", "emoji", "calc", "path" },
      lua = function()
        if string.find(vim.fn.getcwd(), "nvim") then
          return { "lazydev", inherit_defaults = true }
        else
          return { inherit_defaults = true }
        end
      end,
      python = { "jupynium", inherit_defaults = true },
      markdown = function()
        if string.find(vim.fn.getcwd(), "vivere") then
          return { "lsp", "path", "snippets", "emoji", "calc" }
        else
          return { inherit_defaults = true }
        end
      end,
      json = { "npm", inherit_defaults = true },
      octo = { "lsp", "git", "emoji", "calc" },
      org = { "lsp", "orgmode", "path", "snippets", "ripgrep", "emoji", "calc" },
      -- quarto = { inherit_defaults = true, "cmp_r" },
      -- r = { inherit_defaults = true, "cmp_r" },
      -- rmd = { inherit_defaults = true, "cmp_r" },
      sql = { "lsp", "dadbod", "snippets" },
      -- terminal = { "path", "cmp_r" },
      terminal = { "path" },
      -- ["dap-repl"] = { "dap" },
      -- ["dapui_watches"] = { "dap" },
      -- ["dapui_hover"] = { "dap" },
      ["dap-repl"] = { "cmp-dap" },
      ["dapui_watches"] = { "cmp-dap" },
      ["dapui_hover"] = { "cmp-dap" },
    },
    providers = {
      conventional_commits = {
        name = "Conventional Commits",
        module = "blink-cmp-conventional-commits",
        enabled = function()
          return vim.bo.filetype == "gitcommit"
        end,
        ---@module 'blink-cmp-conventional-commits'
        ---@type blink-cmp-conventional-commits.Options
        opts = {
          -- See Configuration section below for available options
        },
      },
      jupynium = {
        name = "Jupynium",
        module = "jupynium.blink_cmp",
        -- Consider higher priority than LSP
        score_offset = 100,
      },
      sonicpi = {
        name = "sonicpi",
        module = "blink.compat.source",
        score_offset = 5,
      },
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
      dap = {
        name = "dap",
        module = "blink-cmp-dap",
        -- enabled = function()
        --   return require("dap").session() ~= nil
        -- end,
      },
      -- cmp_r = {
      --   name = "cmp_r",
      --   module = "blink.compat.source",
      --   opts = {
      --     filetypes = { "r", "rmd", "quarto", "terminal" },
      --   },
      -- },
      nvim_lua = {
        name = "nvim_lua",
        module = "blink.compat.source",
      },
      emoji = {
        name = "Emoji",
        module = "blink-emoji",
        score_offset = 15, -- Tune by preference
        opts = {
          insert = true, -- Insert emoji (default) or complete its name
          ---@type string|table|fun():table
          trigger = function()
            return { ":" }
          end,
        },
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
        score_offset = 100,
      },
      npm = {
        name = "npm",
        module = "blink-cmp-npm",
        async = true,
        enabled = function()
          return vim.bo.filetype == "json"
        end,
        score_offset = 100,
        ---@module "blink-cmp-npm"
        ---@type blink-cmp-npm.Options
        opts = {
          ignore = {},
          only_semantic_versions = true,
          only_latest_version = false,
        },
      },
      git = {
        module = "blink-cmp-git",
        name = "Git",
        should_show_items = function()
          return vim.o.filetype == "gitcommit"
        end,
        -- opts = {
        --   git_centers = {
        --     github = {
        --       issue = { on_error = on_blink_cmp_git_error },
        --       pull_request = { on_error = on_blink_cmp_git_error },
        --       mention = { on_error = on_blink_cmp_git_error },
        --     },
        --   },
        -- },
      },
      snippets = {
        should_show_items = function(ctx)
          return ctx.trigger.initial_kind ~= "trigger_character"
        end,
        opts = {
          filter_snippets = function(ft, file)
            if ft == "gitcommit" and file:match("friendly.snippets") then
              return false
            end
            return true
          end,
        },
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
