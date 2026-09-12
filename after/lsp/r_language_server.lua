-- R.nvim provides completion; formatting goes through conform.
return {
  on_init = function(client)
    client.server_capabilities.completionProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
