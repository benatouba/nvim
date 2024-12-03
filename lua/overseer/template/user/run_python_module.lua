return {
  name = "Run Python module",
  builder = function ()
    local module = vim.fn.expand("%:r")
    local cmd = { "python", "-m", module }
    return {
      cmd = cmd,
      components = {
        { "on_output_quickfix", set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      },
    }
  end,
  condition = {
    filetype = { "python" },
  },
}
