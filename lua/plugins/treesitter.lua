-- Treesitter (main branch: parsers are installed on demand, highlighting/indent are
-- started per buffer) and the small plugins that build on it.

-- Closing brackets still owed by `line`, e.g. "foo({" -> "})"; "" when balanced.
local function get_closing_for_line(line)
  local i = -1 ---@type integer|nil
  local clo = ""
  while true do
    i = string.find(line, "[%(%)%{%}%[%]]", i + 1)
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

return {
  {
    "windwp/nvim-ts-autotag",
    -- Filetype-scoped only: an InsertEnter trigger would load this in every buffer.
    ft = {
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
      "markdown",
      "xml",
      "php",
    },
    opts = {
      opts = { enable_close = true, enable_rename = true, enable_close_on_slash = true },
    },
  },
  { "folke/ts-comments.nvim", event = "VeryLazy", opts = {} },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = { javascript = { "template_string" } },
      enable_check_bracket_line = true,
      ignored_next_char = "[%w%.]",
      fast_wrap = { map = "<C-e>" },
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      local rule = require("nvim-autopairs.rule")
      local ts_conds = require("nvim-autopairs.ts-conds")
      autopairs.setup(opts)

      -- Only close what the line still leaves open
      autopairs.add_rule(rule("[%(%{%[]", "")
        :use_regex(true)
        :replace_endpair(function(o)
          return get_closing_for_line(o.line)
        end)
        :end_wise(function(o)
          return get_closing_for_line(o.line) ~= ""
        end))
      autopairs.add_rules(
        {
          rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript", "vue" })
            :use_regex(true)
            :set_end_pair_length(2),
        },
        rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
        rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
        rule("%", "%", { "salt", "sls" })
      )
    end,
  },
  {
    "andymass/vim-matchup",
    -- Disabled on Neovim >= 0.12 (kept for the day it is wanted back).
    enabled = vim.fn.has("nvim-0.12") == 0,
    keys = { "%" },
    event = "InsertEnter",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_surround_enabled = 1
    end,
  },
}
