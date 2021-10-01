 local status_ok, dap = pcall(require, "nvim-dap")
 if not status_ok then
   return
 end

vim.fn.sign_define("DapBreakpoint", "")
dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
