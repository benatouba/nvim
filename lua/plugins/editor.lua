-- Editing primitives, sessions and search/replace.
return {
  {
    "stevearc/oil.nvim",
    opts = function(_, opts)
      opts.keymaps.gs = {
        callback = function()
          local prefills = { paths = require("oil").get_current_dir() }
          local grug_far = require("grug-far")
          if not grug_far.has_instance("explorer") then
            grug_far.open({
              instanceName = "explorer",
              prefills = prefills,
              staticTitle = "Find and Replace from Explorer",
            })
          else
            grug_far.get_instance("explorer"):open()
            grug_far.get_instance("explorer"):update_input_values(prefills, false)
          end
        end,
        desc = "oil: Search in directory",
      }
    end,
  },
  { "nvim-mini/mini.ai", version = false, event = "VeryLazy", opts = {} },
  { "nvim-mini/mini.bracketed", version = false, event = "VeryLazy", opts = {} },
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
  {
    "nvim-mini/mini.sessions",
    version = false,
    keys = {
      {
        "<leader>Sw",
        function()
          require("mini.sessions").write()
        end,
        desc = "Write Session",
      },
      {
        "<leader>Sr",
        function()
          require("mini.sessions").read()
        end,
        desc = "Read Session",
      },
    },
    opts = { autoread = false },
  },
  {
    "mbbill/undotree",
    -- Disabled on Neovim >= 0.12 (kept for the day it is wanted back).
    enabled = vim.fn.has("nvim-0.12") == 0,
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" } },
  },
  {
    "monaqa/dial.nvim", -- increment/decrement basically everything
    keys = function()
      local map = function(lhs, action, mode)
        return {
          lhs,
          function()
            require("dial.map").manipulate(action, mode)
          end,
          mode = mode:find("visual") and "x" or "n",
          desc = action:sub(1, 1):upper() .. action:sub(2),
        }
      end
      return {
        map("<C-a>", "increment", "normal"),
        map("<C-x>", "decrement", "normal"),
        map("<C-a>", "increment", "visual"),
        map("<C-x>", "decrement", "visual"),
        map("g<C-a>", "increment", "gnormal"),
        map("g<C-x>", "decrement", "gnormal"),
        map("g<C-a>", "increment", "gvisual"),
        map("g<C-x>", "decrement", "gvisual"),
      }
    end,
    config = function()
      local augend = require("dial.augend")
      local default_augends = {
        augend.integer.alias.decimal,
        augend.constant.alias.bool,
        augend.constant.alias.de_weekday,
        augend.constant.alias.de_weekday_full,
        augend.date.alias["%d/%m/%Y"],
        augend.constant.new({ elements = { "yes", "no" } }),
        augend.constant.new({ elements = { "let", "const", "var" } }),
        augend.constant.new({ elements = { "T", "F" } }),
        augend.constant.new({ elements = { "True", "False" } }),
        augend.constant.new({ elements = { "TRUE", "FALSE" } }),
        augend.constant.new({ elements = { "def", "class" } }),
        augend.hexcolor.new({ case = "lower" }),
        augend.semver.alias.semver,
        augend.constant.new({ elements = { "[ ]", "[x]" }, word = false, cyclic = true }),
      }
      local config = require("dial.config")
      config.augends:register_group({
        default = default_augends,
        visual = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%d/%m/%Y"],
        },
      })
      config.augends:on_filetype({
        default = vim.tbl_extend("keep", {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.new({ elements = { "true", "false" } }),
          augend.constant.new({ elements = { "let", "const" } }),
        }, default_augends),
        lua = vim.tbl_extend("keep", {
          augend.integer.alias.decimal,
          augend.constant.new({ elements = { "true", "false" } }),
        }, default_augends),
        markdown = vim.tbl_extend("keep", {
          augend.integer.alias.decimal,
          augend.misc.alias.markdown_header,
          augend.constant.alias.de_weekday,
          augend.constant.alias.de_weekday_full,
        }, default_augends),
      })
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = {},
    keys = {
      { "gS", "<cmd>GrugFar<cr>", desc = "Find in Files (grug-far)" },
      { "gS", "<cmd>GrugFarWithin<cr>", mode = "x", desc = "SearchReplace in Selection" },
      {
        "<localleader>sw",
        function()
          require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
        end,
        desc = "Replace word under Cursor",
      },
      {
        "<localleader>sf",
        function()
          require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
        end,
        desc = "Replace in Current File",
      },
    },
  },
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
