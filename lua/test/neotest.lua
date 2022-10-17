local neotest_ok, neotest = pcall(require, "neotest")
if not neotest_ok then
  vim.notify("Neotest not okay")
  return
end

neotest.setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = true },
    }),
    require("neotest-vitest"),
    require("neotest-vim-test")({
      ignore_file_types = { "python" },
    }),
  },
})

local mappings = {
  t = {
    name = "+test",
    a = { "<cmd>lua require('neotest').run.attach()<CR>", "Attach to nearest" },
    A = { "<cmd>lua require('neotest').run.adapters()<CR>", "Adapter list" },
    d = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", "Debug Test" },
    f = { "<cmd>lua require('neotest').run.run(vim.fn.expand(%))<CR>", "Test File" },
    l = { "<cmd>lua require('neotest').run.run_last()<CR>", "Last Test" },
    o = { "<cmd>lua require('neotest').output.open({ enter = true })<CR>", "Output" },
    s = { "<cmd>lua require('neotest').summary.toggle()<CR>", "Summary" },
    S = { "<cmd>lua require('neotest').run.stop()<CR>", "Stop" },
    t = { "<cmd>lua require('neotest').run.run()<CR>", "Test Nearest" },
  },
}
require("which-key").register(mappings, { mode = "n", prefix = "<leader>" })

local jumps = {
  ["[t"] = {"<cmd>lua require('neotest').jump.prev({ status = 'failed' })<CR>", "Test (failed)"},
  ["]t"] = {"<cmd>lua require('neotest').jump.next({ status = 'failed' })<CR>", "Test (failed)"},
}
require("which-key").register(jumps, { mode = "n", prefix = "" })
