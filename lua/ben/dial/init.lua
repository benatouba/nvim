local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

local M = {}

M.config = function()
  local dial_ok, config = pcall(require, "dial.config")
  if not dial_ok then
    vim.notify("dial not okay")
    return
  end

  local augend = require("dial.augend")

  config.augends:register_group({
    default = {
      augend.integer.alias.decimal,
      augend.constant.alias.bool,
      augend.constant.alias.de_weekday,
      augend.constant.alias.de_weekday_full,
      augend.date.alias["%m/%d"],
      augend.date.alias["%Y/%m/%d"],
      augend.constant.new({ elements = { "yes", "no" } }),
      augend.constant.new({ elements = { "let", "const", "var" } }),
      augend.constant.new({ elements = { "T", "F" } }),
      augend.constant.new({ elements = { "True", "False" } }),
      augend.constant.new({ elements = { "TRUE", "FALSE" } }),
      augend.constant.new({ elements = { "def", "class" } }),
      augend.hexcolor.new({ case = "lower" }),
      -- augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),
      -- augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
      -- augend.constant,
      augend.semver.alias.semver,
      augend.constant.new({ elements = { "[ ]", "[x]" }, word = false, cyclic = true }),
    },
    visual = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias["%Y/%m/%d"],
    },
  })
end

return M
