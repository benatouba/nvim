local M = {}
local fn = vim.fn
M.add_autocommands = function (definitions)
  -- Create autocommand groups based on the passed definitions
  -- The key will be the name of the group, and each definition
  -- within the group should have:
  --    1. Trigger
  --    2. Pattern
  --    3. Text
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_create_augroup(group_name, {})
    for _, def in pairs(definition) do
      vim.api.nvim_create_autocmd(def[1], {
        group = group_name,
        pattern = def[2],
        command = def[3],
      })
    end
  end
end

M.register_keys = function (keys)
  local isOk, which_key = pcall(require, "which-key")
  if not isOk then
    return
  end
  which_key.register(keys)
end

function M.file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function M.check_lsp_client_active(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do
    if client.name == name then
      return true
    end
  end
  return false
end

M.get_relative_fname = function ()
  local fname = fn.expand("%:p")
  return fname:gsub(fn.getcwd() .. "/", "")
end

M.get_relative_gitpath = function ()
  local fpath = fn.expand("%:h")
  local fname = fn.expand("%:t")
  local gitpath = fn.systemlist("git rev-parse --show-toplevel")[1]
  local relative_gitpath = fpath:gsub(gitpath, "") .. "/" .. fname

  return relative_gitpath
end

M.toggle_quicklist = function ()
  if fn.empty(fn.filter(fn.getwininfo(), "v:val.quickfix")) == 1 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end

M.toggle_loclist = function ()
  if fn.empty(fn.filter(fn.getwininfo(), "v:val.loclist")) == 1 then
    vim.cmd("lopen")
  else
    vim.cmd("lclose")
  end
end

M.starts_with = function (str, start)
  return str:sub(1, #start) == start
end

M.ends_with = function (str, ending)
  return ending == "" or str:sub(- #ending) == ending
end

M.split = function (s, delimiter)
  local result = {}
  for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end

  return result
end

M.handle_job_data = function (data)
  if not data then
    return nil
  end
  if data[#data] == "" then
    table.remove(data, #data)
  end
  if #data < 1 then
    return nil
  end
  return data
end

M.jobstart = function (cmd, on_finish)
  local has_error = false
  local lines = {}

  local function on_event(_, data, event)
    if event == "stdout" then
      data = M.handle_job_data(data)
      if not data then
        return
      end

      for i = 1, #data do
        table.insert(lines, data[i])
      end
    elseif event == "stderr" then
      data = M.handle_job_data(data)
      if not data then
        return
      end

      has_error = true
      local error_message = ""
      for _, line in ipairs(data) do
        error_message = error_message .. line
      end
      M.log("Error during running a job: " .. error_message)
    elseif event == "exit" then
      if not has_error then
        on_finish(lines)
      end
    end
  end

  fn.jobstart(cmd, {
    on_stderr = on_event,
    on_stdout = on_event,
    on_exit = on_event,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

M.remove_whitespaces = function(string)
  return string:gsub("%s+", "")
end

M.add_whitespaces = function(number)
  return string.rep(" ", number)
end

M.closeOtherBuffers = function()
  for _, e in ipairs(require("bufferline").get_elements().elements) do
    vim.schedule(function()
      if e.id == vim.api.nvim_get_current_buf() then
        return
      elseif pcall(require, 'mini.bufremove') then
        require('mini.bufremove').delete(e.id, false)
      else
        vim.cmd("bd " .. e.id)
      end
    end)
  end
end

return M
