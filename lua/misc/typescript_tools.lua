local M = {}

M.config = function ()
  local baseDefinitionHandler = vim.lsp.handlers["textDocument/definition"]

  local mason_registry = require("mason-registry")
  local tsserver_path = mason_registry.get_package("typescript-language-server"):get_install_path()
  local filter = function (arr, fn)
    if type(arr) ~= "table" then
      return arr
    end

    local filtered = {}
    for k, v in pairs(arr) do
      if fn(v, k, arr) then
        table.insert(filtered, v)
      end
    end

    return filtered
  end
  local filterReactDTS = function (value)
    -- Depending on typescript version either uri or targetUri is returned
    if value.uri then
      return string.match(value.uri, "%.d.ts") == nil
    elseif value.targetUri then
      return string.match(value.targetUri, "%.d.ts") == nil
    end
  end

  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      silent = true,
    }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {}),
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      { virtual_text = vim.lsp.virtual_text }
    ),
    ["textDocument/definition"] = function (err, result, method, ...)
      P(result)
      if vim.tbl_islist(result) and #result > 1 then
        local filtered_result = filter(result, filterReactDTS)
        return baseDefinitionHandler(err, filtered_result, method, ...)
      end

      baseDefinitionHandler(err, result, method, ...)
    end,
  }

  require("typescript-tools").setup({
    -- on_attach = function (client, bufnr)
    --   if vim.fn.has("nvim-0.10") then
    --     -- Enable inlay hints
    --     vim.lsp.inlay_hint(bufnr, true)
    --   end
    -- end,
    handlers = handlers,
    settings = {
      separate_diagnostic_server = true,
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "all",
        includeCompletionsForModuleExports = true,
        quotePreference = "auto",
      },
    },
  })
end
return M
