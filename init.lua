require('plugins')
require('nv-globals')
require('nv-utils')
vim.cmd('luafile ~/.config/nvim/nv-settings.lua')
require('nv-autocommands')
require('settings')
require('keymappings')
require('colorscheme')
require('nv-galaxyline')
require('nv-comment')
require('nv-colorizer')
require('nv-compe')
require('nv-barbar')
require('nv-telescope')
require('nv-treesitter')
require('nv-autopairs')
require('nv-which-key')
require('nv-dial')
require('nv-rooter')
require('nv-neogit')

vim.cmd('source ~/.config/nvim/vimscript/functions.vim')

-- LSP
require('lsp')
require('lsp.clangd')
require('lsp.php-ls')
-- require('lsp.dart-ls')
require('lsp.lua-ls')
require('lsp.bash-ls')
require('lsp.go-ls')
-- require('lsp.js-ts-ls')
-- require('lsp.python-ls')
require('lsp.rust-ls')
require('lsp.json-ls')
require('lsp.yaml-ls')
require('lsp.terraform-ls')
require('lsp.vim-ls')
require('lsp.graphql-ls')
require('lsp.docker-ls')
require('lsp.html-ls')
require('lsp.css-ls')
require('lsp.emmet-ls')
-- require('lsp.efm-general-ls')
require('lsp.latex-ls')
require('lsp.svelte-ls')
-- require('lsp.tailwindcss-ls')
require('lsp.ruby-ls')
require('lsp.kotlin-ls')
require('lsp.vue-ls')
require('lsp.angular-ls')

P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end
