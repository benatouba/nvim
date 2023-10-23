local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  git = {
    -- choice node > commit types
    -- choice node > scope yes/no
    s("git conv commit", {
      i(1, "type"), t("("), i(2, "scope"), t("): "), i(3, "description"),
    }),
  }
}
