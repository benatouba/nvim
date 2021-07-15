if O.lua.autoformat then
  vim.api.nvim_exec([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.lua FormatWrite
    autocmd InsertLeave *.lua Format
  augroup END
  ]], true)
end

if O.format then
  O.formatter = {
    lua = {
        function()
          return O.lua.format
        end
    }
  }
  print('Set up formatter ' .. O.lua.format.exe)
end
