local M = {}

M.config = function()
  local ref_ok, ref = pcall(require, "refactoring")
  if not ref_ok then
    vim.notify("Refactoring.nvim not okay")
    return
  end
  ref.setup()
  local keymap = vim.keymap

  keymap.set({ "n", "x" }, "<localleader>re", function()
    return require("refactoring").extract_func()
  end, { desc = "Extract Function", expr = true })
  -- `_` is the default textobject for "current line"
  keymap.set("n", "<localleader>ree", function()
    return require("refactoring").extract_func() .. "_"
  end, { desc = "Extract Function (line)", expr = true })

  keymap.set({ "n", "x" }, "<localleader>rE", function()
    return require("refactoring").extract_func_to_file()
  end, { desc = "Extract Function To File", expr = true })

  keymap.set({ "n", "x" }, "<localleader>rv", function()
    return require("refactoring").extract_var()
  end, { desc = "Extract Variable", expr = true })

  -- `_` is the default textobject for "current line"
  keymap.set("n", "<localleader>rvv", function()
    return require("refactoring").extract_var() .. "_"
  end, { desc = "Extract Variable (line)", expr = true })

  keymap.set({ "n", "x" }, "<localleader>ri", function()
    return require("refactoring").inline_var()
  end, { desc = "Inline Variable", expr = true })
  keymap.set({ "n", "x" }, "<localleader>rI", function()
    return require("refactoring").inline_func()
  end, { desc = "Inline function", expr = true })

  keymap.set({ "n", "x" }, "<localleader>rs", function()
    return require("refactoring").select_refactor()
  end, { desc = "Select refactor" })

  -- `iw` is the builtin textobject for "in word". You can use any other textobject or even create the keymap without any textobject if you prefer to provide one yourself each time that you use the keymap
  keymap.set({ "x", "n" }, "<localleader>pv", function()
    return require("refactoring.debug").print_var({ output_location = "below" }) .. "iw"
  end, { desc = "Debug print var below", expr = true })

  -- `iw` is the builtin textobject for "in word". You can use any other textobject or even create the keymap without any textobject if you prefer to provide one yourself each time that you use the keymap
  keymap.set({ "x", "n" }, "<localleader>pV", function()
    return require("refactoring.debug").print_var({ output_location = "above" }) .. "iw"
  end, { desc = "Debug print var above", expr = true })

  keymap.set({ "x", "n" }, "<localleader>pe", function()
    return require("refactoring.debug").print_exp({ output_location = "below" })
  end, { desc = "Debug print exp below", expr = true })
  -- `_` is the default textobject for "current line"
  keymap.set("n", "<localleader>pee", function()
    return require("refactoring.debug").print_exp({ output_location = "below" }) .. "_"
  end, { desc = "Debug print exp below", expr = true })

  keymap.set({ "x", "n" }, "<localleader>pE", function()
    return require("refactoring.debug").print_exp({ output_location = "above" })
  end, { desc = "Debug print exp above", expr = true })
  -- `_` is the default textobject for "current line"
  keymap.set("n", "<localleader>pEE", function()
    return require("refactoring.debug").print_exp({ output_location = "above" }) .. "_"
  end, { desc = "Debug print exp above", expr = true })

  keymap.set("n", "<localleader>pP", function()
    return require("refactoring.debug").print_loc({ output_location = "above" })
  end, { desc = "Debug print location", expr = true })
  keymap.set("n", "<localleader>pp", function()
    return require("refactoring.debug").print_loc({ output_location = "below" })
  end, { desc = "Debug print location", expr = true })

  keymap.set({ "x", "n" }, "<localleader>pc", function()
    -- `ag` is a custom textobject that selects the whole buffer. It's provided by plugins like `mini.ai` (requires manual configuration using `MiniExtra.gen_ai_spec.buffer()`).
    -- return require("refactoring.debug").cleanup { restore_view = true } .. "ag"

    -- this keymap doesn't select any textobject by default, so you need to provide one each time you use it.
    return require("refactoring.debug").cleanup({ restore_view = true })
  end, { desc = "Debug print clean", expr = true, remap = true })
end

return M
