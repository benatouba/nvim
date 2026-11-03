local project = require("util.task_project")

return {
  generator = function(opts)
    local ret = {}
    local function add(name, root, cmd, desc, tags)
      table.insert(ret, project.template(name, root, cmd, desc, tags))
    end
    local lock = project.find(opts.dir, "uv.lock")
    if lock then
      local root = vim.fs.dirname(lock)
      local pyproject = root .. "/pyproject.toml"
      local text = vim.fn.filereadable(pyproject) == 1 and table.concat(vim.fn.readfile(pyproject), "\n") or ""
      -- Offer known tools only when mentioned in the project or already provisioned.
      -- This is capability detection, not a general-purpose TOML/script parser.
      local function has(tool)
        return text:find("%f[%w_]" .. tool .. "%f[^%w_-]") or project.binary(root, tool)
      end
      if has("pytest") then
        add("Python: tests", root, { "uv", "run", "--locked", "pytest" }, nil, { "CHECK" })
      end
      if has("ruff") then
        add("Python: lint", root, { "uv", "run", "--locked", "ruff", "check", "." }, nil, { "CHECK" })
        add(
          "Python: format check",
          root,
          { "uv", "run", "--locked", "ruff", "format", "--check", "." },
          nil,
          { "CHECK" }
        )
      end
      for _, tool in ipairs({ "mypy", "ty" }) do
        if has(tool) then
          local args = tool == "ty" and { "ty", "check" } or { "mypy", "." }
          add("Python: " .. tool, root, vim.list_extend({ "uv", "run", "--locked" }, args), nil, { "CHECK" })
        end
      end
      local file = vim.api.nvim_buf_get_name(0)
      if opts.filetype == "python" and vim.startswith(file, root .. "/") then
        local template = project.template("Python: run current file", root, { "uv", "run", "--locked", "python", file })
        local builder = template.builder
        template.builder = function()
          local buf = vim.fn.bufnr(file)
          assert(buf == -1 or not vim.bo[buf].modified, "Save the file before running it")
          return builder()
        end
        table.insert(ret, template)
      end
    end

    local style = project.find(opts.dir, { ".stylua.toml", "stylua.toml" })
    if style then
      add("Lua: style check", vim.fs.dirname(style), { "stylua", "--check", "." }, nil, { "CHECK" })
    end
    for marker, cmd in pairs({
      [".luacheckrc"] = { "luacheck", "." },
      ["selene.toml"] = { "selene", "." },
      [".busted"] = { "busted" },
    }) do
      local file = project.find(opts.dir, marker)
      if file then
        add("Lua: " .. cmd[1], vim.fs.dirname(file), cmd, nil, { "CHECK" })
      end
    end
    local init = project.find(opts.dir, "init.lua")
    if init and vim.fn.isdirectory(vim.fs.dirname(init) .. "/lua/config") == 1 then
      local root = vim.fs.dirname(init)
      add("Neovim: style check", root, { "stylua", "--check", "lua", "after", "init.lua" }, nil, { "CHECK" })
      add("Neovim: startup check", root, { "nvim", "--headless", "-u", init, "+qa" }, nil, { "CHECK" })
      for _, file in ipairs(vim.fn.glob(root .. "/tests/*.lua", false, true)) do
        local first = table.concat(vim.fn.readfile(file, "", 3), "\n")
        if first:find("-u NONE", 1, true) then
          add(
            "Neovim: " .. vim.fs.basename(file),
            root,
            { "nvim", "--headless", "-u", "NONE", "-l", file },
            nil,
            { "CHECK" }
          )
        end
      end
    end

    local flake = project.find(opts.dir, "flake.nix")
    if flake then
      local root = vim.fs.dirname(flake)
      add(
        "Nix: evaluate checks",
        root,
        { "nix", "flake", "check", "--no-build", "--no-update-lock-file", root },
        nil,
        { "CHECK" }
      )
      add(
        "Nix: build checks",
        root,
        { "nix", "flake", "check", "--no-update-lock-file", root },
        nil,
        { "CHECK", "BUILD" }
      )
      table.insert(ret, {
        name = "Nix: build named output",
        desc = "Build only; specify an output attribute (no activation or lock update)",
        tags = { "BUILD" },
        params = { output = { type = "string", desc = "Flake output attribute", optional = false } },
        builder = function(params)
          assert(params.output and params.output ~= "", "A flake output attribute is required")
          return {
            cmd = project.command(root, { "nix", "build", "--no-update-lock-file", root .. "#" .. params.output }),
            cwd = root,
            components = { "default" },
          }
        end,
      })
    end
    return ret
  end,
}
