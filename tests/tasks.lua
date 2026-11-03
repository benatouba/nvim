-- nvim --headless -u NONE -l tests/tasks.lua
local config = vim.fn.getcwd()
vim.opt.rtp:remove(vim.fn.stdpath("config"))
vim.opt.rtp:remove(vim.fn.stdpath("config") .. "/after")
vim.opt.rtp:prepend(config)
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/overseer.nvim")
package.path = config .. "/lua/?.lua;" .. config .. "/lua/?/init.lua;" .. package.path
local root = "/tmp/opencode/nvim-tasks-" .. vim.uv.hrtime() .. " spaced project"
local original_select, original_notify = vim.ui.select, vim.notify
local overseer = require("overseer")
local original_system = overseer.builtin.system
local original_jobstart = overseer.builtin.jobstart
local calls, launches, notifications = {}, 0, {}
local function write(file, lines)
  vim.fn.mkdir(vim.fs.dirname(root .. "/" .. file), "p")
  vim.fn.writefile(lines or {}, root .. "/" .. file)
end
local function wait_for(fn)
  assert(vim.wait(10000, fn), "Timed out")
end
local ok, err = xpcall(function()
  vim.fn.mkdir(root .. "/.git", "p")
  write("devenv.nix")
  write("flake.nix")
  write("uv.lock")
  write("pyproject.toml", { "[project]", 'dependencies = ["pytest", "ruff", "mypy"]' })
  write("package.json", {
    '{"name":"fixture","packageManager":"pnpm@10.0.0","scripts":{"build":"echo build","check":"echo check","dev":"echo dev"}}',
  })
  write("justfile")
  write("Makefile")
  write(".stylua.toml")
  write("init.lua")
  write("lua/config/options.lua")
  write("tests/example.lua", { "-- nvim --headless -u NONE -l tests/example.lua" })
  write("src/example.py", { "print('fixture')" })
  for _, bin in ipairs({ "devenv", "pnpm", "just", "make", "uv", "nvim", "nix", "stylua" }) do
    write(".devenv/profile/bin/" .. bin, { "#!/bin/sh", "exit 0" })
    vim.fn.setfperm(root .. "/.devenv/profile/bin/" .. bin, "rwx------")
  end
  vim.notify = function(message)
    table.insert(notifications, message)
  end
  overseer.builtin.system = function(cmd, opts, cb)
    table.insert(calls, { cmd = cmd, opts = opts })
    local stdout, code
    if vim.tbl_contains(cmd, "list") then
      stdout = '[{"name":"app:check","description":"Checks"},{"name":"ops:deploy"}]'
    elseif vim.tbl_contains(cmd, "eval") then
      stdout = '{"scripts":{"check":{},"cleanup":{}}}'
    elseif vim.tbl_contains(cmd, "--dump") then
      stdout = vim.json.encode({
        recipes = {
          check = { name = "check", namepath = "check", parameters = {}, doc = vim.NIL },
          deploy = { name = "deploy", namepath = "deploy", parameters = { { name = "host", kind = "singular" } } },
          hidden = { name = "hidden", private = true },
        },
        modules = { sub = { recipes = { build = { name = "build", parameters = {} } } } },
      })
    elseif vim.tbl_contains(cmd, "-rRpq") then
      stdout, code = "# Files\ncheck:\n# Not a target:\ninput.txt:\ndeploy:\nbuild:\n# Finished Make", 1
    else
      error("Unexpected discovery command: " .. vim.inspect(cmd))
    end
    if cmd[7] == "sh" then
      stdout = "Shell setup banner\n\030OVERSEER_DISCOVERY\030\n" .. stdout
    end
    cb({ code = code or 0, stdout = stdout })
  end
  overseer.builtin.jobstart = function(...)
    launches = launches + 1
    return original_jobstart(...)
  end
  local ui = require("plugins.configs.overseer")
  ui.setup(ui.opts())
  assert(#calls == 0 and launches == 0, "Loading/configuration must not discover or launch")
  local project = require("util.task_project")
  assert(vim.tbl_contains(project.tags("test:unit"), "CHECK"))
  assert(vim.tbl_contains(project.tags("app:build"), "BUILD"))
  assert(vim.tbl_contains(require("overseer.template.user.run_script").condition.filetype, "sh"))
  assert(project.binary(root .. "/src", "pnpm") == root .. "/.devenv/profile/bin/pnpm")
  assert(project.root(root .. "/src") == root)
  local wrapped = project.command(root .. "/src", { "pnpm", "run", "build" })
  assert(vim.deep_equal(wrapped, {
    root .. "/.devenv/profile/bin/devenv",
    "--no-tui",
    "--from",
    "path:" .. root,
    "shell",
    "--",
    "pnpm",
    "run",
    "build",
  }))
  local native = project.command(root, { "devenv", "tasks", "run", "app:check" })
  assert(#native == 4 and native[2] == "tasks", "Never double-wrap devenv")
  vim.cmd.edit(vim.fn.fnameescape(root .. "/src/example.py"))
  vim.bo.filetype = "python"
  local items, report
  require("overseer.template").list({ dir = root .. "/src", filetype = "python" }, function(found, result)
    items, report = found, result
  end)
  wait_for(function()
    return items ~= nil
  end)
  assert(launches == 0, "Discovery must never launch a task")
  local by_name = {}
  for _, item in ipairs(items) do
    by_name[item.name] = item
  end
  for _, name in ipairs({
    "devenv task: app:check",
    "devenv task: ops:deploy",
    "devenv script: check",
    "devenv script: cleanup",
    "pnpm build",
    "pnpm check",
    "pnpm dev",
    "just check",
    "just deploy",
    "just sub::build",
    "make check",
    "make deploy",
    "Python: tests",
    "Python: lint",
    "Python: format check",
    "Python: mypy",
    "Python: run current file",
    "Lua: style check",
    "Neovim: startup check",
    "Neovim: example.lua",
    "Nix: evaluate checks",
    "Nix: build checks",
    "Nix: build named output",
  }) do
    assert(by_name[name], "Missing " .. name .. ": " .. vim.inspect(report))
  end
  assert(not by_name["make input.txt"] and not by_name["just hidden"])
  local python = by_name["Python: run current file"]
  assert(python.builder().cmd[#python.builder().cmd] == root .. "/src/example.py")
  vim.bo.modified = true
  assert(not pcall(python.builder), "Reject unsaved file execution")
  vim.bo.modified = false
  local deployed = by_name["just deploy"].builder({ host = "synthetic target" })
  assert(deployed.cwd == root and deployed.cmd[#deployed.cmd] == "synthetic target", "Preserve argv parameters")
  local build = by_name["Nix: build named output"].builder({ output = "checks.x86_64-linux.fixture" })
  assert(build.cmd[#build.cmd] == root .. "#checks.x86_64-linux.fixture")
  assert(not pcall(by_name["Nix: build named output"].builder, { output = "" }))
  for _, call in ipairs(calls) do
    assert(not vim.tbl_contains(call.cmd, "echo $DEVENV_TASKS"))
    assert(call.opts.cwd == root)
    if vim.tbl_contains(call.cmd, "list") or vim.tbl_contains(call.cmd, "eval") then
      assert(not vim.tbl_contains(call.cmd, "shell"), "devenv metadata must not enter a shell")
    end
  end
  -- No shell quoting, package-manager guessing or filesystem recursion is needed.
  write("package.json", { '{"scripts":{"check":"echo check"}}' })
  write("pnpm-lock.yaml")
  write("yarn.lock")
  assert(type(require("overseer.template.user.package").generator({ dir = root })) == "string")
  write("package.json", { '{"packageManager":"pnpm@10.0.0","scripts":{"check":"echo check"}}' })
  local yaml = require("overseer.template.user.package").generator({ dir = root })
  assert(type(yaml) == "table" and yaml[1].name:match("^pnpm"))
  -- Invalid metadata and command failures must finish with errors, not hang.
  overseer.builtin.system = function(_, _, cb)
    cb({ code = 0, stdout = "not json" })
  end
  local failure
  require("overseer.template.user.devenv").generator({ dir = root }, function(result)
    failure = result
  end)
  wait_for(function()
    return failure ~= nil
  end)
  assert(type(failure) == "string")
  overseer.builtin.system = function(_, _, cb)
    cb({ code = 2, stdout = "private fixture text" })
  end
  failure = nil
  require("overseer.template.user.devenv").generator({ dir = root }, function(result)
    failure = result
  end)
  wait_for(function()
    return failure ~= nil
  end)
  assert(type(failure) == "string" and not failure:find("private fixture text", 1, true))

  -- Exercise the real UI/build/start path with a harmless, isolated shell command.
  local template = require("overseer.template")
  local original_list = template.list
  template.list = function(_, cb)
    cb({
      {
        name = "fixture check",
        tags = { "CHECK" },
        builder = function()
          return {
            cmd = { "sh", "-c", "printf task-ok" },
            cwd = root,
            components = { "default", "restart_on_save", "on_complete_restart" },
          }
        end,
      },
      {
        name = "fixture build",
        tags = { "BUILD" },
        builder = function()
          error("Must not select build")
        end,
      },
    }, { providers = {} })
  end
  vim.cmd.edit(vim.fn.fnameescape(root .. "/src/example.py"))
  vim.bo.filetype = "python"
  vim.ui.select = function(_, _, cb)
    cb(nil)
  end
  ui.run()
  assert(launches == 0, "Cancelling the picker must not start a task")
  vim.ui.select = function(choices, _, cb)
    assert(#choices == 1 and choices[1].name == "fixture check", "Check filter must not pick a build")
    cb(choices[1])
  end
  ui.run("CHECK")
  wait_for(function()
    return launches == 1
  end)
  local task = overseer.list_tasks()[1]
  wait_for(function()
    return task:is_complete()
  end)
  assert(task.status == "SUCCESS")
  assert(not task:has_component("restart_on_save") and not task:has_component("on_complete_restart"))
  vim.api.nvim_exec_autocmds("BufWritePost", { buffer = 0 })
  assert(launches == 1, "Saving must not restart a command")
  ui.rerun()
  wait_for(function()
    return task:is_complete() and launches == 2
  end)
  task:dispose()
  ui.rerun()
  wait_for(function()
    return launches == 3
  end)
  local clone = overseer.list_tasks()[1]
  wait_for(function()
    return clone:is_complete()
  end)
  -- Stop picker also covers tasks launched outside the custom task picker.
  local running =
    overseer.new_task({ cmd = { "sh", "-c", "exec sleep 30" }, cwd = root, components = { "on_exit_set_status" } })
  running:start()
  vim.ui.select = function(choices, _, cb)
    assert(#choices == 1 and choices[1] == running)
    cb(choices[1])
  end
  ui.stop()
  assert(running.status == "CANCELED")
  template.list = original_list
end, debug.traceback)
overseer.builtin.system = original_system
overseer.builtin.jobstart = original_jobstart
vim.ui.select, vim.notify = original_select, original_notify
vim.fn.delete(root, "rf")
if not ok then
  error(err)
end
print("Task discovery, environments, shortcuts and manual-only lifecycle: PASS")
