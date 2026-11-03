-- Run with: nvim --headless -u NONE -l tests/lsp_launch.lua
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path
local resolve = require("lsp.resolve")
local python = require("util.python")
local old_cmd, old_python, old_start = resolve.cmd, python.executable, vim.lsp.rpc.start
local ok, err = pcall(function()
  resolve.cmd = function(_, bin)
    return { "/resolved/" .. bin, "--stdio" }
  end
  python.executable = function(_, bin)
    return "/python/" .. bin
  end
  local launches = {
    { resolve.rpc("html"), { "/resolved/html", "--stdio" } },
    { python.rpc("ruff"), { "/python/ruff", "server" } },
    { python.rpc("ty"), { "/python/ty", "server" } },
    { dofile("after/lsp/vtsls.lua").cmd, { "/resolved/vtsls", "--stdio" } },
    { dofile("after/lsp/vue_ls.lua").cmd, { "/resolved/vue-language-server", "--stdio" } },
    { dofile("after/lsp/lua_ls.lua").cmd, { "lua-language-server" } },
    { dofile("after/lsp/docker_language_server.lua").cmd, { "docker-language-server", "start", "--stdio" } },
  }
  for _, launch in ipairs(launches) do
    for _, config in ipairs({
      { root_dir = "/nonexistent/project" },
      { root_dir = "/nonexistent/project", cmd_cwd = "/override", cmd_env = { CHECK = "1" }, detached = false },
      { detached = true },
    }) do
      local dispatchers, transport = {}, {}
      vim.lsp.rpc.start = function(cmd, received, opts)
        assert(vim.deep_equal(cmd, launch[2]), "server arguments changed")
        assert(received == dispatchers, "dispatchers changed")
        assert(opts and opts.cwd == (config.cmd_cwd or config.root_dir), "missing process cwd")
        assert(opts.env == config.cmd_env, "missing process environment")
        assert(opts.detached == config.detached, "detached must preserve nil and false")
        return transport
      end
      assert(launch[1](dispatchers, config) == transport, "transport result changed")
    end
  end
  resolve.cmd = function() end
  vim.lsp.rpc.start = function(cmd)
    assert(vim.deep_equal(cmd, { "missing-server", "--stdio" }), "retain bare-command spawn fallback")
  end
  resolve.rpc("missing-server")({}, {})
  python.executable = function() end
  local available, message = pcall(python.rpc("ruff"), {}, {})
  assert(not available and tostring(message):find("provision it", 1, true), "retain Python provisioning error")
end)
resolve.cmd, python.executable, vim.lsp.rpc.start = old_cmd, old_python, old_start
assert(ok, err)
print("lsp launch: PASS")
