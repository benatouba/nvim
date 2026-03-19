local M = {}

M.config = function()
  local opts = {
    R_args = { "--quiet", "--no-save" },
    objbr_mappings = { -- Object browser keymap
      c = "class", -- Call R functions
      ["<localleader>gg"] = "head({object}, n = 15)", -- Use {object} notation to write arbitrary R code.
      v = function()
        -- Run lua functions
        require("r.browser").toggle_view()
      end,
    },
    Rout_more_colors = true,
    Rout_follow_colorscheme = true,
    hook = {
      on_filetype = function()
        -- This function will be called at the FileType event
        -- of files supported by R.nvim. This is an
        -- opportunity to create mappings local to buffers.
        vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
        vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
      end,
    },
    min_editor_width = 72,
    rconsole_width = 78,
    disable_cmds = {
      "RClearConsole",
      "RCustomStart",
      "RSPlot",
      "RSaveClose",
    },
    auto_start = "always",
    view_df = {
      open_app = "terminal:vd",
    },
  }
  -- alias r "R_AUTO_START=true nvim"
  if vim.env.R_AUTO_START == "true" then
    opts.auto_start = 1
    opts.objbr_auto_start = true
  end
  vim.g.rout_follow_colorscheme = true
  require("r").setup(opts)
end

return M
