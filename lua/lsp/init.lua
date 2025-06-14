local M = {}

M.config = function()
  vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

  -- Enable inlay hints
  -- vim.api.nvim_create_autocmd("LspAttach", {
  --   desc = "Enable inlay hints",
  --   callback = function (event)
  --     local id = vim.tbl_get(event, "data", "client_id")
  --     local client = id and vim.lsp.get_client_by_id(id)
  --     if client == nil or not client:supports_method("textDocument/inlayHint") then
  --       return
  --     end
  --
  --     vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
  --   end,
  -- })

  -- LSP signs default
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "✘",
        [vim.diagnostic.severity.WARN] = "▲",
        [vim.diagnostic.severity.HINT] = "⚑",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
  })

  vim.api.nvim_create_user_command("LspCapabilities", function()
    local curBuf = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = curBuf })

    for _, client in pairs(clients) do
      if client.name ~= "null-ls" then
        local capAsList = {}
        for key, value in pairs(client.server_capabilities) do
          if value and key:find("Provider") then
            local capability = key:gsub("Provider$", "")
            table.insert(capAsList, "- " .. capability)
          end
        end
        table.sort(capAsList) -- sorts alphabetically
        local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
        vim.notify(msg, "trace", {
          on_open = function(win)
            local buf = vim.api.nvim_win_get_buf(win)
            vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
          end,
          timeout = 14000,
        })
        vim.fn.setreg("+", "Capabilities = " .. vim.inspect(client.server_capabilities))
      end
    end
  end, {})

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end
      local bufnr = vim.api.nvim_get_current_buf()
      local isOk, wk = pcall(require, "which-key")
      if not isOk then
        vim.notify("which-key not okay in lspconfig")
        return
      end
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client.server_capabilities.completionProvider then
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      end
      if client.name == "basedpyright" then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        client.server_capabilities.definitionProvider = true
        -- elseif client.name == "texlab" then
        --   -- Disable in favor of Conform
        --   client.server_capabilities.documentFormattingProvider = true
        --   client.server_capabilities.documentRangeFormattingProvider = true
      elseif client.name == "mutt_ls" then
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
      elseif client.name == "ruff" then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.definitionProvider = false
      elseif client.name == "r_language_server" then
        client.server_capabilities.completionProvider = false
        client.server_capabilities.completionItemResolve = false
      elseif client.name == "ts_ls" then
        --   client.server_capabilities.documentFormattingProvider = false
        --   client.server_capabilities.documentRangeFormattingProvider = false
        --   client.server_capabilities.documentHighlightProvider = true
        client.server_capabilities.semanticTokensProvider = false
      elseif client.name == "vue_ls" then
        --   client.server_capabilities.documentHighlightProvider = true
        client.server_capabilities.semanticTokensProvider = false
      --   client.server_capabilities.documentFormattingProvider = true
      --   client.server_capabilities.documentRangeFormattingProvider = false
      --   client.server_capabilities.definitionProvider = false
      elseif client.name == "cssmodules_ls" then
        client.server_capabilities.definitionProvider = true
      end
      vim.keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.completion.trigger()<cr>")
      wk.add({
        {
          { buffer = bufnr },
          { "<C-K>", vim.lsp.buf.signature_help, desc = "Signature", mode = { "n" } },
          { "<F2>", vim.lsp.buf.rename, desc = "Rename" },
          { "<leader>l", group = "+LSP", icon = { icon = "", color = "yellow" } },
          { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
          { "<leader>lc", "<cmd>e $HOME/.config/nvim/lua/lsp/init.lua<cr>", desc = "Config" },
          { "<leader>lC", "<cmd>LspCapabilities<cr>", desc = "Server Capabilities" },
          { "<leader>lD", "<cmd>Telescope lsp_declarations<cr>", desc = "Declarations" },
          { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
          { "<leader>lF", "<cmd>lua vim.lsp.buf.format({ async = false })<CR>", desc = "Format Document (Sync)" },
          { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
          { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens" },
          { "<leader>lL", "<cmd>LspLog<CR>", desc = "Logs", icon = { icon = " ", color = "green" } },
          { "<leader>lq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
          { "<leader>lr", "<cmd>LspRestart<cr>", desc = "Restart Server" },
          {
            "<leader>lR",
            "<cmd>lua vim.lsp.buf.code_action({context = {only = {'refactor'}}})<cr>",
            desc = "Refactor",
          },
          { "<leader>lv", "<cmd>lua vim.lsp.diagnostic.get_line_diagnostics()<CR>", desc = "Virtual Text" },
          { "<leader>lw", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", desc = "Workspace" },
          { "<leader>lx", "<cmd>cclose<cr>", desc = "Close Quickfix" },
          { "<leader>s", group = "Search" },
          { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
          { "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
          { "<leader>si", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
          { "<leader>sr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
          { "<leader>sS", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols (LSP)" },
          { "<leader>ss", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols (LSP)" },
          { "K", vim.lsp.buf.hover, desc = "Hover" },
          -- f = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format Document" }, covered by conform.nvim
          -- with lsp_fallback
          {
            mode = { "n", "x", "v" },
            { "gD", vim.lsp.buf.declaration, desc = "Declaration" },
            { "gd", vim.lsp.buf.definition, desc = "Definition" },
            { "gI", vim.lsp.buf.implementation, desc = "Implementations" },
            { "gO", vim.lsp.buf.document_symbol, desc = "Document Symbols" },
            { "gR", vim.lsp.buf.references, desc = "References" },
            { "grr", vim.lsp.buf.references, desc = "References" },
            { "grn", vim.lsp.buf.rename, desc = "Rename" },
            { "gra", vim.lsp.buf.code_action, desc = "Code Action" },
            { "gri", vim.lsp.buf.implementation, desc = "Implementations" },
            { "gtd", vim.lsp.buf.type_definition, desc = "Type Definition" },
            { "gth", vim.lsp.buf.typehierarchy, desc = "Type Hierarchy" },
            { "gs", vim.lsp.buf.signature_help, desc = "Signature" },
          },
        },
      })
      vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_group = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = highlight_group,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = highlight_group,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })

  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- local lsp_defaults = {
  --   flags = {
  --     debounce_text_changes = 150,
  --   },
  --   capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
  -- }
  -- local ok, wf = pcall(require, "vim.lsp._watchfiles")
  -- if ok then
  --   -- wf._watchfunc = function(_, _, _) return true end
  --   wf._watchfunc = function ()
  --     return function () end
  --   end
  -- end

  -- lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)

  --[[
  require("mason-lspconfig").setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
      require("lspconfig")[server_name].setup({})
    end,
    ["bashls"] = function()
      lspconfig.bashls.setup({
        filetypes = { "sh", "zsh", "bash", "ksh", "dash" },
      })
    end,
    ["jedi_language_server"] = function()
      lspconfig.jedi_language_server.setup({
        settings = {
          completion = {
            enable = false,
          },
        },
      })
    end,
    ["vale_ls"] = function()
      lspconfig.vale_ls.setup({})
    end,
    ["harper_ls"] = function()
      lspconfig.harper_ls.setup({
        settings = {
          ["harper-ls"] = {
            userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
          },
        },
      })
    end,
    ["pyright"] = function()
      lspconfig.pyright.setup({
        before_init = function(_, config)
          config.settings.python.pythonPath = Get_python_venv() .. "/bin/python"
          config.settings.python.analysis.stubPath =
            vim.fs.joinpath(vim.fn.expand("~"), ".local", "src", "python-type-stubs", "stubs")
        end,
      })
    end,
    ["pylsp"] = function()
      local lsputil = require("lspconfig/util")

      local venv = Get_python_venv()

      lspconfig.pylsp.setup({
        filetypes = { "python", "djangopython", "django", "jupynium" },
        cmd = { "pylsp", "-v" },
        cmd_env = {
          VIRTUAL_ENV = venv,
          PATH = lsputil.path.join(venv, "bin") .. ":" .. vim.env.PATH,
        },
        single_file_support = true,
        settings = {
          pylsp = {
            plugins = {
              autopep8 = { enabled = false },
              flake8 = { enabled = false },
              pycodestyle = { enabled = false, maxLineLength = 100 },
              pyflakes = { enabled = false },
              pydocstyle = { enabled = false, convention = "google" },
              mccabe = { enabled = false },
              memestra = { enabled = false },
              mypy = { enabled = false },
              pylint = { enabled = false },
              rope_autimport = { enabled = true },
              rope_completion = { enabled = true },
              ruff = { enabled = true, lineLength = 100 },
              black = { enabled = false, line_length = 100 },
              yapf = { enabled = false },
              preload = { modules = { "manim", "numpy", "pandas" } },
              jedi = {
                auto_import_modules = {
                  "numpy",
                  "pandas",
                  "salem",
                  "matplotlib",
                  "Django",
                  "djangorestframework",
                  "manim",
                  "typing",
                  "plotly",
                  "dash",
                  "dash_bootstrap_components",
                },
              },
              jedi_completion = {
                enabled = false,
                eager = false,
                fuzzy = true,
                include_class_objects = false,
                include_function_objects = false,
                cache_for = {
                  "pandas",
                  "numpy",
                  "matplotlib",
                  "salem",
                  "Django",
                  "djangorestframework",
                  "manim",
                  "plotly",
                  "dash",
                  "dash_bootstrap_components",
                },
              },
            },
          },
        },
      })
    end,
    ["sourcery"] = function()
      lspconfig.sourcery.setup({
        init_options = {
          token = require("secrets").sourcery,
          extension_version = "vim.lsp",
          editor_version = "vim",
        },
        settings = {
          sourcery = {
            metricsEnabled = false,
          },
        },
      })
    end,

    ["eslint"] = function()
      lspconfig.eslint.setup({
        filetypes = {
          "typescript",
          "javascript",
          "javascriptreact",
          "typescriptreact",
          "vue",
          "json",
        },
      })
    end,
    ["ltex"] = function()
      lspconfig.ltex.setup({
        capabilities = lsp_defaults.capabilities,
        filetypes = {
          "bib",
          -- "markdown",
          -- "org",
          "plaintex",
          "rst",
          "rnoweb",
          "tex",
          "pandoc",
          "quarto",
          "rmd",
        },
        settings = {
          ltex = {
            language = "en-GB",
            additionalRules = {
              motherTongue = "de-DE",
            },
          },
        },
      })
    end,
  })
  ]]
  local watch_type = require("vim._watch").FileChangeType

  local function handler(res, callback)
    if not res.files or res.is_fresh_instance then
      return
    end

    for _, file in ipairs(res.files) do
      local path = res.root .. "/" .. file.name
      local change = watch_type.Changed
      if file.new then
        change = watch_type.Created
      end
      if not file.exists then
        change = watch_type.Deleted
      end
      callback(path, change)
    end
  end

  local function watchman(path, opts, callback)
    vim.system({ "watchman", "watch", path }):wait()

    local buf = {}
    local sub = vim.system({
      "watchman",
      "-j",
      "--server-encoding=json",
      "-p",
    }, {
      stdin = vim.json.encode({
        "subscribe",
        path,
        "nvim:" .. path,
        {
          expression = { "anyof", { "type", "f" }, { "type", "d" } },
          fields = { "name", "exists", "new" },
        },
      }),
      stdout = function(_, data)
        if not data then
          return
        end
        for line in vim.gsplit(data, "\n", { plain = true, trimempty = true }) do
          table.insert(buf, line)
          if line == "}" then
            local res = vim.json.decode(table.concat(buf))
            handler(res, callback)
            buf = {}
          end
        end
      end,
      text = true,
    })

    return function()
      sub:kill("sigint")
    end
  end

  if vim.fn.executable("watchman") == 1 then
    require("vim.lsp._watchfiles")._watchfunc = watchman
  end
  -- lspconfig.ltex.dictionary_file = Dictionary_file
  -- lspconfig.ltex.disabledrules_file = DisabledRules_file
  -- lspconfig.ltex.falsepostivies_file = FalsePositives_file
  --
  --
  -- -- https://github.com/neovim/nvim-lspconfig/issues/858 can't intercept,
  -- -- override it then.
  -- local orig_execute_command = vim.lsp.buf.execute_command
  -- vim.lsp.buf.execute_command = function (command)
  --   if command.command == '_ltex.addToDictionary' then
  --     local arg = command.arguments[1].words -- can I really access like this?
  --     for lang, words in pairs(arg) do
  --       for _, word in ipairs(words) do
  --         local filetype = "dictionary"
  --         addTo(filetype, lang, findLtexFiles(filetype, lang), word)
  --       end
  --     end
  --   elseif command.command == '_ltex.disableRules' then
  --     local arg = command.arguments[1].ruleIds -- can I really access like this?
  --     for lang, rules in pairs(arg) do
  --       for _, rule in ipairs(rules) do
  --         local filetype = "disable"
  --         addTo(filetype, lang, findLtexFiles(filetype, lang), rule)
  --       end
  --     end
  --   elseif command.command == '_ltex.hideFalsePositives' then
  --     local arg = command.arguments[1].falsePositives -- can I really access like this?
  --     for lang, rules in pairs(arg) do
  --       for _, rule in ipairs(rules) do
  --         local filetype = "falsePositive"
  --         addTo(filetype, lang, findLtexFiles(filetype, lang), rule)
  --       end
  --     end
  --   else
  --     orig_execute_command(command)
  --   end
  -- end
end
return M
