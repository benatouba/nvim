-- Environment-aware variants of Overseer's just/make providers. Discovery is
-- manual; make's database query can execute project code during expansion.
local project = require("util.task_project")

local function justfile(name)
  return name:lower() == "justfile" or name:lower() == ".justfile"
end

local function add_recipes(ret, root, data, prefix)
  for _, recipe in pairs(data.recipes or {}) do
    if not recipe.private then
      local target = recipe.namepath or (prefix .. recipe.name)
      local params = {}
      for _, param in ipairs(recipe.parameters or {}) do
        params[param.name] = {
          type = param.kind == "singular" and "string" or "list",
          default = param.default,
          delimiter = " ",
        }
      end
      table.insert(ret, {
        name = "just " .. target,
        desc = recipe.doc,
        tags = project.tags(target),
        params = params,
        builder = function(values)
          local cmd = { "just", target }
          for _, param in ipairs(recipe.parameters or {}) do
            local value = values[param.name]
            if type(value) == "table" then
              vim.list_extend(cmd, value)
            elseif value and value ~= "" then
              table.insert(cmd, value)
            end
          end
          return { cmd = project.command(root, cmd), cwd = root, components = { "default" } }
        end,
      })
    end
  end
  for name, module in pairs(data.modules or {}) do
    add_recipes(ret, root, module, prefix .. name .. "::")
  end
end

return {
  -- No cache: just imports / Make includes can change independently of the root file.
  generator = function(opts, cb)
    local just = project.find(opts.dir, justfile)
    local make = project.find(opts.dir, { "GNUmakefile", "makefile", "Makefile" })
    if not just and not make then
      return {}
    end
    local ret, pending = {}, (just and 1 or 0) + (make and 1 or 0)
    local errors = {}
    local function done(err)
      if err then
        table.insert(errors, err)
      end
      pending = pending - 1
      if pending == 0 then
        if #errors > 0 then
          vim.notify(table.concat(errors, "\n"), vim.log.levels.WARN)
        end
        cb(ret)
      end
    end
    if just then
      local root = vim.fs.dirname(just)
      project.system(root, { "just", "--unstable", "--dump", "--dump-format", "json" }, function(out)
        local ok, data = pcall(vim.json.decode, out.stdout or "", { luanil = { object = true } })
        if out.code ~= 0 or not ok or type(data) ~= "table" or type(data.recipes) ~= "table" then
          done("just discovery failed; run just --dump --dump-format json in a terminal for details")
          return
        end
        add_recipes(ret, root, data, "")
        done()
      end)
    end
    if make then
      local root = vim.fs.dirname(make)
      project.system(root, { "make", "-rRpq" }, function(out)
        if out.code ~= 0 and out.code ~= 1 then
          done("make discovery failed; run make -rRpq in a terminal for details")
          return
        end
        local parsing, previous, seen = false, "", {}
        for line in vim.gsplit(out.stdout or "", "\n") do
          if line:find("# Files", 1, true) == 1 then
            parsing = true
          elseif line:find("# Finished Make", 1, true) == 1 then
            break
          elseif parsing and line:match("^[^%.#%s]") and previous:find("# Not a target", 1, true) ~= 1 then
            local target = line:match("^([^:]+):")
            if target and not seen[target] and not target:find("%%") then
              seen[target] = true
              table.insert(ret, project.template("make " .. target, root, { "make", target }))
            end
          end
          previous = line
        end
        done()
      end, { env = { LANG = "C.UTF-8" } })
    end
  end,
}
