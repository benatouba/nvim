local M = {}

M.config = function ()
  local neodev_ok, neodev = pcall(require, "neodev")
  if neodev_ok then
    neodev.setup({
      library = {
        enabled = true,
        plugins = true,
        types = true,
        runtime = true,
      },
      setup_jsonls = true,
      lspconfig = true,
      pathStrict = true,
      override = function(root_dir, library)
        if root_dir:find("/etc/nixos", 1, true) == 1 then
          library.enabled = true
          library.plugins = true
        end
      end,
    })
  end
  -- LSP signs default
  vim.fn.sign_define(
    "DiagnosticSignHint",
    { texthl = "DiagnosticSignHint", text = "", numhl = "DiagnosticSignHint" }
  )
  vim.fn.sign_define(
    "DiagnosticSignInfo",
    { texthl = "DiagnosticSignInfo", text = "", numhl = "DiagnosticSignInfo" }
  )
  vim.fn.sign_define(
    "DiagnosticSignWarning",
    { texthl = "DiagnosticSignWarning", text = "", numhl = "DiagnosticSignWarning" }
  )
  vim.fn.sign_define(
    "DiagnosticSignError",
    { texthl = "DiagnosticSignError", text = "", numhl = "DiagnosticSignError" }
  )

  -- LSP Enable diagnostics
  -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  --   vim.lsp.diagnostic.on_publish_diagnostics, {
  --     virtual_text = true,
  --     underline = true,
  --     signs = true,
  --     update_in_insert = true,
  --     severity_sort = true,
  --   })

  local mason_ok, mason = pcall(require, "mason")
  if not mason_ok then
    vim.notify("mason not okay in lspconfig")
    return
  end
  mason.setup({
    pip = {
      upgrade_pip = true,
    },
  })

  local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not mason_lspconfig_ok then
    vim.notify("mason-lspconfig not okay in lspconfig")
    return
  end
  mason_lspconfig.setup({})

  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if not lspconfig_ok then
    vim.notify("lspconfig not okay in lspconfig")
    return
  end

  if O.dap then
    local mason_nvim_dap_ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
    if not mason_nvim_dap_ok then
      vim.notify("mason-nvim-dap not okay in lspconfig")
      -- return
    else
      mason_nvim_dap.setup({
        ensure_installed = { "python" },
        handlers = {},
      })
    end
  end

  -- local lspconfig_configs = require("lspconfig.configs")
  -- lspconfig_configs.contextive = {
  --   default_config = {
  --     cmd = { "Contextive.LanguageServer" },
  --     root_dir = lspconfig.util.root_pattern(".contextive", ".git"),
  --   },
  -- }
  -- lspconfig.contextive.setup {}

  local common_on_attach = function (client, bufnr)
    -- vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
    local isOk, wk = pcall(require, "which-key")
    if not isOk then
      vim.notify("which-key not okay in lspconfig")
      return
    end
    local maps = {
      s = {
        name = "+Search",
        l = {
          name = "+LSP",
          d = { "<cmd>Telescope lsp_definitions<cr>", "Definitions" },
          D = { "<cmd>Telescope lsp_declarations<cr>", "Declarations" },
          i = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" },
          r = { "<cmd>Telescope lsp_references<cr>", "References" },
          s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols (LSP)" },
          S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols (LSP)" },
          -- s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols (LSP)" },
          -- S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols (LSP)" },
        },
      },
      l = {
        name = "+LSP",
        a = { vim.lsp.buf.code_action, "Code Action" },
        c = {
          "<cmd>lua =vim.lsp.get_active_clients()[2].server_capabilities<cr>",
          "Server Capabilities",
        },
        d = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
        D = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Document Diagnostics" },
        l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens" },
        L = { "<cmd>LspLog<CR>", "Logs" },
        -- f = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format Document" }, covered by conform.nvim
        -- with lsp_fallback
        F = { "<cmd>lua vim.lsp.buf.format({ async = false })<CR>", "Format Document (Sync)" },
        h = { vim.lsp.buf.hover, "Hover" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        q = { "<cmd>Telescope quickfix<cr>", "Quickfix" },
        r = { vim.lsp.buf.rename, "Rename" },
        R = {
          "<cmd>lua vim.lsp.buf.code_action({context = {only = {'refactor'}}})<cr>",
          "Refactor",
        },
        v = { "<cmd>lua vim.lsp.diagnostic.get_line_diagnostics()<CR>", "Virtual Text" },
        x = { "<cmd>cclose<cr>", "Close Quickfix" },
        w = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "Workspace" },
        s = {
          name = "+Settings",
          c = { "<cmd>e $HOME/.config/nvim/lua/lsp/init.lua<cr>", "Config" },
          s = { "<cmd>lua vim.lsp.status()<cr>", "Status" },
        },
      },
    }
    wk.register(maps, { mode = "n", buffer = bufnr, prefix = "<leader>" })
    local gmaps = {
      d = { vim.lsp.buf.definition, "Definition" },
      D = { vim.lsp.buf.declaration, "Declaration" },
      I = { vim.lsp.buf.implementation, "Implementations" },
      -- r = { "<cmd>lua require('nvim-treesitter-refactor.smart_rename')<cr>", "Rename" },
      R = { vim.lsp.buf.references, "References" },
      -- r = { "<cmd>lua vim.lsp.buf.code_action({context = {only = {'refactor'}}})<cr>", "Refactor" },,
      t = { vim.lsp.buf.type_definition, "Type Definition" },
      s = { vim.lsp.buf.signature_help, "Signature" },
    }
    wk.register(gmaps, {
      mode = "n",  -- NORMAL mode
      prefix = "g",
    })

    wk.register(gmaps, { mode = "v", prefix = "g" })
    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
    vim.keymap.set("n", "<C-K>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    vim.keymap.set("i", "<C-K>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
    -- vim.lsp.inlay_hint.enable()

    -- -- Highlights occurences of the word under the cursor
    -- vim.api.nvim_create_augroup("LspHighlighting", {})
    -- vim.api.nvim_create_autocmd(
    --   { "CursorHold", "CursorHoldI" }, {
    --     group = "LspHighlighting",
    --     buffer = 0,
    --     command = "lua vim.lsp.buf.document_highlight()"
    --   }
    -- )
    -- vim.api.nvim_create_autocmd("CursorMoved",
    --   { group = "LspHighlighting", buffer = 0, command = "lua vim.lsp.buf.clear_references()" })
  end

  local lsp_defaults = {
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = require("cmp_nvim_lsp").default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    ),
    on_attach = common_on_attach,
  }
  -- local ok, wf = pcall(require, "vim.lsp._watchfiles")
  -- if ok then
  --   -- wf._watchfunc = function(_, _, _) return true end
  --   wf._watchfunc = function ()
  --     return function () end
  --   end
  -- end

  lspconfig.util.default_config =
    vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)
  require("mason-lspconfig").setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name)  -- default handler (optional)
      require("lspconfig")[server_name].setup({})
    end,
    ["bashls"] = function ()
      lspconfig.bashls.setup({
        filetypes = { "sh", "zsh", "bash", "ksh", "dash" },
      })
    end,
    ["jedi_language_server"] = function ()
      lspconfig.jedi_language_server.setup({
        settings = {
          completion = {
            enable = false,
          },
        },
      })
    end,
    ["pyright"] = function ()
      lspconfig.pyright.setup({
        before_init = function (_, config)
          config.settings.python.pythonPath = Get_python_venv() .. "/bin/python"
          config.settings.python.analysis.stubPath =
            vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "python-type-stubs")
        end,
        on_attach = lsp_defaults.on_attach,
        settings = {
          pyright = {
            disableOrganizeImports = true,
            openFilesOnly = true,
          },
          python = {
            analysis = {
              autoImportCompletions = true,
              autoSearchPaths = true,
              -- logLevel = "Warning",
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "off",
            },
          },
        },
      })
    end,
    ["lua_ls"] = function ()
      lspconfig.lua_ls.setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      })
    end,
    ["pylsp"] = function ()
      local lsputil = require("lspconfig/util")

      local venv = Get_python_venv()

      lspconfig.pylsp.setup({
        filetypes = { "python", "djangopython", "django", "jupynium" },
        capabilities = lsp_defaults.capabilities,
        cmd = { "pylsp", "-v" },
        cmd_env = {
          VIRTUAL_ENV = venv,
          PATH = lsputil.path.join(venv, "bin") .. ":" .. vim.env.PATH,
        },
        -- on_attach = lsp_defaults.on_attach,
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
              ruff = { enabled = false, lineLength = 100 },
              black = { enabled = true, line_length = 100 },
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
    ["sourcery"] = function ()
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
    ["eslint"] = function ()
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
    ["volar"] = function ()
      local util = require("lspconfig.util")
      local function get_typescript_server_path(root_dir)
        -- local global_ts = "$PNPM_HOME/global/5"
        local global_ts = "/home/ben/.local/share/pnpm/global/5/node_modules/typescript/lib"
        -- local global_ts = "/usr/local/lib"
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
      local init_options = {
        typescript = {
          tsdk = "",
        },
        languageFeatures = {
          references = true,
          implementation = true,
          definition = true,
          typeDefinition = true,
          callHierarchy = true,
          hover = true,
          rename = true,
          renameFileRefactoring = true,
          signatureHelp = true,
          completion = {
            defaultTagNameCase = "both",
            defaultAttrNameCase = "kebabCase",
            getDocumentNameCasesRequest = true,
            getDocumentSelectionRequest = true,
          },
          documentHighlight = true,
          documentLink = true,
          workspaceSymbol = true,
          codeLens = true,
          semanticTokens = true,
          codeAction = true,
          diagnostics = true,
          schemaRequestService = true,
        },
        documentFeatures = {
          allowedLanguageIds = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "json",
          },
          selectionRange = true,
          foldingRange = true,
          linkedEditingRange = true,
          documentSymbol = true,
          documentColor = true,
          documentFormatting = true,
        },
      }
      lspconfig.volar.setup({
        capabilities = lsp_defaults.capabilities,
        cmd = { "vue-language-server", "--stdio" },
        filetypes = {
          "typescript",
          "javascript",
          "javascriptreact",
          "typescriptreact",
          "vue",
          "json",
        },
        init_options = init_options,
        on_new_config = function (new_config, new_root_dir)
          new_config.init_options = init_options
          new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
        end,
      })
    end,
    ["texlab"] = function ()
      lspconfig.texlab.setup({
        settings = {
          texlab = {
            build = {
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              executable = "latexmk",
              forwardSearchAfter = false,
              onSave = false,
            },
            chktex = {
              onEdit = true,
              onOpenAndSave = true,
            },
            diagnosticsDelay = 300,
            forwardSearch = {
              args = {},
              executable = "zathura",
              onSave = true,
            },
            latexFormatter = "latexindent",
            latexindent = {
              modifyLineBreaks = false,
            },
          },
        },
      })
    end,
    ["jsonls"] = function ()
      lsp_defaults.capabilities.textDocument.completion.completionItem.snippetSupport = true
      lspconfig.jsonls.setup({
        capabilities = lsp_defaults.capabilities,
        on_attach = lsp_defaults.on_attach,
      })
    end,
    ["ltex"] = function ()
      lspconfig.ltex.setup({
        capabilities = lsp_defaults.capabilities,
        filetypes = {
          "bib",
          "markdown",
          "org",
          "plaintex",
          "rst",
          "rnoweb",
          "tex",
          "pandoc",
          "quarto",
          "rmd",
        },
        on_attach = function (client, bufnr)
          require("ltex_extra").setup({
            path = vim.fn.expand("~") .. "/.local/share/ltex",
          })
        end,
      })
    end,
  })
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
      stdout = function (_, data)
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

    return function ()
      sub:kill("sigint")
    end
  end

  if vim.fn.executable("watchman") == 1 then
    require("vim.lsp._watchfiles")._watchfunc = watchman
  end
end
return M
