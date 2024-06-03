vim.loader.enable()
require('user-defaults')
require('utils.globals')
require('utils')
require('keymappings')
require('user-settings')
require('settings')
if vim.g.vscode then
else
require('plugins')
require('ben')
end
require('autocommands')
require('colorscheme')
require('utils.after')
