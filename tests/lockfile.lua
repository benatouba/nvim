local lock = vim.json.decode(table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/lazy-lock.json"), "\n"))
local count = 0
local development = 0
for name, plugin in pairs(require("lazy.core.config").plugins) do
  -- Development checkouts intentionally run local, potentially uncommitted code.
  if plugin.dev then
    assert(vim.fn.isdirectory(plugin.dir) == 1, "development plugin is missing: " .. name)
    development = development + 1
  else
    assert(lock[name], "enabled plugin is not pinned: " .. name)
    local result = vim.system({ "git", "-C", plugin.dir, "rev-parse", "HEAD" }, { text = true }):wait()
    assert(result.code == 0, "plugin is not installed: " .. name)
    assert(vim.trim(result.stdout) == lock[name].commit, "revision mismatch: " .. name)
    count = count + 1
  end
end
print("lockfile: PASS (" .. count .. " pinned plugins, " .. development .. " development plugins)")
