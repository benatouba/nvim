-- Run with: nvim --headless -u NONE -l tests/lsp_resolution.lua
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path
local root = vim.fn.tempname()
local old_path, old_mason, old_nixos = vim.env.PATH, vim.env.MASON, vim.g.is_nixos
local function directory(path)
  vim.fn.mkdir(path, "p")
  return path
end
local function executable(path)
  directory(vim.fs.dirname(path))
  vim.fn.writefile({ "#!/bin/sh", "exit 0" }, path)
  assert(vim.uv.fs_chmod(path, 493))
  return path
end
local ok, err = pcall(function()
  local resolve = require("lsp.resolve")
  local vue = require("lsp.vue")
  local project = directory(root .. "/project/app")
  vim.env.PATH = directory(root .. "/path")
  vim.env.MASON = directory(root .. "/mason")
  vim.g.is_nixos = true

  local parent_bin = executable(root .. "/project/node_modules/.bin/vtsls")
  executable(project .. "/.devenv/profile/bin/vtsls")
  local path_bin = executable(root .. "/path/vtsls")
  assert(resolve.cmd(project, "vtsls")[1] == parent_bin, "workspace tier must beat nearer devenv")
  local sdk = directory(root .. "/project/node_modules/typescript/lib")
  local pkg = directory(root .. "/project/node_modules/@vue/language-server")
  local found_pkg, found_sdk = vue.resolve_paths(project)
  assert(found_pkg == pkg and found_sdk == sdk, "support packages must search ancestors")
  for _, server in ipairs({ "vtsls", "vue_ls", "ts_ls" }) do
    local config = { root_dir = project }
    local params = { initializationOptions = { retained = true } }
    dofile("after/lsp/" .. server .. ".lua").before_init(params, config)
    if server == "vtsls" then
      assert(config.settings.typescript.tsdk == sdk, "vtsls must use discovered SDK")
      assert(config.settings.vtsls.tsserver.globalPlugins[1].location == pkg, "vtsls must use discovered Vue package")
    else
      assert(params.initializationOptions.typescript.tsdk == sdk, server .. " must use discovered SDK")
      assert(params.initializationOptions.retained, "retain unrelated initialization options")
    end
  end

  vim.fn.delete(root .. "/project/node_modules", "rf")
  vim.fn.delete(project .. "/.devenv", "rf")
  local physical = executable(root .. "/store/vtsls/bin/vtsls")
  sdk = directory(root .. "/store/vtsls/lib/node_modules/typescript/lib")
  vim.fn.delete(path_bin)
  assert(vim.uv.fs_symlink(physical, path_bin))
  assert(resolve.cmd(project, "vtsls")[1] == path_bin, "PATH command must have a filesystem identity")
  _, found_sdk = vue.resolve_paths(project)
  assert(found_sdk == sdk, "PATH symlinks must resolve to the physical package")

  -- A workspace executable without supporting packages must not hide a fallback.
  executable(parent_bin)
  _, found_sdk = vue.resolve_paths(project)
  assert(found_sdk == sdk, "split installations must retain PATH package fallback")
  local devenv_bin = executable(root .. "/store/devenv/bin/vtsls")
  local devenv_sdk = directory(root .. "/store/devenv/lib/node_modules/typescript/lib")
  directory(project .. "/.devenv/profile/bin")
  assert(vim.uv.fs_symlink(devenv_bin, project .. "/.devenv/profile/bin/vtsls"))
  _, found_sdk = vue.resolve_paths(project)
  assert(found_sdk == devenv_sdk, "devenv packages must precede PATH packages")

  local vue_bin = executable(root .. "/store/vue/bin/vue-language-server")
  pkg = directory(root .. "/store/vue/lib/language-tools/packages/language-server")
  assert(vim.uv.fs_symlink(vue_bin, root .. "/path/vue-language-server"))
  found_pkg = vue.resolve_paths(project)
  assert(found_pkg == pkg, "Vue PATH symlinks must locate their package")

  vim.g.is_nixos = false
  local mason_pkg = directory(vim.env.MASON .. "/packages/vue-language-server/node_modules/@vue/language-server")
  local mason_sdk =
    directory(vim.env.MASON .. "/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib")
  _, found_sdk = vue.resolve_paths(project)
  assert(found_sdk == devenv_sdk, "project-owned devenv packages must beat Mason")
  vim.fn.delete(project .. "/.devenv", "rf")
  found_pkg, found_sdk = vue.resolve_paths(project)
  assert(found_pkg == mason_pkg and found_sdk == mason_sdk, "retain Mason layout fallback")
  sdk = directory(root .. "/project/node_modules/typescript/lib")
  pkg = directory(root .. "/project/node_modules/@vue/language-server")
  found_pkg, found_sdk = vue.resolve_paths(project)
  assert(found_pkg == pkg and found_sdk == sdk, "workspace packages must beat Mason")

  vim.env.PATH = ""
  vim.fn.delete(root .. "/project/node_modules", "rf")
  vim.fn.delete(vim.env.MASON, "rf")
  found_pkg, found_sdk = vue.resolve_paths(project)
  assert(found_pkg == nil and found_sdk == nil, "missing support packages remain optional")
  for _, server in ipairs({ "vtsls", "vue_ls", "ts_ls" }) do
    local config = { root_dir = project, settings = { retained = true } }
    local params = { initializationOptions = { retained = true } }
    dofile("after/lsp/" .. server .. ".lua").before_init(params, config)
    assert(vim.deep_equal(config.settings, { retained = true }), "missing packages must not change settings")
    assert(vim.deep_equal(params.initializationOptions, { retained = true }), "missing SDK must remain optional")
  end
end)
vim.env.PATH, vim.env.MASON, vim.g.is_nixos = old_path, old_mason, old_nixos
vim.fn.delete(root, "rf")
assert(ok, err)
print("lsp resolution: PASS")
