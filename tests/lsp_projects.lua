-- Integration check with the real config and an installed Lua language server:
-- nvim --headless -u init.lua -c 'luafile tests/lsp_projects.lua'
local repo = vim.uv.fs_realpath(vim.fn.getcwd())
local root = vim.fn.tempname()
local old_path, old_cwd = vim.env.PATH, vim.fn.getcwd()
local binary = vim.fn.exepath("lua-language-server")
if binary == "" then
  binary = repo .. "/.devenv/profile/bin/lua-language-server"
end
local function edit(path)
  vim.cmd.edit(vim.fn.fnameescape(path))
  local client
  assert(
    vim.wait(5000, function()
      for _, candidate in ipairs(vim.lsp.get_clients({ bufnr = 0, name = "lua_ls" })) do
        if candidate.initialized then
          client = candidate
          return true
        end
      end
      return false
    end, 50),
    "lua_ls did not attach to " .. path .. " from an unrelated project without Lua on PATH"
  )
  return client
end
local ok, err = pcall(function()
  assert(vim.fn.executable(binary) == 1, "provision lua-language-server before running this integration check")
  assert(vim.fn.executable(repo .. "/.devenv/profile/bin/lua-language-server") == 1, "provision this config's devenv")
  local unrelated, second = root .. "/unrelated", root .. "/second"
  vim.fn.mkdir(unrelated .. "/.git", "p")
  vim.fn.mkdir(second .. "/.git", "p")
  vim.fn.mkdir(second .. "/.devenv/profile/bin", "p")
  assert(vim.uv.fs_symlink(binary, second .. "/.devenv/profile/bin/lua-language-server"))
  vim.fn.writefile({ "An unrelated non-Lua project" }, unrelated .. "/README.txt")
  vim.fn.writefile({ "local value = 1" }, second .. "/sample.lua")

  -- Model Neovim launched from an environment which does not provision Lua.
  local path = vim.tbl_filter(function(dir)
    return vim.fn.executable(dir .. "/lua-language-server") ~= 1
  end, vim.split(old_path or "", ":", { trimempty = true }))
  vim.env.PATH = table.concat(path, ":")
  assert(vim.fn.executable("lua-language-server") == 0, "test must exclude Lua from PATH")
  vim.cmd.cd(vim.fn.fnameescape(unrelated))
  vim.cmd.edit(vim.fn.fnameescape(unrelated .. "/README.txt"))

  local config_file = repo .. "/lua/config/options.lua"
  local first = edit(config_file)
  assert(vim.uv.fs_realpath(first.config.root_dir) == repo, "config file must use its own project root")
  print("Lua config opened from non-Lua project: PASS")

  local other = edit(second .. "/sample.lua")
  assert(other.id ~= first.id and other.config.root_dir == second, "different projects must get distinct clients")
  vim.cmd.cd(vim.fn.fnameescape(second))
  assert(edit(config_file).id == first.id, "returning to the config must reuse its own client")
  print("Lua project switching and client reuse: PASS")
end)
for _, client in ipairs(vim.lsp.get_clients({ name = "lua_ls" })) do
  client:stop(true)
end
vim.env.PATH = old_path
vim.cmd.cd(vim.fn.fnameescape(old_cwd))
vim.fn.delete(root, "rf")
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd.cquit()
end
vim.cmd.qa({ bang = true })
