local neotest_ok, neotest = pcall(require, "neotest")
if not neotest_ok then
  vim.notify("Neotest not okay")
  return
end

local M = {}

function M.config()
  neotest.setup({
    log_level = vim.log.levels.WARN,
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
        target = "t"
      },
      open = "botright vsplit | vertical resize 50"
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
    -- overseer = {
    --   enabled = true,
    -- }
  })

  local mappings = {
    t = {
      name = "+test",
      a = { "<cmd>lua require('neotest').run.attach()<CR>", "Attach to nearest" },
      A = { "<cmd>lua require('neotest').run.adapters()<CR>", "Adapter list" },
      d = { "<cmd>lua require('neotest').run.run({ strategy = 'dap'  })<CR>", "Debug" },
      f = { "<cmd>lua require('neotest').run.run({ vim.fn.expand('%') })<CR>", "File" },
      l = { "<cmd>lua require('neotest').run.run_last()<CR>", "Last" },
      L = { "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<CR>", "Last" },
      n = { "<cmd>lua require('neotest').run.run()<CR>", "Nearest" },
      o = { "<cmd>lua require('neotest').output.open({ enter = true })<CR>", "Output" },
      O = { "<cmd>lua require('neotest').output.open({ enter = true, short = true })<CR>", "Output (short)" },
      p = { "<cmd>lua require('neotest').output_panel.toggle()<CR>", "Panel" },
      s = { "<cmd>lua require('neotest').summary.toggle()<CR>", "Summary" },
      S = { "<cmd>lua require('neotest').run.run({ suite = true })<CR>", "Suite" },
      t = { "<cmd>lua require('neotest').run.run({ suite = true })<CR>", "Suite" },
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

return M