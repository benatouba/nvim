local dial = require("dial")

dial.augends["custom#boolean"] = dial.common.enum_cyclic{
    name = "boolean",
    strlist = {"true", "false"},
}
table.insert(dial.config.searchlist.normal, "custom#boolean")

dial.augends["custom#Boolean"] = dial.common.enum_cyclic{
    name = "boolean",
    strlist = {"True", "False"},
}
table.insert(dial.config.searchlist.normal, "custom#Boolean")

dial.augends["custom#fortran#boolean"] = dial.common.enum_cyclic{
    name = "fortran-style boolean",
    strlist = {"T", "F"},
}
table.insert(dial.config.searchlist.normal, "custom#fortran#boolean")

vim.cmd([[
nmap <C-c> <Plug>(dial-increment)
nmap <C-x> <Plug>(dial-decrement)
vmap <C-c> <Plug>(dial-increment)
vmap <C-x> <Plug>(dial-decrement)
vmap g<C-c> <Plug>(dial-increment-additional)
vmap g<C-x> <Plug>(dial-decrement-additional)
  ]])
