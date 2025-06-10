local neotest_ok, neotest = pcall(require, "neotest")
if not neotest_ok then
  vim.notify("Neotest not okay")
  return
end

local M = {}

M.config = function()
  neotest.setup({
    log_level = vim.log.levels.WARN,
    output = {
      enabled = true,
      open_on_run = "short",
    },
    output_panel = {
      enabled = true,
      open = "botright split | resize 20",
    },
    library = { plugins = { "neotest" }, types = true },
    status = {
      virtual_text = true,
      signs = true,
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
      mappings = {
        attach = "a",
        clear_marked = "M",
        clear_target = "T",
        debug = "d",
        debug_marked = "D",
        expand = { "<CR>", "<2-LeftMouse>" },
        expand_all = "e",
        help = "?",
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
        watch = "w"
      },
      open = "botright vsplit | vertical resize 50",
    },
    adapters = {
      require("neotest-python"),
      require("neotest-testthat"), -- for R language
      require("neotest-vitest")({
        filter_dir = function(name, rel_path, root)
          return name ~= "node_modules"
        end,
      }),
      require("neotest-vim-test")({
        ignore_file_types = {
          "python",
          "r",
          "rmd",
          "r_rnvim",
          "typescript",
          "javascript",
          "typescriptreact",
          "javascriptreact",
          "vue",
          "svelte",
        },
      }),
    },
    -- consumers = {
    --   overseer = require("neotest.consumers.overseer"),
    -- },
    -- overseer = {
    --   enabled = true,
    -- },
  })
end

M.NeotestSetupProject = function()
  vim.ui.select({ "neotest-jest", "neotest-playwright", "neotest-vim-test", "neotest-vitest", "neotest-python" }, {
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
      if choice == "neotest-vim-test" then
        local pythonConf = vim.tbl_deep_extend("force", neotestDefault, {
          adapters = {
            require("neotest-python"),
          },
        })
        return require("neotest").setup_project(vim.fn.getcwd(), pythonConf)
      end
    end)
  end)
end

return M
