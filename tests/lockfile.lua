local lock = vim.json.decode(table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/lazy-lock.json"), "\n"))
local count = 0
for name, plugin in pairs(require("lazy.core.config").plugins) do
  assert(lock[name], "enabled plugin is not pinned: " .. name)
  local result = vim.system({ "git", "-C", plugin.dir, "rev-parse", "HEAD" }, { text = true }):wait()
  assert(result.code == 0, "plugin is not installed: " .. name)
  assert(vim.trim(result.stdout) == lock[name].commit, "revision mismatch: " .. name)
  count = count + 1
end
print("lockfile: PASS (" .. count .. " enabled plugins)")
