local M = {}

M.config = function()
  local comment_ok, comment = pcall(require, "Comment")
  local tsc_ok, tsc = pcall(require, "ts_context_commentstring")
  if not tsc_ok then
    vim.notify("TS-Context-Commentstring not ok")
  end
  if not comment_ok then
    vim.notify("Comment.nvim not ok")
    return
  end
  local opts = {
    ignore = "^$",
  }
  if tsc_ok then
    tsc.setup({
      enable_autocmd = false,
    })
    opts.pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
  end
  comment.setup(opts)
end

return M
