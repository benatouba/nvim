-- Locate a language-server binary for a project. Prefers a copy the project pins
-- itself (node_modules/.bin, then a devenv profile), walking up from the root, and
-- falls back to $PATH. Every node-based server config shares this.
local M = {}

---@param start_dir string
---@param cb fun(dir: string): boolean, any
function M.walk_ancestors(start_dir, cb)
  local dir = start_dir
  while dir and dir ~= "" do
    local done, value = cb(dir)
    if done then
      return value
    end
    local parent = vim.fs.dirname(dir)
    if not parent or parent == dir then
      break
    end
    dir = parent
  end
  return nil
end

---@return string[]|nil cmd `{ path, "--stdio" }` when `bin_path` is executable
function M.bin_cmd(bin_path)
  if vim.fn.executable(bin_path) == 1 then
    return { bin_path, "--stdio" }
  end
  local win_candidate = bin_path .. ".cmd"
  if vim.fn.filereadable(win_candidate) == 1 then
    return { win_candidate, "--stdio" }
  end
  return nil
end

local function ancestor_bin(root_dir, subdir, bin)
  if not root_dir or root_dir == "" then
    return nil
  end
  return M.walk_ancestors(root_dir, function(dir)
    local cmd = M.bin_cmd(dir .. subdir .. bin)
    return cmd ~= nil, cmd
  end)
end

--- `bin` from the nearest node_modules/.bin above `root_dir`.
function M.workspace(root_dir, bin)
  return ancestor_bin(root_dir, "/node_modules/.bin/", bin)
end

--- `bin` from the nearest devenv profile above `root_dir`.
function M.devenv(root_dir, bin)
  return ancestor_bin(root_dir, "/.devenv/profile/bin/", bin)
end

--- Project-local first, then devenv, then $PATH. nil when nothing is found.
function M.cmd(root_dir, bin)
  local cmd = M.workspace(root_dir, bin) or M.devenv(root_dir, bin)
  if cmd then
    return cmd
  end
  if vim.fn.executable(bin) == 1 then
    return { bin, "--stdio" }
  end
  return nil
end

--- A `cmd` for vim.lsp.config that resolves `bin` per root_dir at start time.
function M.rpc(bin)
  return function(dispatchers, config)
    local cmd = M.cmd(config and config.root_dir, bin) or { bin, "--stdio" }
    return vim.lsp.rpc.start(cmd, dispatchers)
  end
end

return M
