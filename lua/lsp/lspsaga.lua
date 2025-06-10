local cp_ok, cp = pcall(require, "catppuccin.groups.integrations.lsp_saga")
local kind = nil
if cp_ok then
  kind = cp.custom_kind()
end

return {
  code_action = {
    num_shortcut = true,
    show_server_name = true,
    extend_gitsigns = true,
    keys = {
      quit = { "q", "<ESC>" },
      exec = "<CR>",
    },
  },
  lightbulb = {
    enable = false,
  },
  hover = {
    enable = true,
    max_width = 0.6,
    open_link = "gx",
    open_browser = "!brave",
  },
  ui = {
    -- This option only works in Neovim 0.9
    title = true,
    -- Border type can be single, double, rounded, solid, shadow.
    border = "rounded",
    -- lines = { '┗', '┣', '┃', '━', '┏' },
    lines = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    winblend = 0,
    expand = "",
    collapse = "",
    code_action = "💡",
    incoming = " ",
    outgoing = " ",
    hover = " ",
    kind = kind,
  },
  request_timeout = 5000,
}
