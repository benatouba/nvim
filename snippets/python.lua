local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node

return {
  s({ trig = "clstest", name = "clstest" },
    fmt(
      [[
        class {}:
            def test_{}(self, {}) -> None:
                {}
                assert {}

            {}
        ]],
      {
        i(1, { "ClassName" }),
        i(2, { "test_name" }),
        i(3, { "args" }),
        i(4, { "body" }),
        i(5, { "assertion" }),
        i(0)
      }
    )
  ),
  s({ trig = "voiceover", name = "voiceover" },
    fmt(
      [[
      with self.voiceover(
          text=
          """
          {}
          """,
      ):
          {}
      ]],
      {
        i(1, { }),
        i(0, { "self.wait(1)" })
      }
    )
  )
}
