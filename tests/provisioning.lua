-- Run with: nvim --headless -u NONE -l tests/provisioning.lua
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path
local root = vim.fn.tempname()
local old_path = vim.env.PATH
local function executable(path)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  vim.fn.writefile({ "#!/bin/sh", "exit 0" }, path)
  assert(vim.uv.fs_chmod(path, 493))
end
local ok, err = pcall(function()
  local mason = vim.fn.stdpath("data") .. "/mason/bin"
  executable(root .. "/system/ruff")
  executable(root .. "/.devenv/profile/bin/ruff")
  executable(root .. "/.venv/bin/ruff")
  vim.env.PATH = mason .. ":" .. root .. "/system"
  local python = require("util.python")
  assert(python.executable(root .. "/src", "ruff") == root .. "/.venv/bin/ruff")
  vim.fn.delete(root .. "/.venv/bin/ruff")
  assert(python.executable(root .. "/src", "ruff") == root .. "/.devenv/profile/bin/ruff")
  vim.fn.delete(root .. "/.devenv/profile/bin/ruff")
  assert(python.executable(root .. "/src", "ruff") == root .. "/system/ruff")
  vim.fn.delete(root .. "/system/ruff")
  assert(python.executable(root, "ruff") == nil, "must not fall back to Mason")
  local servers = require("lsp.servers")
  assert(vim.tbl_contains(servers.servers, "ruff"))
  assert(vim.tbl_contains(servers.servers, "ty"))
  assert(not vim.tbl_contains(servers.mason_servers(), "ruff"))
  assert(not vim.tbl_contains(servers.mason_servers(), "ty"))
end)
vim.env.PATH = old_path
vim.fn.delete(root, "rf")
assert(ok, err)
print("provisioning: PASS")
