local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
local events = require("luasnip.util.events")

return {
  lua = {
    s("lua print var", {
      t("print(\""),
      i(1, "desrc"),
      t(": \" .. "),
      i(2, "the_variable"),
      t(")"),
    }),

    s({ trig = "if basic", wordTrig = true }, {
      t({ "if " }),
      i(1),
      t({ " then", "\t" }),
      i(0),
      t({ "", "end" })
    }),

    s({ trig = "ee", wordTrig = true }, {
      t({ "else", "\t" }),
      i(0),
    }),

    s("for", {
      t "for ", c(1, {
      sn(nil, { i(1, "k"), t ", ", i(2, "v"), t " in ", c(3, { t "pairs", t "ipairs" }), t "(", i(4),
        t ")" }),
      sn(nil, { i(1, "i"), t " = ", i(2), t ", ", i(3), })
    }), t { " do", "\t" }, i(0), t { "", "end" }
    }),
    s("lf", {
      t({ "local " }),
      i(1),
      t({ " = function(" }),
      i(2),
      t({ "\n", "\t" }),
      i(3),
      t({ "\n", "end" }),
    }),
    s("req", {
      t({ "local " }),
      i(1),
      t({ " = require('" }),
      rep(i),
      t({ "')" }),
    })
  }
}
