local M = {}

M.config = function()
  vim.g.codeium_disable_bindings = 1
  vim.keymap.set("i", "<C-l>", function()
    return vim.fn["codeium#Accept"]()
  end, { expr = true, silent = true })
  vim.keymap.set("i", "<C-a>", function()
    return vim.fn["codeium#AcceptNextWord"]()
  end, { expr = true, silent = true })
  vim.keymap.set("i", "<C-S-a>", function()
    return vim.fn["codeium#AcceptNextLine"]()
  end, { expr = true, silent = true })
  vim.keymap.set("i", "<c-n>", function()
    return vim.fn["codeium#CycleCompletions"](1)
  end, { expr = true, silent = true })
  vim.keymap.set("i", "<c-p>", function()
    return vim.fn["codeium#CycleCompletions"](-1)
  end, { expr = true, silent = true })
  vim.keymap.set("i", "<c-h>", function()
    return vim.fn["codeium#Clear"]()
  end, { expr = true, silent = true })
end

return M
