-- local util = require 'lspconfig/util'
local config = require'lspconfig/configs'.fortls

config = {
    cmd = {vim.fn.stdpath('data') .. "/lspinstall/fortran/venv/bin/fortls"},
    -- filetypes = "fortran",
    -- root_dir = util.root_pattern('.git', '.fortls', '.'),
    -- root_dir = util.root_pattern({".git", ".fortls", vim.fn.getcwd()}),
    on_attach = common_on_attach,
    -- handlers = {
    --     ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    --         virtual_text = O.diagnostics.virtual_text.active,
    --         signs = O.diagnostics.signs,
    --         underline = O.diagnostics.underline,
    --         update_in_insert = true,
    --     })
    -- },
    settings = { nthreads = 1, },
--   docs = {
--     package_json = "https://raw.githubusercontent.com/hansec/vscode-fortran-ls/master/package.json",
--     description = [[
-- https://github.com/hansec/fortran-language-server
-- Fortran Language Server for the Language Server Protocol
--     ]],
--     default_config = {
--       root_dir = [[root_pattern(".fortls")]],
--     },
--   },
--   install_script = [[
--         ! pip3 install --upgrade fortran-language-server || true
--     ]],
--   uninstall_script = [[
--         ! pip3 uninstall fortran-language-server || true
--     ]]
}

-- require'lspconfig/configs'["fortran"] = config

-- require'lspinstall/servers'.fortls = config
