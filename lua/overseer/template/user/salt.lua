-- Explicit development tasks only: no state.apply, production config, credentials,
-- sudo, or restart_on_save. Rendering/test=True alone is not a security sandbox.
return {
  cache_key = function(opts)
    return opts.dir .. ":" .. vim.api.nvim_buf_get_name(0) .. ":" .. vim.bo.filetype
  end,
  generator = function(opts)
    local file = vim.api.nvim_buf_get_name(0)
    local root = vim.fs.root(file ~= "" and file or opts.dir, ".salt-lint")
    if not root then
      return {}
    end

    local tasks = {}
    local function add(name, args, desc, current_file)
      table.insert(tasks, {
        name = "Salt: " .. name,
        desc = desc,
        builder = function()
          if current_file then
            local buf = vim.fn.bufnr(file)
            assert(buf == -1 or not vim.bo[buf].modified, "Save the file before running this task")
          end
          return {
            cmd = "devenv",
            args = vim.list_extend({ "shell", "--" }, vim.deepcopy(args)),
            cwd = root,
            components = { "default" },
          }
        end,
      })
    end

    if file ~= "" and (vim.bo.filetype == "salt" or vim.bo.filetype == "sls") then
      add(
        "lint current SLS",
        { "salt-lint", "--nocolor", file },
        "Lint the saved SLS with the project's .salt-lint",
        true
      )
    elseif file ~= "" and vim.bo.filetype:match("^yaml") then
      add(
        "lint current YAML",
        { "yamllint", "--format", "parsable", file },
        "Lint saved plain YAML, never raw SLS templates",
        true
      )
    end

    -- These are the Salt checkout's existing synthetic-fixture safety checks.
    -- Do not offer arbitrary render targets: Jinja/Python renderers execute code.
    if vim.fn.filereadable(root .. "/tests/test_salt_compiler.py") == 1 then
      add(
        "render fixture",
        { "uv", "run", "--locked", "pytest", "-q", "tests/test_salt_compiler.py", "-k", "renders" },
        "Render only the allowlisted WRF fixture in private temporary roots"
      )
      add(
        "compile fixture",
        { "uv", "run", "--locked", "pytest", "-q", "tests/test_salt_compiler.py", "-k", "compiles" },
        "Compile only the allowlisted WRF fixture; no state application"
      )
      add(
        "behavioral tests",
        { "uv", "run", "--locked", "pytest", "-q" },
        "Run the checkout's local synthetic-fixture tests"
      )
    end
    if vim.fn.filereadable(root .. "/lab/test.nix") == 1 then
      -- This task already invokes devenv; do not wrap it in another shell.
      table.insert(tasks, {
        name = "Salt: isolated VM integration",
        desc = "Build outputs.lab: air-gapped disposable guest, synthetic data and guest-only disks (needs virtualization)",
        builder = function()
          return {
            cmd = "devenv",
            args = { "build", "outputs.lab" },
            cwd = root,
            components = { "default" },
          }
        end,
      })
    end
    return tasks
  end,
}
