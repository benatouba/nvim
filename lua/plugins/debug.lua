return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("debug.dap").config()
    end,
    event = "InsertEnter",
    enabled = O.dap,
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup({})
        end,
      },
      { "mfussenegger/nvim-dap-python" },
      {
        "nvim-telescope/telescope-dap.nvim",
        setup = function()
          require("telescope").load_extension("dap")
        end,
      },
      {
        "rcarriga/nvim-dap-ui",
        event = "InsertEnter",
        dependencies = {
          "nvim-neotest/nvim-nio",
        },
        config = function()
          require("debug.dapui").config()
        end,
        enabled = O.dap,
      },
      {
        "jbyuki/one-small-step-for-vimkind",
        ft = "lua",
        config = function()
          require("debug.one_small_step_for_vimkind").config()
        end,
        enabled = O.dap and false,
      },
      {
        "microsoft/vscode-js-debug",
        lazy = true,
        build = "npm ci --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
        enabled = tonumber(string.sub(Capture("node --version"), 2, 3)) >= 18 and O.webdev and O.dap,
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "InsertEnter",
    dependencies = {
      "mason.nvim",
    },
    opts = {
      handlers = {},
      automatic_installation = false,
    },
    enabled = O.dap and not O.is_nixos,
  },
  {
    "nvim-neotest/neotest",
    keys = {
      { "<leader>tA", "<cmd>lua require('neotest').state.adapter_ids()<CR>", desc = "Adapters" },
      {
        "<leader>tD",
        "<cmd>lua require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' })<CR>",
        desc = "Debug File",
      },
      { "<leader>tL", "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<CR>", desc = "Last (Debug)" },
      {
        "<leader>tO",
        "<cmd>lua require('neotest').output.open({ enter = true, short = true, last_run = true })<CR>",
        desc = "Output (short)",
      },
      { "<leader>tP", "<cmd>lua require('test.neotest').NeotestSetupProject()<CR>", desc = "Project" },
      { "<leader>tS", "<cmd>lua require('neotest').run.run({ suite = true })<CR>", desc = "Suite" },
      { "<leader>ta", "<cmd>lua require('neotest').run.attach()<CR>", desc = "Attach to nearest" },
      { "<leader>td", "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<CR>", desc = "Debug" },
      { "<leader>tf", "<cmd>lua require('neotest').run.run({ vim.fn.expand('%') })<CR>", desc = "File" },
      { "<leader>tl", "<cmd>lua require('neotest').run.run_last()<CR>", desc = "Last" },
      { "<leader>tj", group = "+Jump" },
      {
        "<leader>tjp",
        "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<CR>",
        desc = "Previous (failed)",
      },
      { "<leader>tjn", "<cmd>lua require('neotest').jump.next({ status = 'failed' })<CR>", desc = "Next (failed)" },
      { "<leader>tn", "<cmd>lua require('neotest').run.run()<CR>", desc = "Nearest" },
      { "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<CR>", desc = "Output" },
      { "<leader>tp", "<cmd>lua require('neotest').output_panel.toggle()<CR>", desc = "Panel" },
      { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Summary" },
      { "<leader>tt", "<cmd>lua require('neotest').run.run({ suite = true})<CR>", desc = "Run Tests" },
      { "<leader>tw", "<cmd>lua require('neotest').watch.toggle()<CR>", desc = "Watch" },
      { "<leader>tx", "<cmd>lua require('neotest').run.stop()<CR>", desc = "Stop" },
      { "[T", "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<CR>", desc = "Test (failed)" },
      { "]T", "<cmd>lua require('neotest').jump.next({ status = 'failed' })<CR>", desc = "Test (failed)" },
    },
    dependencies = {
      "nvim-neotest/neotest-python",
      "shunsambongi/neotest-testthat",
      "marilari88/neotest-vitest",
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("test.neotest").config()
    end,
    enabled = O.test,
  },
  { "nvim-neotest/nvim-nio" },
  {
    "kiyoon/jupynium.nvim",
    build = "pip3 install --user .",
    ft = "ipynb",
    enabled = O.notebooks,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    ft = { "sql", "mysql", "plsql" },
    dependencies = {
      "tpope/vim-dadbod",
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        lazy = true,
        enabled = O.language_parsing,
      },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_use_nerd_fonts = 1
    end,
    enabled = O.databases,
  },
}
