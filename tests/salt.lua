-- nvim --headless -u NONE -l tests/salt.lua
local config = vim.fn.getcwd()
local salt_spec
for _, spec in ipairs(dofile("lua/plugins/lang.lua")) do
  if spec[1] == "benatouba/salt-vim" then
    salt_spec = spec
  end
end
assert(salt_spec and salt_spec.lazy == false)
local salt_dir = vim.fn.stdpath("data") .. "/lazy/salt-vim"
assert(vim.fn.filereadable(salt_dir .. "/syntax/salt.vim") == 1, "Installed salt-vim is missing")
-- The machine's config path may already be a symlink to this checkout.
-- Avoid discovering every template twice when adding the checkout explicitly.
vim.opt.rtp:remove(vim.fn.stdpath("config"))
vim.opt.rtp:remove(vim.fn.stdpath("config") .. "/after")
vim.opt.rtp:prepend(config)
vim.opt.rtp:append(config .. "/after")
vim.opt.rtp:prepend(salt_dir)
for _, plugin in ipairs({ "conform.nvim", "nvim-lint", "nvim-treesitter", "LuaSnip", "overseer.nvim" }) do
  vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/" .. plugin)
end
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path
local root = vim.fn.tempname()
local start = vim.treesitter.start
local ok, err = pcall(function()
  vim.fn.mkdir(root .. "/states", "p")
  vim.fn.mkdir(root .. "/.devenv/profile/bin", "p")
  vim.fn.mkdir(root .. "/tests", "p")
  vim.fn.mkdir(root .. "/lab", "p")
  vim.fn.writefile({ "skip_list: []" }, root .. "/.salt-lint")
  vim.fn.writefile({}, root .. "/tests/test_salt_compiler.py")
  vim.fn.writefile({}, root .. "/lab/test.nix")
  for _, bin in ipairs({ "salt-lint", "yamllint", "yamlfmt" }) do
    local path = root .. "/.devenv/profile/bin/" .. bin
    vim.fn.writefile({ "#!/bin/sh", "exit 0" }, path)
    vim.fn.setfperm(path, "rwx------")
  end
  local file = root .. "/states/example.sls"
  vim.fn.writefile({
    "{% if grains.get('os_family') == 'Debian' %}",
    "example:",
    "  pkg.installed:",
    "    - name: \"{{ pillar.get('package', 'example') }}\"",
    "{# a comment #}",
    "{% endif %}",
  }, file)

  vim.cmd("filetype plugin indent on")
  vim.cmd("syntax on")
  require("config.autocmds")
  local treesitter = dofile("lua/plugins/core/treesitter.lua")[1]
  treesitter.config(nil, treesitter.opts)
  local salt_parser_attempted = false
  vim.treesitter.start = function(buf)
    salt_parser_attempted = salt_parser_attempted or vim.bo[buf].filetype == "salt" or vim.bo[buf].filetype == "sls"
    error("Simulate an unavailable parser")
  end
  vim.cmd.edit(vim.fn.fnameescape(file))
  assert(vim.bo.filetype == "salt")
  assert(not salt_parser_attempted, "Salt must not start a YAML-only parser")
  assert(vim.bo.expandtab and vim.bo.shiftwidth == 2 and vim.bo.softtabstop == 2)
  assert(vim.bo.commentstring == "# %s" and vim.bo.indentexpr == "")
  assert(vim.bo.autoindent and not vim.bo.smartindent)
  assert(vim.wo.foldmethod == "indent")
  assert(vim.b.current_syntax == "salt")
  assert(vim.fn.globpath(config, "syntax/sls.vim") == "", "Syntax must belong to salt-vim")
  local function syntax(line, col)
    return vim.fn.synIDattr(vim.fn.synID(line, col, 1), "name")
  end
  assert(syntax(1, 4) == "jinjaStatement", syntax(1, 4))
  assert(syntax(2, 1):match("^yaml"), syntax(2, 1))
  assert(syntax(4, 14) == "jinjaVarDelim", syntax(4, 14))
  assert(syntax(5, 5) == "jinjaComment", syntax(5, 5))

  local conform = require("conform")
  conform.setup(dofile("lua/plugins/core/formatting.lua")[1].opts)
  assert(#conform.list_formatters_for_buffer(0) == 0, "SLS must have no generic or YAML formatter")
  local before = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  conform.format({ timeout_ms = 1000 })
  assert(vim.deep_equal(before, vim.api.nvim_buf_get_lines(0, 0, -1, false)))
  assert(conform.formatters_by_ft["*"] == nil, "No codespell wildcard")
  assert(conform.formatters_by_ft.salt.lsp_format == "never")

  local lint = require("lint")
  local spec = dofile("lua/plugins/core/linting.lua")[1]
  spec.config(nil, spec.opts)
  assert(vim.deep_equal(lint.linters_by_ft.salt, { "saltlint" }))
  assert(vim.deep_equal(lint.linters_by_ft.yaml, { "yamllint" }))
  assert(lint.linters.saltlint.cmd() == root .. "/.devenv/profile/bin/salt-lint")
  local invocation
  lint.try_lint = function(_, opts)
    invocation = opts
  end
  vim.api.nvim_exec_autocmds("InsertLeave", { buffer = 0 })
  assert(invocation.cwd == root, "Lint cwd must find the root .salt-lint")

  local provider = require("overseer.template.user.salt")
  local tasks = provider.generator({ dir = config })
  assert(#tasks == 5, "SLS lint, render, compile, behavior, VM tasks")
  for _, template in ipairs(tasks) do
    local task = template.builder()
    assert(task.cwd == root and task.cmd == "devenv")
    assert(not vim.tbl_contains(task.args, "state.apply"))
    assert(vim.deep_equal(task.components, { "default" }), "Tasks must not restart on save")
  end
  require("overseer").setup({})
  local discovered, discovery_report
  require("overseer.template").list({ dir = root, filetype = "salt" }, function(templates, report)
    discovery_report = report
    discovered = vim.tbl_filter(function(template)
      return template.name:match("^Salt: ") ~= nil
    end, templates)
  end)
  assert(
    vim.wait(10000, function()
      return discovered ~= nil
    end),
    "Overseer provider discovery timed out"
  )
  assert(
    #discovered == 5,
    "Salt tasks must be discoverable without manual registration: " .. vim.inspect(discovery_report)
  )
  vim.bo.modified = true
  assert(not pcall(tasks[1].builder), "File lint must reject unsaved changes")
  vim.bo.modified = false

  local manifest = vim.json.decode(table.concat(vim.fn.readfile("snippets/package.json"), "\n"))
  local registered = false
  for _, entry in ipairs(manifest.contributes.snippets) do
    registered = registered or (vim.tbl_contains(entry.language, "salt") and entry.path == "./salt.json")
  end
  assert(registered, "Salt snippets must be registered")
  local snippets = vim.json.decode(table.concat(vim.fn.readfile("snippets/salt.json"), "\n"))
  for _, snippet in pairs(snippets) do
    assert(require("luasnip.util.parser").parse_snippet(snippet.prefix, table.concat(snippet.body, "\n")))
  end

  vim.bo.filetype = "sls"
  assert(vim.bo.indentexpr == "" and not vim.bo.smartindent)
  assert(vim.wo.foldmethod == "indent")
  assert(#conform.list_formatters_for_buffer(0) == 0, "Legacy SLS must remain protected")
  assert(vim.deep_equal(lint.linters_by_ft.sls, { "saltlint" }))
  assert(provider.generator({ dir = config })[1].name == "Salt: lint current SLS")
  assert(not salt_parser_attempted, "Legacy SLS must not start a YAML-only parser")

  vim.bo.filetype = "yaml"
  assert(vim.deep_equal(conform.list_formatters_for_buffer(0), { "yamlfmt" }))
  assert(
    conform.formatters.yamlfmt.command(nil, { dirname = root .. "/states" }) == root .. "/.devenv/profile/bin/yamlfmt"
  )
  assert(provider.generator({ dir = config })[1].name == "Salt: lint current YAML")
  -- A failed parser must leave existing indentation intact, not set TS indent.
  vim.bo.indentexpr = ""
  vim.api.nvim_exec_autocmds("FileType", { pattern = "unavailable_test_parser" })
  assert(vim.bo.indentexpr == "")
  local python = root .. "/states/python.sls"
  vim.fn.writefile({ "#!py|yaml", "def run():", "    return {}" }, python)
  vim.cmd.edit(vim.fn.fnameescape(python))
  assert(vim.bo.filetype == "python", "salt-vim must own Python renderer detection")
  print("Salt syntax, snippets, tools, formatting and tasks: PASS")
end)
vim.treesitter.start = start
vim.cmd("bwipeout!")
vim.fn.delete(root, "rf")
assert(ok, err)
