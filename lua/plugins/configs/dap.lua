-- nvim-dap adapters and configurations (python, node/browser JS).
local M = {}

local js_based_languages = { "javascript", "typescript", "vue", "javascriptreact", "typescriptreact" }

-- Continue, loading the project's .vscode/launch.json configurations first when present.
M.js_attach_with_arguments = function()
  if vim.fn.filereadable(".vscode/launch.json") == 1 then
    require("dap.ext.vscode").load_launchjs(nil, {
      ["pwa-node"] = js_based_languages,
      ["pwa-chrome"] = js_based_languages,
      ["node"] = js_based_languages,
      ["chrome"] = js_based_languages,
    })
  end
  require("dap").continue()
end

M.setup = function()
  local dap = require("dap")

  for name, text in pairs({
    DapBreakpoint = "",
    DapBreakpointCondition = "",
    DapBreakpointRejected = "",
    DapLogPoint = "",
    DapStopped = "",
  }) do
    vim.fn.sign_define(name, {
      text = text,
      texthl = name == "DapLogPoint" and "DapLogPoint" or name == "DapStopped" and "DapStopped" or "DapBreakpoint",
    })
  end
  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
  dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

  -- Python: debugpy from the active virtualenv
  local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or "python"
  require("dap-python").setup(python)
  for _, config in ipairs(dap.configurations.python) do
    config.cwd = vim.fn.getcwd()
  end

  -- JS/TS: js-debug-adapter from Nix, or the Mason install elsewhere
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = vim.g.is_nixos and { command = "js-debug-adapter", args = { "${port}" } } or {
      command = "node",
      args = {
        vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }
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
      { name = "launch.json config", type = "", request = "launch", repl_lang = lang },
    }
  end

  local overseer_ok, overseer = pcall(require, "overseer")
  if overseer_ok then
    overseer.enable_dap()
  end
end

return M
