return {
  filetypes = { "ruby", "eruby", "sonicpi" },
  root_markers = { "Gemfile", ".git" },
  workspace_required = false,
  single_file_support = true,
  on_init = function(client)
    local ok, sonicpi = pcall(require, "sonicpi")
    if ok and type(sonicpi.lsp_on_init) == "function" then
      sonicpi.lsp_on_init(client, {
        server_dir = vim.env.SONIC_PI_SERVER_DIR or "",
      })
    end
  end,
}
