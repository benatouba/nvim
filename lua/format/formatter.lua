local status_ok, _ = pcall(require, "formatter")
if not status_ok then
  print('formatter.nvim not okay')
  return
end


vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.rs,*.py FormatWrite
augroup END
]], true)

local settings = {}

if O.jsts.formatter then
settings["jsts"] = {
        -- prettier
       function()
          return {
            exe = O.jsts.formatter,
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
            stdin = true
          }
        end
    }
end

if O.rust.formatter then
settings["rust"] = {
      -- Rustfmt
      function()
        return {
          exe = O.rust.formatter,
          args = {"--emit=stdout"},
          stdin = true
        }
      end
    }
end

if O.clang.formatter then
  settings["cpp"] = {
        -- clang-format
       function()
          return {
            exe = "clang-format",
            args = {},
            stdin = true,
            cwd = vim.fn.expand('%:p:h')  -- Run clang-format in cwd of the file.
          }
        end
    }
end

if O.python.formatter ~= '' then
  settings["python"] = {
        -- black or yapf
            function ()
                return {
                exe = O.python.formatter,
                args = {"--stdin"},
                stdin = true,
                    }
            end
        }
end

local M = {}

M.config = function ()
  require('formatter.config').set_defaults({
    logging = false,
    filetype = settings})
end

return M
