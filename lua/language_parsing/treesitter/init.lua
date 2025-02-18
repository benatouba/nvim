local M = {}

M.config = function ()
  local ts_ok, ts = pcall(require, "nvim-treesitter.configs")
  if not ts_ok then
    vim.notify("Treesitter not okay")
    return
  end
  --[[ local function add(lang, opts)
    if type(opts.ensure_installed) == "table" then
      table.insert(opts.ensure_installed, lang)
    end
  end
  local xdg_config = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"
  local function have(path)
    return vim.uv.fs_stat(xdg_config .. "/" .. path) ~= nil
  end
  add("git_config")

  if have("hypr") then
    add("hyprlang")
  end

  if have("fish") then
    add("fish")
  end

  if have("rofi") or have("wofi") then
    add("rasi")
  end ]]

  vim.filetype.add({
    extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
    filename = {
      [".env"] = "dotenv",
      ["vifmrc"] = "vim",
    },
    pattern = {
      [".*/waybar/config"] = "jsonc",
      [".*/mako/config"] = "dosini",
      [".*/kitty/.+%.conf"] = "bash",
      [".*/hypr/.+%.conf"] = "hyprlang",
      ["%.env%.[%w_.-]+"] = "dotenv",
    },
  })

  ts.setup({
    ensure_installed = { "python", "markdown", "markdown_inline", "lua", "bash", "json" },
    auto_install = true,
    -- sync_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "markdown" },
      -- config = {
      --   vue = {
      --     style_element = "// %s",
      --   },
      -- },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- init_selection = "<CR>",
        -- scope_incremental = "<CR>",
        node_incremental = "<TAB>",
        node_decremental = "<S-TAB>",
      },
    },
    -- context_commentstring = { enable = true },
    indent = {
      enable = true,
      -- disable = { "python", "html" },
    },
    endwise = {
      enable = true,
    },
    matchup = { enable = true },
    autopairs = { enable = true },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,  -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false,  -- Whether the query persists across vim sessions
    },
    rainbow = {
      enable = false,
      extended_mode = true,  -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
      max_file_lines = 1000,  -- Do not enable for files with more than 1000 lines, int
    },

    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = { query = "@function.outer", desc = "around function" },
          ["if"] = { query = "@function.inner", desc = "in function" },
          ["ac"] = { query = "@class.outer", desc = "around class" },
          ["ic"] = { query = "@class.inner", desc = "in class" },
        },
      },

      swap = {
        enable = true,
        swap_next = {
          ["gj"] = "@parameter.inner",
        },
        swap_previous = {
          ["gk"] = "@parameter.inner",
        },
      },

      move = {
        enable = true,
        set_jumps = true,  -- adds movement to the jumplist
        goto_next_start = {
          ["]m"] = { query = "@function.outer", desc = "next function" },
          ["]]"] = { query = "@class.outer", desc = "Next class" },
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },

      lsp_interop = {
        enable = true,
        border = "rounded",
        loating_preview_opts = {},
        peek_definition_code = {
          ["gp"] = "@function.outer",
          ["gP"] = "@class.outer",
        },
      },
    },

    -- refactor = {
    --   highlight_definitions = { enable = true },
    --   -- highlight_current_scope = { enable = true },
    --   navigation = {
    --     enable = true,
    --     keymaps = {
    --       goto_definition_lsp_fallback = "gd",
    --       list_definitions = "gld",
    --       list_definitions_toc = "gL",
    --       goto_next_usage = "]r",
    --       goto_previous_usage = "[r",
    --     },
    --   },
    --   smart_rename = {
    --     enable = true,
    --     keymaps = {
    --       smart_rename = "gr",
    --     },
    --   },
    -- },
  })
  local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

  -- Repeat movement with ; and ,
  -- ensure ; goes forward and , goes backward regardless of the last direction
  vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
  vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
  --
  -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
  vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  vim.treesitter.language.register('markdown', 'octo')
end
return M
