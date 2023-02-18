-- vim.cmd('command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')

-- symbols for autocomplete
-- vim.lsp.protocol.CompletionItemKind = {
--   "   (Text) ",
--   "   (Method)",
--   "   (Function)",
--   "   (Constructor)",
--   " ﴲ  (Field)",
--   "[] (Variable)",
--   "   (Class)",
--   " ﰮ  (Interface)",
--   "   (Module)",
--   " 襁 (Property)",
--   "   (Unit)",
--   "   (Value)",
--   " 練 (Enum)",
--   "   (Keyword)",
--   "   (Snippet)",
--   "   (Color)",
--   "   (File)",
--   "   (Reference)",
--   "   (Folder)",
--   "   (EnumMember)",
--   " ﲀ  (Constant)",
--   " ﳤ  (Struct)",
--   "   (Event)",
--   "   (Operator)",
--   "   (TypeParameter)"
-- }

-- LSP signs default
vim.fn.sign_define(
  "DiagnosticSignError",
  { texthl = "DiagnosticSignError", text = "", numhl = "DiagnosticSignError" }
)
vim.fn.sign_define(
  "DiagnosticSignWarning",
  { texthl = "DiagnosticSignWarning", text = "", numhl = "DiagnosticSignWarning" }
)
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "", numhl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "", numhl = "DiagnosticSignInfo" })

-- LSP Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
  underline = true,
  signs = true,
  update_in_insert = true,
  severity_sort = true,
})

local border_style = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

local pop_opts = { border = border_style }
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, pop_opts)
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, pop_opts)

-- local capabilities = function() return require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()) end

-- local lsp_defaults = {
--   flags = {
--     debounce_text_changes = 150,
--   },
--   capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
--   on_attach = function(client, bufnr)
--     vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
--   end,
-- }

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
  vim.notify("lspconfig not okay in lspconfig")
  return
end

local lsp_status_ok, lsp_status = pcall(require, "lsp-status")
if not lsp_status_ok then
  vim.notify("lsp-status not okay in lspconfig")
end
lsp_status.register_progress()

lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)

installed_servers = {
  "ansiblels",
  "bashls",
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "fortls",
  "html",
  "jsonls",
  "lua_ls",
  "pylsp",
  "r_language_server",
  "ruff_lsp",
  "salt_ls"
  "sqls", -- deprecated
  "taplo",
  "tsserver",
  "vimls",
  "volar",
  "yamlls",
  "rnix",
  "zk",
}

local util = require("lspconfig.util")
local function get_typescript_server_path(root_dir)
  local global_ts = "/usr/local/lib/node_modules/typescript/lib"
  local found_ts = ""
  local function check_dir(path)
    found_ts = util.path.join(path, "node_modules", "typescript", "lib")
    if util.path.exists(found_ts) then
      return path
    end
  end

  if util.search_ancestors(root_dir, check_dir) then
    return found_ts
  else
    util.path.exists(global_ts)
    vim.notify("Using global typescript")
    return global_ts
  end
end

local lsp = require('lsp-zero').preset({
  name = 'minimal',
  set_lsp_keymaps = {omit = {'<F2>', '<F4>'}}
  manage_nvim_cmp = true,
  suggest_lsp_servers = true,
})
lsp.setup_servers(installed_servers)
lsp.configure('volar', {
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
  init_options = {
    documentFeatures = {
      documentColor = false,
      documentFormatting = {
        defaultPrintWidth = 120,
      },
      documentSymbol = true,
      foldingRange = true,
      linkedEditingRange = true,
      selectionRange = true,
    },
    languageFeatures = {
      callHierarchy = true,
      codeAction = true,
      codeLens = true,
      completion = {
        defaultAttrNameCase = "kebabCase",
        defaultTagNameCase = "both",
      },
      definition = true,
      diagnostics = true,
      documentHighlight = true,
      documentLink = true,
      hover = true,
      implementation = true,
      references = true,
      rename = true,
      renameFileRefactoring = true,
      schemaRequestService = true,
      semanticTokens = false,
      signatureHelp = true,
      typeDefinition = true,
    },
    typescript = {
      tsdk = "",
    },
  },
  -- on_attach = function(client)
  --   client.server_capabilities.documentFormattingProvider = true
  --   client.server_capabilities.documentRangeFormattingProvider = true
  --   client.server_capabilities.renameProvider = true
  -- end,
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
  end,
})

lsp.configure('bashls', {
  filetypes = { "sh", "zsh", "bash", "ksh", "dash" },
})

local lsputil = require("lspconfig/util")
local get_python_venv = function()
  vim.fn.system("pyenv init")
  vim.fn.system("pyenv init -")

  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV
  end

  local match = vim.fn.glob(lsputil.path.join(vim.fn.getcwd(), "Pipfile"))
  if match ~= "" then
    return vim.fn.trim(vim.fn.system("PIPENV_PIPFILE=" .. match .. " pipenv --venv"))
  end

  match = vim.fn.glob(lsputil.path.join(vim.fn.getcwd(), "poetry.lock"))
  if match ~= "" then
    return vim.fn.trim(vim.fn.system("poetry env info -p"))
  end
  match = vim.fn.glob(lsputil.path.join(vim.fn.getcwd(), ".python_version"))
  if match ~= "" then
    return vim.fn.trim(vim.fn.system("pyenv prefix"))
  end
end
local venv = get_python_venv()

lsp.configure('pylsp', {
  filetypes = { "python", "djangopython", "django" },
  cmd = { "pylsp", "-v" },
  cmd_env = { VIRTUAL_ENV = venv, PATH = lsputil.path.join(venv, "bin") .. ":" .. vim.env.PATH },
  single_file_support = true,
  settings = {
    pylsp = {
      plugins = {
        autopep8 = { enabled = false },
        flake8 = { enabled = false },
        pycodestyle = { enabled = false, maxLineLength = 120 },
        pyflakes = { enabled = false },
        pydocstyle = { enabled = true },
        mccabe = { enabled = true },
        memestra = { enabled = true },
        pylint = { enabled = false },
        rope_autimport = { enabled = true },
        rope_completion = { enabled = true },
        ruff = { enabled = true, lineLength = 120 },
        black = { enabled = false },
        yapf = { enabled = false },
        jedi = {
          auto_import_modules = {
            "numpy",
            "pandas",
            "salem",
            "matplotlib",
            "Django",
            "djangorestframework",
          },
        },
        jedi_completion = { enabled = true, eager = true, fuzzy = true },
      },
    },
  },
})

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
lsp.configure('lua_ls', {
  settings = {
    lua = {
      runtime = {
        version = "LuaJIT",
        path = runtime_path,
      },
      diagnostics = {
        enable = true,
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.api.nvim_get_runtime_file("", true),
        },
        maxPreload = 10000,
        preloadFileSize = 1000,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

lsp.configure('sourcery').sourcery.setup({
  filetypes = { "python" },
  init_options = {
    token = "user_re1CDsCNaWsCXRrWENblMoIhU8INKHMGuiqQDG1FG0CKWTC7Td_93Ilq7FA",
    extension_version = "vim.lsp",
    editor_version = "vim",
  },
  settings = {
    sourcery = {
      metricsEnabled = false,
    },
  },
})

lsp.setup()
