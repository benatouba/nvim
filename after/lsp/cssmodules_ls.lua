return {
  on_init = function(client)
    client.server_capabilities.definitionProvider = true
  end,
}
