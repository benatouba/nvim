local M = {}

M.config = function ()
  local ls_ok, ls = pcall(require, "luasnip")
  if not ls_ok then
    vim.notify("Failed to load luasnip", vim.log.levels.ERROR)
    return
  end
  local types = require("luasnip.util.types")
  ls.config.set_config({
    enable_autosnippets = true,
    history = true,
    updateevents = "TextChanged,TextChangedI",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "<-", "Error" } },
        },
      },
    },
  })

  -- NOTE: For the moment this gets overwritten by cmp
  vim.keymap.set({ "i", "s" }, "<c-k>", function ()
    if ls.expand_or_jumpable() then
      return ls.expand_or_jump()
    end
  end, { silent = true })

  vim.keymap.set({ "i", "s" }, "<c-j>", function ()
    if ls.jumpable(-1) then
      return ls.jump(-1)
    end
  end, { silent = true })

  vim.keymap.set({ "i", "s" }, "<c-l>", function ()
    if ls.choice_active() then
      return ls.change_choice(1)
    end
  end, { silent = true })

  require("luasnip.loaders.from_lua").load({paths = vim.fn.stdpath("config") .. "/snippets"})
end

return M
