local isOk, nvim_dap_vscode_js = pcall(require, "dap-vscode-js")

if not isOk then
  vim.notify("nvim-dap-vscode-js no ok")
  return
end

local M = {}

M.config = function ()
  nvim_dap_vscode_js.setup({
    debugger_path = DATA_PATH .. "/lazy/vscode-js-debug",
    adapters = { "chrome", "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost", "node" }
  })

end
return M
