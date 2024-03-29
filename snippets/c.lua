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
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
local isn = ls.indent_snippet_node
local events = require("luasnip.util.events")

return {
  c = {
    s("class", {
      -- Choice: Switch between two different Nodes, first parameter is its position, second a list of nodes.
      c(1, {
        t("public "),
        t("private "),
      }),
      t("class "),
      i(2),
      t(" "),
      c(3, {
        t("{"),
        -- sn: Nested Snippet. Instead of a trigger, it has a position, just like insert-nodes. !!! These don't expect a 0-node!!!!
        -- Inside Choices, Nodes don't need a position as the choice node is the one being jumped to.
        sn(nil, {
          t("extends "),
          i(1),
          t(" {"),
        }),
        sn(nil, {
          t("implements "),
          i(1),
          t(" {"),
        }),
      }),
      t({ "", "\t" }),
      i(0),
      t({ "", "}" }),
    }),

    s("#if", {
      t("#if "), i(1, "1"), t({ "", "" }),
      i(0), t({ "", "#endif // " }), f(function (args) return args[1] end, 1),
    }),
  }
}
