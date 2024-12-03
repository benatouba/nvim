local status_ok, dap = pcall(require, "dap")
if not status_ok then
  vim.notify("nvim-dap not okay")
  return
end
local dap_vt_ok, dap_vt = pcall(require, "nvim-dap-virtual-text")
if not dap_vt_ok then
  vim.notify("nvim-dap-virtual-text not okay")
  return
end
-- local dap_utils_ok, dap_utils = pcall(require, "dap.utils")
-- if not dap_utils_ok then
--   vim.notify("dap.utils not okay")
--   return
-- end


local data = {
  breakpoint = {
    text = "",
    texthl = "LspDiagnosticsSignError",
    linehl = "",
    numhl = "",
    priority = 200,
  },
  breakpoint_rejected = {
    text = "R",
    texthl = "LspDiagnosticsSignHint",
    linehl = "",
    numhl = "",
  },
  stopped = {
    text = "",
    texthl = "LspDiagnosticsSignInformation",
    linehl = "DiagnosticUnderlineInfo",
    numhl = "LspDiagnosticsSignInformation",
  },
}

local js_attach_with_arguments = function ()
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

local M = {}
M.vt_config = function ()
  dap_vt.setup({
    enabled = true,  -- enable this plugin (the default)
    enabled_commands = true,  -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true,  -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,  -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,  -- show stop reason when stopped for exceptions
    commented = false,  -- prefix virtual text with comment string
    only_first_definition = true,  -- only show virtual text at first definition (if there are multiple)
    all_references = false,  -- show virtual text on all all references of the variable (not only definitions)
    filter_references_pattern = "<module",  -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
    -- Experimental Features:
    virt_text_pos = "eol",  -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false,  -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,  -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil,  -- position the virtual text at a fixed window column (starting from the first text column) ,
  })
end

local js_based_languages = {
  "javascript",
  "typescript",
  "vue",
  "javascriptreact",
  "typescriptreact",
}

M.config = function ()
  -- vim.fn.sign_define("DapBreakpoint", data.breakpoint)
  -- vim.fn.sign_define("DapBreakpointRejected", data.breakpoint_rejected)
  -- vim.fn.sign_define("DapStopped", data.stopped)
  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

  dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
  require("nvim-dap-virtual-text").setup({
    virt_text_pos = vim.fn.has "nvim-0.10" == 1 and "inline" or "eol",
    all_frames = true,
  })
  require("which-key").add({
    { "<leader>d", group = "+Debug" },
    { "<leader>dB", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('BP Condition: '))<cr>", desc = "Conditional Breakpoint" },
    { "<leader>dC", "<cmd>lua require'dap'.run_to_cursor()<cr>", desc = "Run To Cursor" },
    { "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", desc = "Step Out" },
    { "<leader>dS", "<cmd>lua require'dap'.step_back()<cr>", desc = "Step Back" },
    { "<leader>da", function () js_attach_with_arguments() end, desc = "Run with arguments" },
    { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
    { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue" },
    { "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>", desc = "Disconnect" },
    { "<leader>dg", "<cmd>lua require'dap'.session()<cr>", desc = "Get Session" },
    { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "Step Into" },
    { "<leader>dl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", desc = "Log Point Message" },
    { "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "Step Over" },
    { "<leader>dp", "<cmd>lua require'dap'.pause.toggle()<cr>", desc = "Pause" },
    { "<leader>dq", "<cmd>lua require'dap'.close()<cr>", desc = "Quit" },
    { "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "Toggle Repl" },
    { "<leader>ds", group = "+Search" },
    { "<leader>dsC", "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>", desc = "Configurations" },
    { "<leader>dsb", "<cmd>lua require'telescope'.extensions.dap.list_breakpoints{}<cr>", desc = "Breakpoints" },
    { "<leader>dsc", "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>", desc = "Commands" },
    { "<leader>dsf", "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>", desc = "frames" },
    { "<leader>dsv", "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>", desc = "Variables" },
    { "<leader>dx", "<cmd>lua require'dap'.clear_breakpoints()<cr>", desc = "Toggle Repl" },
  })

  local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
  dap.adapters.python = {
    type = "executable",
    command = mason_debugpy,
    args = { "-m", "debugpy.adapter" },
    cwd = vim.fn.getcwd(),
  }

  local function get_python_path()
    -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
    -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
    -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
    local cwd = vim.fn.getcwd()
    local venv = Get_python_venv()
    if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
      return venv .. "/bin/python"
    elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
      return cwd .. "/venv/bin/python"
    elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
      return cwd .. "/.venv/bin/python"
    else
      return "python"
    end
  end
  dap.configurations.python = {
    {
      type = "python",  -- the type here established the link to the adapter definition: `dap.adapters.python`
      request = "launch",
      name = "All Code",
      -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

      program = "${file}",  -- This configuration will launch the current file if used.
      justMyCode = false,
      pythonPath = get_python_path(),
      cwd = vim.fn.getcwd(),
    },
    {
      type = "python",  -- the type here established the link to the adapter definition: `dap.adapters.python`
      request = "launch",
      name = "Manim",
      -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

      program = "${file}",  -- This configuration will launch the current file if used.
      args = { "-m", "manim", "-pql", },
      justMyCode = false,
      pythonPath = get_python_path(),
      cwd = vim.fn.getcwd(),
    },
    {
      type = "python",
      request = "launch",
      name = "cosipy aws2copy",
      -- program = "${file}",
      module = "cosipy.utilities.aws2cosipy.aws2cosipy",
      args = {
        "-i",
        "./data/input/Zhadang/Zhadang_ERA5_2009_2018.csv", "-o",
        "./data/input/Zhadang/Zhadang_ERA5_2009.nc", "-s", "./data/static/Zhadang_static.nc", "-b",
        "20090101", "-e", "20091231",
      },
      justMyCode = true,
      pythonPath = get_python_path(),
      cwd = vim.fn.getcwd(),
    },
    {
      type = "python",
      request = "launch",
      name = "COSIPY",
      -- program = "${file}",
      module = "COSIPY",
      justMyCode = true,
      pythonPath = get_python_path(),
      cwd = vim.fn.getcwd(),
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
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to Process",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        processId = require("dap.utils").pick_process,
      },
      {
        type = "pwa-chrome",
        request = "launch",
        name = "Launch Chrome",
        url = function ()
          local co = coroutine.running()
          return coroutine.create(function ()
            vim.ui.input({
              prompt = "URL: ",
              default = "http://localhost:3000",
            }, function (url)
              if url == nil or url == "" then
                return
              else
                coroutine.resume(co, url)
              end
            end)
          end)
        end,
        sourceMaps = true,
        protocol = "inspector",
        webRoot = "${workspaceFolder}",
        skipFiles = { "<node_internals>/**/*.js" },
        userDataDir = false,
      },
      {
        name = "launch.json config",
        type = "",
        request = "launch",
      }
    }
  end
end
return M
