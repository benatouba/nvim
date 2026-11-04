-- Plugin groups: lua/plugins/core/ is always loaded, and every lua/plugins/<name>.lua is a
-- group that can be left out. All groups load unless NVIM_GROUPS or a groups.local file in
-- the config directory lists the ones to keep, for example "git,lang". An empty list means
-- core only. The environment variable wins over the file.
local M = {}

local plugins_dir = vim.fs.joinpath(vim.fs.dirname(debug.getinfo(1, "S").source:sub(2)), "..", "plugins")

local function all_groups()
  local names = {}
  for name, kind in vim.fs.dir(plugins_dir) do
    if kind == "file" and name:match("%.lua$") then
      names[#names + 1] = name:gsub("%.lua$", "")
    end
  end
  table.sort(names)
  return names
end

local function requested()
  -- vim.env normalizes an empty value to nil; an explicitly empty list is core only.
  local env = vim.uv.os_getenv("NVIM_GROUPS")
  if env ~= nil then
    return env
  end
  local file = vim.fs.joinpath(vim.fn.stdpath("config"), "groups.local")
  if vim.uv.fs_stat(file) then
    return table.concat(vim.fn.readfile(file), ",")
  end
end

local function select_groups()
  local available = all_groups()
  local raw = requested()
  if not raw then
    return available
  end
  local selected = {}
  for name in raw:gmatch("[^,%s]+") do
    if vim.tbl_contains(available, name) then
      selected[#selected + 1] = name
    elseif name ~= "core" then
      -- Ignored rather than guessed at, so a typo can only ever load less.
      vim.schedule(function()
        vim.notify("Unknown plugin group: " .. name, vim.log.levels.WARN)
      end)
    end
  end
  return vim.fn.uniq(vim.fn.sort(selected))
end

local selected = select_groups()

--- The lazy.nvim spec for the selected groups. Unselected groups are never imported, so
--- their plugins are not installed either.
function M.spec()
  local spec = { { import = "plugins.core" } }
  for _, name in ipairs(selected) do
    spec[#spec + 1] = { import = "plugins." .. name }
  end
  return spec
end

return M
