local neotest_ok, neotest = pcall(require, "neotest")
if not neotest_ok then
  vim.notify("Neotest not okay")
  return
end

local M = {}

M.config = function()
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
    consumers = {
      overseer = require("neotest.consumers.overseer"),
    },
    overseer = {
      enabled = true,
    },
  })

  local mappings = {
    t = {
      name = "+test",
      a = { "<cmd>lua require('neotest').run.attach()<CR>", "Attach to nearest" },
      A = { "<cmd>lua require('neotest').state.adapter_ids()<CR>", "Adapters" },
      d = { "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<CR>", "Debug" },
      D = {
        "<cmd>lua require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' })<CR>",
        "Debug File",
      },
      f = { "<cmd>lua require('neotest').run.run({ vim.fn.expand('%') })<CR>", "File" },
      l = { "<cmd>lua require('neotest').run.run_last()<CR>", "Last" },
      L = { "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<CR>", "Last (Debug)" },
      n = { "<cmd>lua require('neotest').run.run()<CR>", "Nearest" },
      o = { "<cmd>lua require('neotest').output.open({ enter = true })<CR>", "Output" },
      O = {
        "<cmd>lua require('neotest').output.open({ enter = true, short = true })<CR>",
        "Output (short)",
      },
      p = { "<cmd>lua require('neotest').output_panel.toggle()<CR>", "Panel" },
      P = { "<cmd>lua require('test.neotest').NeotestSetupProject()<CR>", "Project" },
      s = { "<cmd>lua require('neotest').summary.toggle()<CR>", "Summary" },
      S = { "<cmd>lua require('neotest').run.run({ suite = true })<CR>", "Suite" },
      t = { "<cmd>lua require('neotest').run.run()<CR>", "Suite" },
      w = { "<cmd>lua require('neotest').watch.toggle()<CR>", "Watch" },
      x = { "<cmd>lua require('neotest').run.stop()<CR>", "Stop" },
    },
  }
  require("which-key").register(mappings, { mode = "n", prefix = "<leader>" })

  local jumps = {
    ["[T"] = { "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<CR>", "Test (failed)" },
    ["]T"] = { "<cmd>lua require('neotest').jump.next({ status = 'failed' })<CR>", "Test (failed)" },
  }
  require("which-key").register(jumps, { mode = "n", prefix = "" })
end

M.NeotestSetupProject = function()
  vim.ui.select({ "neotest-jest", "neotest-playwright", "neotest-vim-test", "neotest-vitest" }, {
    prompt = "Choose Adapter",
  }, function(choice)
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
    }, function(input)
      vim.cmd("cd " .. input)
      if choice == "neotest-jest" then
        local jestConf = vim.tbl_deep_extend("force", neotestDefault, {

          adapters = {
            require("neotest-jest")({
              jestCommand = "npm test --",
              jestConfigFile = function()
                local file = vim.fn.expand("%:p")
                if string.find(file, "/packages/") then
                  return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
                end

                return vim.fn.getcwd() .. "/jest.config.ts"
              end,
              jest_test_discovery = false,
              env = { CI = true },
              cwd = function()
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
