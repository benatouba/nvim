return {
  name = "run script",
  builder = function()
    local project = require("util.task_project")
    local file = vim.fn.expand("%:p")
    assert(not vim.bo.modified, "Save the file before running it")
    local root = project.root(vim.fs.dirname(file))
    local cmd = { file }
    if vim.bo.filetype == "go" then
      cmd = { "go", "run", file }
    elseif vim.bo.filetype == "sh" then
      cmd = { "bash", file }
    elseif vim.bo.filetype == "bash" then
      cmd = { "bash", file }
    end
    return {
      cmd = project.command(root, cmd),
      cwd = root,
      components = {
        { "on_output_quickfix", set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      },
    }
  end,
  condition = {
    -- Python files use the project-aware uv task instead of bare python.
    filetype = { "bash", "sh", "go" },
  },
}
