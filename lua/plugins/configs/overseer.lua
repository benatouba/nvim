local M = {}
local last = {}

function M.opts()
  return {
    dap = false,
    -- Cold Nix metadata evaluation can exceed Overseer's three-second default.
    template_timeout_ms = 120000,
    disable_template_modules = {
      "overseer.template.devenv",
      "overseer.template.npm",
      "overseer.template.just",
      "overseer.template.make",
      "overseer.template.user.run_python_module",
    },
  }
end

function M.setup(opts)
  local overseer = require("overseer")
  overseer.setup(opts)
  overseer.add_template_hook(nil, function(task, util)
    -- In particular, VS Code background tasks otherwise acquire automatic retries.
    util.remove_component(task, "restart_on_save", "on_complete_restart")
  end)
end

local function search()
  return { dir = require("util.task_project").dir(), filetype = vim.bo.filetype }
end

local function remember(task, root)
  last[root] = task
end

function M.run(kind)
  local project = require("util.task_project")
  local opts = search()
  local root = project.root(opts.dir)
  local templates = require("overseer.template")
  -- Refresh only on request, so changed imports/scripts and active files are reflected.
  templates.clear_cache(opts)
  templates.list(opts, function(items, report)
    local errors = {}
    for name, provider in pairs(report.providers) do
      if name:match("^user%.") and provider.message then
        table.insert(errors, provider.message)
      end
    end
    if #errors > 0 then
      vim.notify(table.concat(errors, "\n"), vim.log.levels.WARN)
    end
    items = vim.tbl_filter(function(item)
      local tags = item.tags or {}
      return not item.hide
        and (
          not kind
          or vim.tbl_contains(tags, kind)
          or (kind == "CHECK" and vim.tbl_contains(tags, "TEST"))
          or vim.tbl_contains(project.tags(item.name), kind)
        )
    end, items)
    table.sort(items, function(a, b)
      return a.name < b.name
    end)
    if #items == 0 then
      vim.notify("No " .. (kind and kind:lower() .. " " or "") .. "tasks discovered", vim.log.levels.INFO)
      return
    end
    -- Always select, even for one result. Cancelling must never launch anything.
    vim.ui.select(items, {
      prompt = kind and (kind:lower() .. " task:") or "Project task:",
      format_item = function(item)
        return item.name .. (item.desc and item.desc ~= "" and (" — " .. item.desc) or "")
      end,
    }, function(item)
      if not item then
        return
      end
      templates.build_task(item, { search = opts, params = {} }, function(err, task)
        if not task then
          if err then
            vim.notify(tostring(err), vim.log.levels.ERROR)
          end
          return
        end
        if task:start() then
          remember(task, root)
        end
      end)
    end)
  end)
end

function M.rerun()
  local overseer = require("overseer")
  local project = require("util.task_project")
  local root = project.root(project.dir())
  local task = last[root]
  if not task then
    task = overseer.list_tasks({
      filter = function(item)
        return item.cwd and project.root(item.cwd) == root
      end,
    })[1]
  end
  if not task then
    vim.notify("No previous task for this project", vim.log.levels.INFO)
    return
  end
  if task:is_running() then
    vim.notify("Task is already running; stop it first with <leader>Os", vim.log.levels.INFO)
    return
  end
  if task:is_disposed() then
    task = task:clone()
    task:start()
  else
    task:restart()
  end
  remember(task, root)
end

function M.stop()
  local tasks = require("overseer").list_tasks({ status = "RUNNING" })
  if #tasks == 0 then
    vim.notify("No running tasks", vim.log.levels.INFO)
    return
  end
  vim.ui.select(tasks, {
    prompt = "Stop task:",
    format_item = function(task)
      return task.name .. " (" .. task.cwd .. ")"
    end,
  }, function(task)
    if task then
      task:stop()
    end
  end)
end

return M
