local fn = vim.fn
--- Check if a directory exists in this path
function IsDir(path)
  -- "/" works on both Unix and Windows
  return Exists(path .. "/")
end

function Capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

--- Check if a file or directory exists in this path
function Exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

ReloadConfig = function ()
  vim.cmd("source ~/.config/nvim/init.lua")
  vim.cmd(":PackerSync")
end

-- print stuff
P = function (v)
  print(vim.inspect(v))
  return v
end

-- misc
Pyflyby = function ()
  local cmd = "!tidy-imports --quiet --black --replace-star-imports --action REPLACE " ..
    fn.expand("%")
  vim.cmd(cmd)
end

Get_python_venv = function ()
  local lsputil = require("lspconfig/util")
  fn.system("pyenv init")
  fn.system("pyenv init -")

  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV
  end

  local match = fn.glob(lsputil.path.join(fn.getcwd(), "Pipfile"))
  if match ~= "" then
    return fn.trim(fn.system("PIPENV_PIPFILE=" .. match .. " pipenv --venv"))
  end

  match = fn.glob(lsputil.path.join(fn.getcwd(), "poetry.lock"))
  if match ~= "" then
    return fn.trim(fn.system("poetry env info -p"))
  end
  match = fn.glob(lsputil.path.join(fn.getcwd(), ".python_version"))
  if match ~= "" then
    return fn.trim(fn.system("pyenv prefix"))
  end
end
