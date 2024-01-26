local M = {}
local copilot_ok, copilot = pcall(require, "copilot")
if not copilot_ok then
  vim.notify("copilot not okay")
  return
end

M.config = function()
  copilot.setup({
    panel = {
      enabled = true,
      auto_refresh = true,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-cr>",
      },
      layout = {
        position = "bottom", -- | top | left | right
        ratio = 0.3,
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = "<M-l>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-h>",
      },
    },
    filetypes = {
      vue = true,
      yaml = true,
      markdown = true,
      help = false,
      gitcommit = true,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      TelescopePrompt = false,
      sh = function()
        if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
          -- disable for .env files
          return false
        end
        return true
      end,
      ["."] = false,
    },
    copilot_node_command = "node", -- Node.js version must be > 16.x
    server_opts_overrides = {},
  })
  vim.keymap.set("i", "<C-a>",  "<cmd>lua require('copilot.suggestion').accept_word()<cr>", {})
  vim.keymap.set("i", "<C-l>",  "<cmd>lua require('copilot.suggestion').accept_line()<cr>", {})
  vim.keymap.set("i", "<C-g>",  "<cmd>lua require('copilot.panel').open()<cr>", {})
end

return M
