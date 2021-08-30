local status_ok, _ = pcall(require, "formatter")
if not status_ok then
    print('formatter.nvim not okay')
    return
end

vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.rs FormatWrite
augroup END
]], true)

local settings = {}

if O.jsts.format.exe ~= '' then
    settings["jsts"] = {
        -- prettier
        function()
            return {
                exe = O.jsts.formatter,
                args = {
                    "--stdin-filepath", vim.api.nvim_buf_get_name(0),
                    '--single-quote'
                },
                stdin = true
            }
        end
    }
end

if O.rust.format.exe ~= '' then
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

-- if O.clang.format.exe ~= '' then
--   settings["cpp"] = {
--         -- clang-format
--        function()
--           return {
--             exe = O.clang.format.exe,
--             args = {},
--             stdin = true,
--             cwd = vim.fn.expand('%:p:h')  -- Run clang-format in cwd of the file.
--           }
--         end
--     }
-- end

-- if O.python.format.exe ~= '' then
--   settings["python"] = {
--         -- black or yapf
--             function ()
--                 return {
--                 exe = O.python.format.exe,
--                 args = O.python.format.args,
--                 stdin = O.python.format.stdin,
--                 -- cwd = O.python.format.cwd
--                     }
--             end
--         }
-- end

local M = {}

M.config = function ()
  require('formatter.config').set_defaults({
    logging = false,
    filetype = settings})
end

return M
