-- Language server configs
-- require('lsp.bash-ls')
require('lsp.clangd')
require('lsp.css-ls')
require('lsp.docker-ls')
-- require('lsp.efm-general-ls')
require('lsp.emmet-ls')
require('lsp.fortran-ls')
require('lsp.html-ls')
require('lsp.js-ts-ls')
require('lsp.json-ls')
require('lsp.latex-ls')
require('lsp.lua-ls')
require('lsp.python-ls')
-- require('lsp.pylsp-ls')
require('lsp.python-jedi-ls')
require('lsp.salt-ls')
require('lsp.vim-ls')
require('lsp.vue-ls')
require('lsp.yaml-ls')

-- other stuff
-- TODO figure out why this don't work
vim.fn.sign_define(
    "LspDiagnosticsSignError",
    {texthl = "LspDiagnosticsSignError", text = "", numhl = "LspDiagnosticsSignError"}
)
vim.fn.sign_define(
    "LspDiagnosticsSignWarning",
    {texthl = "LspDiagnosticsSignWarning", text = "", numhl = "LspDiagnosticsSignWarning"}
)
vim.fn.sign_define(
    "LspDiagnosticsSignHint",
    {texthl = "LspDiagnosticsSignHint", text = "", numhl = "LspDiagnosticsSignHint"}
)
vim.fn.sign_define(
    "LspDiagnosticsSignInformation",
    {texthl = "LspDiagnosticsSignInformation", text = "", numhl = "LspDiagnosticsSignInformation"}
)

-- vim.cmd('command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')

-- symbols for autocomplete
vim.lsp.protocol.CompletionItemKind = {
    "   (Text) ",
    "   (Method)",
    "   (Function)",
    "   (Constructor)",
    " ﴲ  (Field)",
    "[] (Variable)",
    "   (Class)",
    " ﰮ  (Interface)",
    "   (Module)",
    " 襁 (Property)",
    "   (Unit)",
    "   (Value)",
    " 練 (Enum)",
    "   (Keyword)",
    "   (Snippet)",
    "   (Color)",
    "   (File)",
    "   (Reference)",
    "   (Folder)",
    "   (EnumMember)",
    " ﲀ  (Constant)",
    " ﳤ  (Struct)",
    "   (Event)",
    "   (Operator)",
    "   (TypeParameter)"
}

--[[ " autoformat
autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 100) ]]
-- Java
-- autocmd FileType java nnoremap ca <Cmd>lua require('jdtls').code_action()<CR>

-- local function documentHighlight(client, bufnr)
--     -- Set autocommands conditional on server_capabilities
--     if client.resolved_capabilities.document_highlight then
--         vim.api.nvim_exec(
--             [[
--       hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
--       hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
--       hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
--       augroup lsp_document_highlight
--         autocmd! * <buffer>
--         autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
--         autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
--       augroup END
--     ]],
--             false
--         )
--     end
-- end
-- local lsp_config = {}
--
-- function lsp_config.common_on_attach(client, bufnr)
--     documentHighlight(client, bufnr)
-- end
--
-- function lsp_config.tsserver_on_attach(client, bufnr)
--     lsp_config.common_on_attach(client, bufnr)
--     client.resolved_capabilities.document_formatting = false
-- end

-- vim.cmd[[:LspStart]]
-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
