-- Installed plugins required: nvim --headless -u NONE -l tests/groups.lua
-- Each case gets its own config/lockfile; nothing is installed, updated or built.
local repo = vim.fn.getcwd()

local function child(case)
  local errors, warnings = {}, {}
  vim.notify = function(message, level)
    if level == vim.log.levels.ERROR then
      errors[#errors + 1] = message
    elseif level == vim.log.levels.WARN then
      warnings[#warnings + 1] = message
    end
  end
  require("config.options")
  vim.g.is_nixos = not case.non_nix
  if case.lazydev_disabled then
    vim.g.lazydev_enabled = false
  end
  -- Test configuration, not the host's language-server processes.
  vim.lsp.enable = function() end
  local spec = require("config.groups").spec()
  local selected = {}
  for i = 2, #spec do
    selected[#selected + 1] = spec[i].import:match("plugins%.(.+)")
  end
  assert(vim.deep_equal(selected, case.expected), vim.inspect({ selected = selected, expected = case.expected }))
  vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
  vim.go.loadplugins = true -- -u NONE disables plugin loading
  require("lazy").setup({
    spec = spec,
    defaults = { lazy = true },
    install = { missing = false },
    checker = { enabled = false },
    change_detection = { enabled = false },
    rocks = { enabled = false },
  })
  require("config.keymaps")
  local plugins = require("lazy.core.config").plugins
  if case.non_nix then
    -- Platform-gated Mason adapters need not be installed on this NixOS host.
    -- Inspect their resolved options without triggering their VeryLazy handlers.
    for _, plugin in pairs(plugins) do
      if not plugin._.installed then
        require("lazy.core.handler").disable(plugin)
      end
    end
  end
  local function has_group(name)
    return vim.tbl_contains(selected, name)
  end
  local function opts(name)
    return require("lazy.core.plugin").values(assert(plugins[name], name), "opts", false)
  end
  for name in vim.fs.dir(repo .. "/lua/plugins") do
    if name:match("%.lua$") then
      local group = name:gsub("%.lua$", "")
      local imported = vim.tbl_contains(require("lazy.core.config").spec.modules, "plugins." .. group)
      assert(imported == has_group(group), group .. " import leaked")
    end
  end
  local providers = {
    lazydev = "lsp",
    jupynium = "notebooks",
    orgmode = "notes",
    dadbod = "databases",
    sonicpi = "lang",
    dap = "dap",
  }
  local blink = opts("blink.cmp")
  for id, group in pairs(providers) do
    local enabled = has_group(group) and not (id == "lazydev" and case.lazydev_disabled)
    assert((blink.sources.providers[id] ~= nil) == enabled, id .. " source leaked or missing")
    if enabled then
      -- Exercise real source constructors, not just the options table.
      require("blink.cmp.sources.lib").get_provider_by_id(id)
    end
  end
  for _, ft in ipairs({ "lua", "python", "org", "sql", "sonicpi", "dap-repl" }) do
    local sources = blink.sources.per_filetype[ft] or {}
    if type(sources) == "function" then
      sources = sources()
    end
    for _, id in ipairs(sources) do
      assert(not providers[id] or has_group(providers[id]), ft .. " selects excluded source " .. id)
    end
  end
  require("lazy").load({ plugins = { "lualine.nvim", "telescope.nvim", "oil.nvim", "which-key.nvim" } })
  require("lualine").refresh()
  require("telescope.builtin").buffers()
  vim.cmd("stopinsert")
  vim.cmd("close")
  assert((opts("oil.nvim").keymaps.gs ~= nil) == has_group("editor"), "Oil search integration leaked")
  assert((opts("telescope.nvim").defaults.mappings.i["<c-t>"] ~= nil) == has_group("tools"))
  assert((plugins["copilot-lualine"] ~= nil) == (has_group("ai") and vim.fn.executable("node") == 1))
  assert((plugins["telescope-fzf-native.nvim"] ~= nil) == has_group("provisioning"))
  assert(opts("nvim-treesitter").auto_install == has_group("provisioning"))
  assert((plugins["nvim-treesitter"].build ~= nil) == has_group("provisioning"))
  assert((plugins.LuaSnip.build ~= nil) == (has_group("provisioning") and case.non_nix == true))
  -- Trigger an unavailable parser without downloading or compiling anything.
  local install = require("nvim-treesitter.install")
  local ts_config = require("nvim-treesitter.config")
  local original_install, original_available = install.install, ts_config.get_available
  local installed = false
  ts_config.get_available = function()
    return { "ben_group_fixture" }
  end
  install.install = function(languages)
    assert(vim.deep_equal(languages, { "ben_group_fixture" }))
    installed = true
  end
  -- Reset the parser-availability cache populated by earlier picker buffers.
  plugins["nvim-treesitter"].config(plugins["nvim-treesitter"], opts("nvim-treesitter"))
  vim.api.nvim_exec_autocmds("FileType", { pattern = "ben_group_fixture" })
  install.install, ts_config.get_available = original_install, original_available
  assert(installed == has_group("provisioning"), "Parser installation policy leaked")
  if case.non_nix then
    local servers = opts("mason-lspconfig.nvim").ensure_installed
    assert((#servers > 0) == has_group("provisioning"), "Mason server installation leaked")
    if has_group("dap") then
      assert((#opts("mason-nvim-dap.nvim").ensure_installed > 0) == has_group("provisioning"))
    else
      assert(not plugins["mason-nvim-dap.nvim"], "Provisioning pulled in DAP")
    end
  end
  local terminal = vim.fn.maparg("<C-l>", "t", false, true)
  assert(terminal.rhs:find("bnext", 1, true), "Terminal navigation must work without Barbar")
  vim.wait(50, function()
    return false
  end)
  assert(#errors == 0, table.concat(errors, "\n"))
  if case.unknown then
    assert(
      vim.iter(warnings):any(function(message)
        return message:find("Unknown plugin group: typo", 1, true) ~= nil
      end),
      "Unknown group must warn"
    )
  end
end

if arg[1] == "--child" then
  child(vim.json.decode(arg[2]))
  return
end

local all = {}
for name, kind in vim.fs.dir(repo .. "/lua/plugins") do
  if kind == "file" and name:match("%.lua$") then
    all[#all + 1] = name:gsub("%.lua$", "")
  end
end
table.sort(all)
local cases = {
  { name = "default", expected = all },
  { name = "empty environment", env = "", expected = {} },
  { name = "core alias", env = "core", expected = {} },
  { name = "duplicates and whitespace", env = " lang,git git,core ", expected = { "git", "lang" } },
  { name = "unknown", env = "git,typo", expected = { "git" }, unknown = true },
  { name = "local file", file = { "git", "lang" }, expected = { "git", "lang" } },
  { name = "empty local file", file = {}, expected = {} },
  { name = "environment wins", env = "git", file = { "lang" }, expected = { "git" } },
  { name = "empty environment wins", env = "", file = { "lang" }, expected = {} },
  { name = "non-Nix core", env = "", expected = {}, non_nix = true },
  { name = "non-Nix provisioning", env = "provisioning", expected = { "provisioning" }, non_nix = true },
  { name = "non-Nix DAP", env = "dap", expected = { "dap" }, non_nix = true },
  { name = "non-Nix DAP provisioning", env = "dap,provisioning", expected = { "dap", "provisioning" }, non_nix = true },
  { name = "disabled LazyDev", env = "lsp", expected = { "lsp" }, lazydev_disabled = true },
}
for _, group in ipairs(all) do
  cases[#cases + 1] = { name = "group " .. group, env = group, expected = { group } }
end
local root = "/tmp/opencode/nvim-groups-" .. vim.uv.hrtime()
local ok, err = xpcall(function()
  for i, case in ipairs(cases) do
    local home = root .. "/" .. i
    local config = home .. "/nvim"
    vim.fn.mkdir(config, "p")
    for _, name in ipairs({ "lua", "after", "snippets" }) do
      assert(vim.uv.fs_symlink(repo .. "/" .. name, config .. "/" .. name))
    end
    vim.fn.writefile(vim.fn.readfile(repo .. "/lazy-lock.json"), config .. "/lazy-lock.json")
    if case.file then
      vim.fn.writefile(case.file, config .. "/groups.local")
    end
    local env = vim.fn.environ()
    env.XDG_CONFIG_HOME = home
    env.NVIM_GROUPS = case.env
    local result = vim
      .system({
        vim.v.progpath,
        "--headless",
        "-u",
        "NONE",
        "-l",
        repo .. "/tests/groups.lua",
        "--child",
        vim.json.encode(case),
      }, { env = env, clear_env = true, text = true })
      :wait(30000)
    assert(result.code == 0, case.name .. ": " .. (result.stderr or "") .. (result.stdout or ""))
    print(case.name .. ": PASS")
  end
end, debug.traceback)
vim.fn.delete(root, "rf")
assert(ok, err)
