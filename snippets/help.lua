local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  help = {
    s({ trig = "con", wordTrig = true }, {
      i(1),
      f(function (args) return { " " .. string.rep(".", 80 - (#args[1][1] + #args[2][1] + 2 + 2)) ..
        " " } end, { 1, 2 }),
      t({ "|" }),
      i(2),
      t({ "|" }),
      i(0)
    }),
  }
}
