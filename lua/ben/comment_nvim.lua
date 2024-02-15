local M = {}

M.config = function()
  local comment_ok, comment = pcall(require, "Comment")
  if not comment_ok then
    vim.notify("Comment.nvim not ok")
    return
  end
  local opts = {
    ignore = "^$",
  }
  comment.setup(opts)
end

return M
