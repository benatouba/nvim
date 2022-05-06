local lspconfig = require('lspconfig')
lspconfig.pylsp.setup(
    {
    on_attach = function(client)
        if client.server_capabilities.document_formatting then
            print("Formatting Document")
            vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
        end
    end
    }
)
