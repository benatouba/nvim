return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>d", group = "+Debug" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("BP Condition: ")) end, desc = "Conditional Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dS", function() require("dap").step_back() end, desc = "Step Back" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run To Cursor" },
      { "<leader>dd", function() require("dap").disconnect() end, desc = "Disconnect" },
      { "<leader>dg", function() require("dap").session() end, desc = "Get Session" },
      { "<leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "Log Point" },
      { "<leader>dp", function() require("dap").pause.toggle() end, desc = "Pause" },
      { "<leader>dq", function() require("dap").close() end, desc = "Quit" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle Repl" },
      { "<leader>dx", function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" },
      -- dapui
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Evaluate Expression" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Evaluate Expression", mode = "v" },
      { "<leader>dF", function() require("dapui").float_element() end, desc = "Floating Info" },
      -- dap-python
      { "<leader>dm", function() require("dap-python").test_method() end, desc = "Test Method" },
      { "<leader>df", function() require("dap-python").test_class() end, desc = "Test Class" },
      -- telescope-dap
      { "<leader>ds", group = "+Search" },
      { "<leader>dsC", function() require("telescope").extensions.dap.configurations{} end, desc = "Configurations" },
      { "<leader>dsb", function() require("telescope").extensions.dap.list_breakpoints{} end, desc = "Breakpoints" },
      { "<leader>dsc", function() require("telescope").extensions.dap.commands{} end, desc = "Commands" },
      { "<leader>dsf", function() require("telescope").extensions.dap.frames{} end, desc = "Frames" },
      { "<leader>dsv", function() require("telescope").extensions.dap.variables{} end, desc = "Variables" },
      -- JS launch.json
      { "<leader>da", desc = "Run with Args (JS)" },
    },
    cmd = { "DapContinue", "DapToggleBreakpoint" },
    config = function()
      require("debug.dap").config()
    end,
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
        config = function()
          require("telescope").load_extension("dap")
        end,
      },
      {
        "rcarriga/nvim-dap-ui",
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
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
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
    },
    dependencies = {
      "nvim-neotest/neotest-python",
      "shunsambongi/neotest-testthat",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
      { "thenbe/neotest-playwright", dependencies = { "nvim-neotest/neotest" } },
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
