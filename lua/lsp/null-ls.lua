local null_ls_ok, null_ls = pcall(require, 'null-ls')
if not null_ls_ok then
    print('null-ls not okay')
return
end
-- local helpers = require("null-ls.helpers")

local sources = {
    null_ls.builtins.formatting.prettier.with({
        filetypes = { "html", "json", "yaml", "markdown", "rmd" },
    }),
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.completion.spell,
    null_ls.builtins.diagnostics.proselint,
    null_ls.builtins.hover.dictionary,
    null_ls.builtins.formatting.black.with({
        method = null_ls.methods.FORMAT_ON_SAVE,
        filetypes = { "python" }
    }),
    null_ls.builtins.formatting.isort,
    -- null_ls.builtins.diagnostics.flake8,
    -- null_ls.builtins.diagnostics.pylint,
    -- null_ls.builtins.code_actions.refactoring
}

-- local markdownlint = {
--     method = null_ls.methods.DIAGNOSTICS,
--     filetypes = { "markdown", "rmd" },
--     -- null_ls.generator creates an async source
--     -- that spawns the command with the given arguments and options
--     generator = null_ls.generator({
--         command = "markdownlint",
--         args = { "--stdin" },
--         to_stdin = true,
--         from_stderr = true,
--         -- choose an output format (raw, json, or line)
--         format = "line",
--         check_exit_code = function(code)
--             return code <= 1
--         end,
--         -- use helpers to parse the output from string matchers,
--         -- or parse it manually with a function
--         on_output = helpers.diagnostics.from_patterns({
--             {
--                 pattern = [[:(%d+):(%d+) [%w-/]+ (.*)]],
--                 groups = { "row", "col", "message" },
--             },
--             {
--                 pattern = [[:(%d+) [%w-/]+ (.*)]],
--                 groups = { "row", "message" },
--             },
--         }),
--     }),
-- }

local M = {}
M.config = function()
    -- null_ls.register(markdownlint)
    null_ls.config({
                sources = sources,
    })
    require("lspconfig")["null-ls"].setup({
        on_attach = function(client)
            if client.resolved_capabilities.document_formatting then
                vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
            end
        end,
    })
end

return M
