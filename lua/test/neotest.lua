local neotest_ok, neotest = pcall(require, "neotest")
if not neotest_ok then
  vim.notify("Neotest not okay")
  return
end

local M = {}

M.config = function ()
  neotest.setup({
    log_level = vim.log.levels.WARN,
    status = {
      virtual_text = true,
      signs = false,
    },
    icons = {
      running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    },
    strategies = {
      integrated = {
        width = 180,
      },
    },
    summary = {
      animated = true,
      enabled = true,
      expand_errors = true,
      follow = true,
      mappings = {
        attach = "a",
        clear_marked = "M",
        clear_target = "T",
        debug = "d",
        debug_marked = "D",
        expand = { "<CR>", "<2-LeftMouse>" },
        expand_all = "e",
        jumpto = "i",
        mark = "m",
        next_failed = "J",
        output = "o",
        prev_failed = "K",
        run = "r",
        run_marked = "R",
        short = "O",
        stop = "u",
        target = "t",
      },
      open = "botright vsplit | vertical resize 50",
    },
    adapters = {
      require("neotest-python")({
        dap = { justMyCode = true },
        args = { "--log-level", "DEBUG" },
        runner = "pytest",
      }),
      require("neotest-vitest")({
        ignore_file_types = { "python" },
      }),
      require("neotest-vim-test")({
        ignore_file_types = { "python" },
      }),
    },
    -- consumers = {
    --   overseer = require("neotest.consumers.overseer"),
    -- },
    -- overseer = {
    --   enabled = true,
    -- },
  })

  require("which-key").add({
    { "<leader>t", group = "+Test", icon = { icon = "󰙨", color = "green" } },
    { "<leader>tA", "<cmd>lua require('neotest').state.adapter_ids()<CR>", desc = "Adapters" },
    { "<leader>tD", "<cmd>lua require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' })<CR>", desc = "Debug File" },
    { "<leader>tL", "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<CR>", desc = "Last (Debug)" },
    { "<leader>tO", "<cmd>lua require('neotest').output.open({ enter = true, short = true })<CR>", desc = "Output (short)" },
    { "<leader>tP", "<cmd>lua require('test.neotest').NeotestSetupProject()<CR>", desc = "Project" },
    { "<leader>tS", "<cmd>lua require('neotest').run.run({ suite = true })<CR>", desc = "Suite" },
    { "<leader>ta", "<cmd>lua require('neotest').run.attach()<CR>", desc = "Attach to nearest" },
    { "<leader>td", "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<CR>", desc = "Debug" },
    { "<leader>tf", "<cmd>lua require('neotest').run.run({ vim.fn.expand('%') })<CR>", desc = "File" },
    { "<leader>tl", "<cmd>lua require('neotest').run.run_last()<CR>", desc = "Last" },
    { "<leader>tn", "<cmd>lua require('neotest').run.run()<CR>", desc = "Nearest" },
    { "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<CR>", desc = "Output" },
    { "<leader>tp", "<cmd>lua require('neotest').output_panel.toggle()<CR>", desc = "Panel" },
    { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Summary" },
    { "<leader>tt", "<cmd>lua require('neotest').run.run()<CR>", desc = "Suite" },
    { "<leader>tw", "<cmd>lua require('neotest').watch.toggle()<CR>", desc = "Watch" },
    { "<leader>tx", "<cmd>lua require('neotest').run.stop()<CR>", desc = "Stop" },
    { "[T", "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<CR>", desc = "Test (failed)" },
    { "]T", "<cmd>lua require('neotest').jump.next({ status = 'failed' })<CR>", desc = "Test (failed)" },
  })
end

M.NeotestSetupProject = function ()
  vim.ui.select({ "neotest-jest", "neotest-playwright", "neotest-vim-test", "neotest-vitest" }, {
    prompt = "Choose Adapter",
  }, function (choice)
    local neotestDefault = {
      output = {
        enabled = true,
        open_on_run = true,
      },
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },
      library = { plugins = { "neotest" }, types = true },
      discovery = {
        enabled = false,
      },
    }

    vim.ui.input({
      prompt = "Working directory",
      default = vim.fn.getcwd(),
      completion = "dir",
    }, function (input)
      vim.cmd("cd " .. input)
      if choice == "neotest-jest" then
        local jestConf = vim.tbl_deep_extend("force", neotestDefault, {

          adapters = {
            require("neotest-jest")({
              jestCommand = "npm test --",
              jestConfigFile = function ()
                local file = vim.fn.expand("%:p")
                if string.find(file, "/packages/") then
                  return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
                end

                return vim.fn.getcwd() .. "/jest.config.ts"
              end,
              jest_test_discovery = false,
              env = { CI = true },
              cwd = function ()
                local file = vim.fn.expand("%:p")
                if string.find(file, "/packages/") then
                  return string.match(file, "(.-/[^/]+/)src")
                end
                return vim.fn.getcwd()
              end,
            }),
          },
        })
        return require("neotest").setup_project(vim.fn.getcwd(), jestConf)
      end
      if choice == "neotest-vitest" then
        local vitestConf = vim.tbl_deep_extend("force", neotestDefault, {
          adapters = {
            require("neotest-vitest"),
          },
        })
        return require("neotest").setup_project(vim.fn.getcwd(), vitestConf)
      end
      if choice == "neotest-playwright" then
        local playwrightConf = vim.tbl_deep_extend("force", neotestDefault, {
          consumers = {
            playwright = require("neotest-playwright.consumers").consumers,
          },
          adapters = {
            require("neotest-playwright").adapter({
              options = {
                persist_project_selection = true,
                enable_dynamic_test_discovery = true,
              },
            }),
          },
        })
        return require("neotest").setup_project(vim.fn.getcwd(), playwrightConf)
      end
      if choice == "neotest-vim-test" then
        local vimTestConf = vim.tbl_deep_extend("force", neotestDefault, {
          adapters = {
            require("neotest-vim-test"),
          },
        })
        return require("neotest").setup_project(vim.fn.getcwd(), vimTestConf)
      end
    end)
  end)
end

return M
