local status_ok, autopairs = pcall(require, "nvim-autopairs")
if not status_ok then
  return
end
local rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

local get_closing_for_line = function (line)
  local i = -1
  local clo = ""

  while true do
    i, _ = string.find(line, "[%(%)%{%}%[%]]", i + 1)
    if i == nil then
      break
    end
    local ch = string.sub(line, i, i)
    local st = string.sub(clo, 1, 1)

    if ch == "{" then
      clo = "}" .. clo
    elseif ch == "}" then
      if st ~= "}" then
        return ""
      end
      clo = string.sub(clo, 2)
    elseif ch == "(" then
      clo = ")" .. clo
    elseif ch == ")" then
      if st ~= ")" then
        return ""
      end
      clo = string.sub(clo, 2)
    elseif ch == "[" then
      clo = "]" .. clo
    elseif ch == "]" then
      if st ~= "]" then
        return ""
      end
      clo = string.sub(clo, 2)
    end
  end

  return clo
end

-- skip it, if you use another global object
local M = {}

M.config = function ()
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp = require("cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

  autopairs.setup({
    check_ts = true,
    ts_config = {
      javascript = { "template_string" },
    },
    enable_check_bracket_line = true,
    ignored_next_char = "[%w%.]",
    fast_wrap = {
      map = "<C-e>",
    },
  })

  local ts_conds = require("nvim-autopairs.ts-conds")

  autopairs.add_rule(rule("[%(%{%[]", "")
    :use_regex(true)
    :replace_endpair(function (opts)
      return get_closing_for_line(opts.line)
    end)
    :end_wise(function (opts)
      -- Do not endwise if there is no closing
      return get_closing_for_line(opts.line) ~= ""
    end))

  autopairs.add_rules(
    {
      rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript", "vue" })
        :use_regex(true)
        :set_end_pair_length(2),
    },
    rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
    rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
    rule("%", "%", "sls")
  )
end
return M
