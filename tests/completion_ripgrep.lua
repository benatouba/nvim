-- Run with installed completion plugins: nvim --headless -u NONE -l tests/completion_ripgrep.lua
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path
local plugins = vim.fn.stdpath("data") .. "/lazy/"
vim.opt.rtp:prepend(plugins .. "blink.cmp")
vim.opt.rtp:prepend(plugins .. "blink-ripgrep.nvim")
local opts = require("plugins.configs.blink").opts
local provider = opts.sources.providers.ripgrep
local root = vim.fn.tempname()
local old_cwd = vim.fn.getcwd()
local ok, err = pcall(function()
  -- Use Blink's real provider list with a search that has not responded yet.
  local respond, cancelled, emissions = nil, false, {}
  local source = {
    id = "ripgrep",
    config = require("blink.cmp.sources.lib.provider.config").new(provider),
    module = {
      get_completions = function(_, _, callback)
        respond = callback
        return function()
          cancelled = true
        end
      end,
    },
    transform_items = function(_, ctx, items)
      return provider.transform_items(ctx, items)
    end,
  }
  local list = require("blink.cmp.sources.lib.provider.list").new(source, { cursor = { 1, 6 } }, function(items)
    emissions[#emissions + 1] = items
  end, { async_initial_items = {} })
  assert(#emissions == 1, "ripgrep must release the completion menu before its search finishes")
  respond({ items = { { label = "needleSmall" } } })
  assert(#emissions == 2 and emissions[2][1].label == "needleSmall", "late results must still appear")
  list:destroy()
  assert(cancelled, "search cancellation must remain available")
  print("Ripgrep does not delay other completion sources: PASS")

  vim.fn.mkdir(root .. "/project/.git", "p")
  vim.fn.mkdir(root .. "/outside", "p")
  vim.fn.writefile({ "needleSmall" }, root .. "/project/small.txt")
  vim.fn.writefile({ "needleLarge " .. string.rep("x", 300 * 1024) }, root .. "/project/large.txt")
  local repeated = {}
  for _ = 1, 30 do
    repeated[#repeated + 1] = "needleRepeated"
  end
  vim.fn.writefile(repeated, root .. "/project/repeated.txt")
  vim.api.nvim_buf_set_name(0, root .. "/project/small.txt")
  local rg = require("blink-ripgrep").new(provider.opts)
  local commands = require("blink-ripgrep.backends.ripgrep.ripgrep_command")
  local command = assert(commands.get_command("needle", rg.config))
  assert(command.root == root .. "/project", "search must follow buffer project, not session cwd")
  local result = vim.system(command.command, { text = true }):wait(5000)
  assert(result.code == 0, result.stderr)
  local matches = {}
  for line in result.stdout:gmatch("[^\n]+") do
    local event = vim.json.decode(line)
    if event.type == "match" then
      local file = vim.fs.basename(event.data.path.text)
      matches[file] = (matches[file] or 0) + 1
    end
  end
  assert(matches["small.txt"] == 1, "normal project words must remain searchable")
  assert(not matches["large.txt"], "large files must be skipped")
  assert(matches["repeated.txt"] == 20, "matching lines per file must be bounded")

  vim.cmd.cd(vim.fn.fnameescape(root .. "/project"))
  vim.api.nvim_buf_set_name(0, root .. "/outside/file.txt")
  assert(commands.get_command("needle", rg.config) == nil, "rootless buffers must not search an unrelated cwd")
  assert(vim.tbl_contains(opts.sources.default({}), "ripgrep"), "keep automatic ripgrep completion")
  assert(vim.tbl_contains(opts.sources.per_filetype.org, "ripgrep"), "keep ripgrep in Org")
  print("Ripgrep project scope, file-size limit and match limit: PASS")
end)
vim.cmd.cd(vim.fn.fnameescape(old_cwd))
vim.fn.delete(root, "rf")
assert(ok, err)
