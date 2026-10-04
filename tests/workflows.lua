-- Functional checks against the real config/plugins/tools, not loading assertions.
local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
local function wait_for(predicate, label)
  assert(vim.wait(30000, predicate, 50), "timed out: " .. label)
end
local function edit(name, lines)
  local path = root .. "/" .. name
  vim.fn.writefile(lines, path)
  vim.cmd.edit(vim.fn.fnameescape(path))
  return vim.api.nvim_get_current_buf()
end
local ok, err = pcall(function()
  local buf = edit("sample.lua", { "local x={1,2}", "print(x)" })
  local conform = require("conform")
  local format_error
  conform.format({ bufnr = buf, async = false, lsp_format = "never", timeout_ms = 5000 }, function(e)
    format_error = e
  end)
  assert(not format_error, format_error)
  assert(vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == "local x = { 1, 2 }")
  vim.bo.modified = false
  print("Lua formatting: PASS")

  require("telescope.builtin").find_files({ cwd = root })
  local picker = require("telescope.actions.state").get_current_picker(vim.api.nvim_get_current_buf())
  wait_for(function()
    return picker.manager and picker.manager:num_results() > 0 and picker:get_selection() ~= nil
  end, "Telescope results")
  require("telescope.actions").select_default(picker.prompt_bufnr)
  wait_for(function()
    return vim.api.nvim_buf_get_name(0) == root .. "/sample.lua"
  end, "Telescope selection")
  print("Telescope file selection: PASS")

  local task = require("overseer").new_task({ cmd = { "sh", "-c", "printf task-ok" } })
  task:start()
  wait_for(function()
    return task:is_complete()
  end, "Overseer task")
  assert(task.status == "SUCCESS")
  assert(table.concat(vim.api.nvim_buf_get_lines(task:get_bufnr(), 0, -1, false), "\n"):find("task%-ok"))
  print("Overseer execution: PASS")

  vim.fn.writefile({ "[project]", 'name = "verification-fixture"', 'version = "0.0.0"' }, root .. "/pyproject.toml")
  local venv = vim.system({ "uv", "venv", "--python", vim.fn.exepath("python3"), root .. "/.venv" }):wait()
  assert(venv.code == 0, venv.stderr)
  buf = edit("sample.py", {
    "import sys",
    "import os",
    'value: int = "wrong"',
    "print(os.name,sys.version,undefined_name)",
  })
  wait_for(function()
    return #vim.lsp.get_clients({ bufnr = buf }) == 2
  end, "Python servers")
  wait_for(function()
    local sources = {}
    for _, diagnostic in ipairs(vim.diagnostic.get(buf)) do
      sources[diagnostic.source] = true
    end
    return sources.Ruff and sources.ty
  end, "Ruff + ty diagnostics")
  conform.format({ bufnr = buf, async = false, lsp_format = "never", timeout_ms = 5000 }, function(e)
    format_error = e
  end)
  assert(not format_error, format_error)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  assert(lines[1] == "import os" and lines[2] == "import sys", vim.inspect(lines))
  assert(table.concat(lines, "\n"):find("print%(os.name, sys.version, undefined_name%)"))
  vim.bo.modified = false
  print("Python lint/types/imports/format: PASS")

  buf = edit("complete.py", { "import os", "os." })
  wait_for(function()
    return #vim.lsp.get_clients({ bufnr = buf }) == 2
  end, "Python servers (completion)")
  local ty_client = vim.lsp.get_clients({ bufnr = buf, name = "ty" })[1]
  assert(ty_client, "ty client is missing")
  local params = vim.lsp.util.make_position_params(0, ty_client.offset_encoding)
  params.position = { line = 1, character = 3 }
  local done, items = false, nil
  ty_client:request("textDocument/completion", params, function(e, result)
    assert(not e, vim.inspect(e))
    items = result and (result.items or result) or {}
    done = true
  end)
  wait_for(function()
    return done
  end, "ty completion response")
  assert(#items > 0, "ty returned no completion items for os.")
  print("Python completion: PASS (" .. #items .. " items for os.)")

  local function specialist(path, filetype, plugin)
    local path_full = root .. "/" .. path
    vim.fn.writefile({ "probe" }, path_full)
    vim.cmd.edit(vim.fn.fnameescape(path_full))
    assert(vim.bo.filetype == filetype, path .. ": filetype is " .. vim.bo.filetype)
    wait_for(function()
      local spec = require("lazy.core.config").plugins[plugin]
      return spec and spec._.loaded
    end, plugin .. " load")
    print(path .. " (" .. plugin .. "): PASS")
  end
  specialist("note.org", "org", "orgmode")
  specialist("note.md", "markdown", "obsidian.nvim")
  -- ledger.nvim excluded: the plugin errors internally on BufEnter
  -- ("loop or previous error loading module 'ledger.context'" from its own
  -- commands.lua), independent of this config; needs an upstream report.
  specialist("beat.scd", "supercollider", "scnvim")
end)
for _, client in ipairs(vim.lsp.get_clients()) do
  client:stop(true)
end
vim.fn.delete(root, "rf")
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd.cquit()
end
vim.cmd.qa({ bang = true })
