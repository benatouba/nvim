-- reload modules
if pcall(require, "plenary") then
  RELOAD = require("plenary.reload").reload_module

  R = function (name)
    RELOAD(name)
    return require(name)
  end
else
  vim.notify("plenary not loaded", vim.log.levels.INFO)
end

