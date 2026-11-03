local project = require("util.task_project")

return {
  cache_key = function(opts)
    return project.find(opts.dir, "devenv.nix")
  end,
  generator = function(opts, cb)
    local file = project.find(opts.dir, "devenv.nix")
    if not file then
      return {}
    end
    local root = vim.fs.dirname(file)
    if not project.binary(root, "devenv") then
      return "devenv is unavailable"
    end
    -- Both are metadata interfaces: no shell entry, task execution or Nix parsing.
    project.json(root, { "devenv", "--quiet", "--no-tui", "tasks", "list", "--json" }, function(tasks, err)
      if not tasks or not vim.islist(tasks) then
        cb(err or "devenv task list must be a JSON array")
        return
      end
      local ret = {}
      for _, task in ipairs(tasks) do
        if type(task) ~= "table" or type(task.name) ~= "string" then
          cb("devenv task list contains an invalid task")
          return
        end
        table.insert(
          ret,
          project.template(
            "devenv task: " .. task.name,
            root,
            { "devenv", "--no-tui", "tasks", "run", task.name },
            type(task.description) == "string" and task.description or nil
          )
        )
      end
      project.json(root, { "devenv", "--quiet", "--no-tui", "eval", "scripts" }, function(data, script_err)
        if not data or type(data.scripts) ~= "table" then
          -- Keep tasks usable if script evaluation fails; make the missing surface visible.
          vim.notify(script_err or "devenv eval scripts returned an invalid object", vim.log.levels.WARN)
        else
          for _, name in ipairs(vim.tbl_keys(data.scripts)) do
            table.insert(
              ret,
              project.template(
                "devenv script: " .. name,
                root,
                { "devenv", "--no-tui", "shell", "--", name },
                "Run the project script inside devenv"
              )
            )
          end
        end
        cb(ret)
      end)
    end)
  end,
}
