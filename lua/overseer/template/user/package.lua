-- package.json is the command owner; this adapter only selects cwd/environment.
local project = require("util.task_project")
local locks = {
  npm = { "package-lock.json", "npm-shrinkwrap.json" },
  pnpm = { "pnpm-lock.yaml" },
  yarn = { "yarn.lock" },
  bun = { "bun.lock", "bun.lockb" },
}

local function manager(root, data)
  local declared = type(data.packageManager) == "string" and data.packageManager:match("^([%w]+)@")
  if declared then
    return locks[declared] and declared or nil, "Unsupported packageManager in package.json"
  end
  local found = {}
  local dir = root
  local boundary = vim.fs.root(root, ".git")
  while dir do
    for name, names in pairs(locks) do
      for _, lock in ipairs(names) do
        if vim.uv.fs_stat(dir .. "/" .. lock) then
          found[name] = true
        end
      end
    end
    if not vim.tbl_isempty(found) or dir == boundary then
      break
    end
    dir = vim.fs.dirname(dir) ~= dir and vim.fs.dirname(dir) or nil
  end
  local names = vim.tbl_keys(found)
  if #names > 1 then
    return nil, "Conflicting package lockfiles; set packageManager in package.json"
  end
  return names[1] or "npm"
end

return {
  generator = function(opts)
    local file = project.find(opts.dir, "package.json")
    if not file then
      return {}
    end
    local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(file), "\n"), { luanil = { object = true } })
    if not ok or type(data) ~= "table" then
      return "Invalid package.json"
    end
    local root = vim.fs.dirname(file)
    local bin, err = manager(root, data)
    if not bin then
      return err
    end
    local ret = {}
    for name in pairs(data.scripts or {}) do
      table.insert(ret, project.template(bin .. " " .. name, root, { bin, "run", name }))
    end
    -- Installation is explicit too, never a side effect of listing package scripts.
    table.insert(ret, project.template(bin .. " install", root, { bin, "install" }, "Install project dependencies", {}))
    return ret
  end,
}
