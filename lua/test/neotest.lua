local neotest_ok, neotest = pcall(require, "neotest")
if not neotest_ok then
  P("Neotest not okay")
  return
end

neotest.setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
  },
})

local mappings = {
  t = {
    name = "+test",
    a = { "<cmd>lua require('neotest').run.attach()<CR>", "Stop" },
    d = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", "Test in Debug Mode" },
    f = { "<cmd>lua require('neotest').run.run(vim.fn.expand(%))<CR>", "Test File" },
    s = { "<cmd>lua require('neotest').run.stop()<CR>", "Stop" },
    t = { "<cmd>lua require('neotest').run.run()<CR>", "Test Nearest" },
  },
}
require("which-key").register(mappings, { mode = "n", prefix = "<leader>" })
