local M = {}
local dial = require("dial")

M.config = function()
dial.augends["custom#boolean"] = dial.common.enum_cyclic{
    name = "boolean",
    strlist = {"true", "false"},
}
table.insert(dial.config.searchlist.normal, "custom#boolean")

dial.augends["custom#boolean_cap"] = dial.common.enum_cyclic{
    name = "boolean_cap",
    strlist = {"True", "False"},
}
table.insert(dial.config.searchlist.normal, "custom#boolean_cap")

dial.augends["custom#boolean_allcaps"] = dial.common.enum_cyclic{
    name = "boolean_allcaps",
    strlist = {"TRUE", "FALSE"},
}
table.insert(dial.config.searchlist.normal, "custom#boolean_allcaps")

dial.augends["custom#fortran#boolean"] = dial.common.enum_cyclic{
    name = "fortran-style boolean",
    strlist = {"T", "F"},
}
table.insert(dial.config.searchlist.normal, "custom#fortran#boolean")
table.insert(dial.config.searchlist.normal, "date#[%Y/%m/%d]")

vim.cmd([[
nmap <C-c> <Plug>(dial-increment)
nmap <C-x> <Plug>(dial-decrement)
vmap <C-c> <Plug>(dial-increment)
vmap <C-x> <Plug>(dial-decrement)
vmap g<C-c> <Plug>(dial-increment-additional)
vmap g<C-x> <Plug>(dial-decrement-additional)
  ]])

end

return M
