local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
  vim.notify("null-ls not okay")
  return
end
local helpers = require("null-ls.helpers")

local sources = {
  null_ls.builtins.code_actions.shellcheck,
  -- null_ls.builtins.formatting.shfmt,
  -- null_ls.builtins.formatting.shellharden,
  null_ls.builtins.formatting.latexindent,
  null_ls.builtins.code_actions.gitsigns,
}
local ref_ok, _ = pcall(require, "refactoring")
if ref_ok then
  table.insert(sources, null_ls.builtins.code_actions.refactoring)
end

local M = {}
M.config = function ()
  -- null_ls.register(markdownlint)
  null_ls.setup({
    sources = sources,
    options = {
      on_attach = function (client)
        if client.server_capabilities.document_formatting then
          vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
        end
      end,
    },
  })
  require("mason-null-ls").setup({
    handlers = {},
  })
end

return M
