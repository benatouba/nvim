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
