local status_ok, dap = pcall(require, "dap")
if not status_ok then
  vim.notify("nvim-dap not okay")
  return
end

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped" })

local js_attach_with_arguments = function()
  local js_based_languages = {
    "javascript",
    "typescript",
    "vue",
    "javascriptreact",
    "typescriptreact",
  }
  if vim.fn.filereadable(".vscode/launch.json") then
    local dap_vscode = require("dap.ext.vscode")
    dap_vscode.load_launchjs(nil, {
      ["pwa-node"] = js_based_languages,
      ["pwa-chrome"] = js_based_languages,
      ["node"] = js_based_languages,
      ["chrome"] = js_based_languages,
    })
  end
  require("dap").continue()
end

local js_based_languages = {
  "javascript",
  "typescript",
  "vue",
  "javascriptreact",
  "typescriptreact",
}

local M = {}

M.config = function()
  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

  dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
  require("nvim-dap-virtual-text").setup({
    virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
    all_frames = true,
  })

  local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or "python"
  require("dap-python").setup(python)
  for _, config in ipairs(dap.configurations.python) do
    config.cwd = vim.fn.getcwd()
  end

  if not O.is_nixos then
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
      },
    }
  end

  local overseer_ok, overseer = pcall(require, "overseer")
  if overseer_ok then
    overseer.enable_dap()
  end

  for _, lang in ipairs(js_based_languages) do
    dap.configurations[lang] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        repl_lang = lang,
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to Process",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        processId = require("dap.utils").pick_process,
        repl_lang = lang,
      },
      {
        name = "launch.json config",
        type = "",
        request = "launch",
        repl_lang = lang,
      },
    }
  end
end
return M
