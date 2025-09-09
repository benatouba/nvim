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

  local default_augends = {
    augend.integer.alias.decimal,
    augend.constant.alias.bool,
    augend.constant.alias.de_weekday,
    augend.constant.alias.de_weekday_full,
    augend.date.alias["%d/%m/%Y"],
    augend.constant.new({ elements = { "yes", "no" } }),
    augend.constant.new({ elements = { "let", "const", "var" } }),
    augend.constant.new({ elements = { "T", "F" } }),
    augend.constant.new({ elements = { "True", "False" } }),
    augend.constant.new({ elements = { "TRUE", "FALSE" } }),
    augend.constant.new({ elements = { "def", "class" } }),
    augend.hexcolor.new({ case = "lower" }),
    augend.semver.alias.semver,
    augend.constant.new({ elements = { "[ ]", "[x]" }, word = false, cyclic = true }),
  }
  config.augends:register_group({
    default = default_augends,
    visual = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias["%Y/%m/%d"],
      augend.date.alias["%d/%m/%Y"],
    },
  })
  require("dial.config").augends:on_filetype({
    default = vim.tbl_extend("keep", {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.constant.new({ elements = { "true", "false" } }),
      augend.constant.new({ elements = { "let", "const" } }),
    }, default_augends),
    lua = vim.tbl_extend("keep", {
      augend.integer.alias.decimal,
      augend.constant.new({ elements = { "true", "false" } }),
    }, default_augends),
    markdown = vim.tbl_extend("keep", {
      augend.integer.alias.decimal,
      augend.misc.alias.markdown_header,
      augend.constant.alias.de_weekday,
      augend.constant.alias.de_weekday_full,
    }, default_augends),
  })
end

return M
