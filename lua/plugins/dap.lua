-- Debugging: nvim-dap with UI, virtual text, telescope pickers and python/JS adapters.
return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("BP Condition: "))
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dS",
        function()
          require("dap").step_back()
        end,
        desc = "Step Back",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run To Cursor",
      },
      {
        "<leader>dd",
        function()
          require("dap").disconnect()
        end,
        desc = "Disconnect",
      },
      {
        "<leader>dg",
        function()
          require("dap").session()
        end,
        desc = "Get Session",
      },
      {
        "<leader>dl",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        desc = "Log Point",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause.toggle()
        end,
        desc = "Pause",
      },
      {
        "<leader>dq",
        function()
          require("dap").close()
        end,
        desc = "Quit",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle Repl",
      },
      {
        "<leader>dx",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "Clear Breakpoints",
      },
      -- dapui
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Evaluate Expression",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Evaluate Expression",
        mode = "v",
      },
      {
        "<leader>dF",
        function()
          require("dapui").float_element()
        end,
        desc = "Floating Info",
      },
      -- dap-python
      {
        "<leader>dm",
        function()
          require("dap-python").test_method()
        end,
        desc = "Test Method",
      },
      {
        "<leader>df",
        function()
          require("dap-python").test_class()
        end,
        desc = "Test Class",
      },
      -- telescope-dap
      {
        "<leader>dsC",
        function()
          require("telescope").extensions.dap.configurations({})
        end,
        desc = "Configurations",
      },
      {
        "<leader>dsb",
        function()
          require("telescope").extensions.dap.list_breakpoints({})
        end,
        desc = "Breakpoints",
      },
      {
        "<leader>dsc",
        function()
          require("telescope").extensions.dap.commands({})
        end,
        desc = "Commands",
      },
      {
        "<leader>dsf",
        function()
          require("telescope").extensions.dap.frames({})
        end,
        desc = "Frames",
      },
      {
        "<leader>dsv",
        function()
          require("telescope").extensions.dap.variables({})
        end,
        desc = "Variables",
      },
      -- JS launch.json
      {
        "<leader>da",
        function()
          require("plugins.configs.dap").js_attach_with_arguments()
        end,
        desc = "Run with Args (JS)",
      },
    },
    cmd = { "DapContinue", "DapToggleBreakpoint" },
    config = function()
      require("plugins.configs.dap").setup()
    end,
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = "inline", all_frames = true } },
      "mfussenegger/nvim-dap-python",
      {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("dap")
        end,
      },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {},
        config = function(_, opts)
          local dap, dapui = require("dap"), require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_conf"] = function()
            dapui.open()
          end
          dap.listeners.after.event_stopped["dapui_conf"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_conf"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_conf"] = function()
            dapui.close()
          end
        end,
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      handlers = {},
      automatic_installation = false,
    },
    enabled = not vim.g.is_nixos,
  },
}
