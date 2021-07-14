-- local DetectSls = function ()
--   if not vim.fn.synIDtrans then
--     if string.match(vim.fn.getline(1), '^#!py') then
--       vim.bo.filetype = 'python'
--     else
--       vim.bo.filetype = 'sls'
--     end
--   end
-- end
--
-- DetectSls()
-- vim.o.syntax = 'on'
vim.cmd('filetype plugin indent on')
vim.cmd('let g:sls_use_jinja_syntax = 1')
