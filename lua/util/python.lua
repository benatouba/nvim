-- Resolve project-owned Python tools at use time, not when the plugin loads.
local M = {}

function M.executable(root, bin)
  local resolve = require("lsp.resolve")
  for _, subdir in ipairs({ "/.venv/bin/", "/.devenv/profile/bin/" }) do
    local path = resolve.walk_ancestors(root or vim.fn.getcwd(), function(dir)
      local candidate = dir .. subdir .. bin
      return vim.fn.executable(candidate) == 1, candidate
    end)
    if path then
      return path
    end
  end
  -- Ignore old Mason installations even if Mason has prepended them to PATH.
  local mason = vim.fn.stdpath("data") .. "/mason/"
  for _, dir in ipairs(vim.split(vim.env.PATH or "", ":", { trimempty = true })) do
    local path = vim.fs.normalize(dir .. "/" .. bin)
    local real = vim.uv.fs_realpath(path) or path
    if not vim.startswith(path, mason) and not vim.startswith(real, mason) and vim.fn.executable(path) == 1 then
      return path
    end
  end
end

function M.rpc(bin)
  return function(dispatchers, config)
    local path = M.executable(config.root_dir, bin)
    assert(path, bin .. " is unavailable; provision it with uv or the project Nix environment")
    return vim.lsp.rpc.start({ path, "server" }, dispatchers)
  end
end

function M.formatter(_, ctx)
  return M.executable(vim.fs.dirname(ctx.filename), "ruff")
end

return M
