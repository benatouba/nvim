-- Shared task context. Nothing here evaluates a project until discovery is requested.
local M = {}
local markers = { "devenv.nix", "flake.nix", "pyproject.toml", "package.json", "justfile", "Makefile" }

function M.dir()
  local file = vim.api.nvim_buf_get_name(0)
  return vim.bo.buftype == "" and file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
end

function M.find(dir, names)
  local git = vim.fs.root(dir, ".git")
  return vim.fs.find(names, {
    path = dir,
    upward = true,
    type = "file",
    stop = git and vim.fs.dirname(git) or nil,
  })[1]
end

function M.root(dir)
  local marker = M.find(dir, markers)
  return vim.fs.root(dir, ".git") or (marker and vim.fs.dirname(marker)) or dir
end

function M.binary(dir, bin)
  for _, subdir in ipairs({ "node_modules/.bin", ".venv/bin", ".devenv/profile/bin" }) do
    -- Search the tool directories, not arbitrary source files with this name.
    -- The upward walk also supports nested packages inside a devenv checkout.
    local current = dir
    local boundary = vim.fs.root(dir, ".git")
    while current do
      local path = current .. "/" .. subdir .. "/" .. bin
      if vim.fn.executable(path) == 1 then
        return path
      end
      if current == boundary then
        break
      end
      current = vim.fs.dirname(current) ~= current and vim.fs.dirname(current) or nil
    end
  end
  local path = vim.fn.exepath(bin)
  return path ~= "" and path or nil
end

function M.command(dir, argv, direct)
  local cmd = vim.deepcopy(argv)
  local devenv = M.find(dir, "devenv.nix")
  if not direct and devenv and cmd[1] ~= "devenv" and cmd[1] ~= "nix" then
    -- Keep the task cwd (e.g. a workspace package), while selecting its devenv.
    local root = vim.fs.dirname(devenv)
    return {
      M.binary(root, "devenv") or "devenv",
      "--no-tui",
      "--from",
      "path:" .. root,
      "shell",
      "--",
      unpack(cmd),
    }
  end
  cmd[1] = M.binary(dir, cmd[1]) or cmd[1]
  return cmd
end

function M.system(dir, argv, callback, opts)
  opts = opts or {}
  local framed = not opts.direct and M.find(dir, "devenv.nix") and argv[1] ~= "devenv" and argv[1] ~= "nix"
  local marker = "\030OVERSEER_DISCOVERY\030\n"
  local args = argv
  if framed then
    -- enterShell can print banners. Frame stdout after setup, preserving argv;
    -- never interpolate recipe names/paths into shell source.
    args = { "sh", "-c", [[printf '\036OVERSEER_DISCOVERY\036\n'; exec "$@"]], "overseer-discovery", unpack(argv) }
  end
  local done = vim.schedule_wrap(function(out)
    if framed then
      local _, last = (out.stdout or ""):find(marker, 1, true)
      out.stdout = last and out.stdout:sub(last + 1) or ""
      if not last and out.code == 0 then
        out.code = -1
      end
    end
    callback(out)
  end)
  local ok = pcall(require("overseer").builtin.system, M.command(dir, args, opts.direct), {
    cwd = dir,
    text = true,
    timeout = 120000,
    env = opts.env,
  }, done)
  if not ok then
    done({ code = -1, stdout = "" })
  end
end

function M.json(dir, argv, callback)
  M.system(dir, argv, function(out)
    if out.code ~= 0 then
      -- Do not echo evaluation output: it may contain private project metadata.
      callback(
        nil,
        argv[1] .. " discovery failed (exit " .. tostring(out.code) .. "); run it in a terminal for details"
      )
      return
    end
    local ok, data = pcall(vim.json.decode, out.stdout or "", { luanil = { object = true } })
    if not ok or type(data) ~= "table" then
      callback(nil, argv[1] .. " discovery returned invalid JSON")
    else
      callback(data)
    end
  end, { direct = true })
end

function M.tags(name)
  local command = name:lower():match("([^ /]+)$") or name:lower()
  local found = {}
  for word in command:gmatch("[^:]+") do
    if word == "build" or word == "all" or word:match("^build[-_]") then
      found.BUILD = true
    end
    if word:match("check") or word:match("^test") or word:match("^lint") or word == "verify" then
      found.CHECK = true
    end
  end
  return vim.tbl_keys(found)
end

function M.template(name, dir, argv, desc, tags)
  return {
    name = name,
    desc = desc,
    tags = tags or M.tags(argv[#argv]),
    builder = function()
      return { cmd = M.command(dir, argv), cwd = dir, components = { "default" } }
    end,
  }
end

return M
