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
    ensure_installed = "all",
    ignore_install = { "org" },
    -- sync_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "markdown" },
      config = {
        vue = {
          style_element = "// %s",
        },
      },
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
      enable = true,
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
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
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
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
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
end
return M
