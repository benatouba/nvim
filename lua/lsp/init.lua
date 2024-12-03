local M = {}

M.config = function ()
  vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

  -- Enable inlay hints
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Enable inlay hints",
    callback = function (event)
      local id = vim.tbl_get(event, "data", "client_id")
      local client = id and vim.lsp.get_client_by_id(id)
      if client == nil or not client.supports_method("textDocument/inlayHint") then
        return
      end

      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end,
  })

  -- Expand snippet
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Enable vim.lsp.completion",
    callback = function (event)
      local client_id = vim.tbl_get(event, "data", "client_id")
      if client_id == nil then
        return
      end

      -- warning: this api is unstable
      vim.lsp.completion.enable(true, client_id, event.buf, { autotrigger = false })

      -- warning: this api is unstable
      -- Trigger lsp completion manually using Ctrl + Space
      vim.keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.completion.trigger()<cr>")
    end
  })

  -- LSP signs default
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "✘",
        [vim.diagnostic.severity.WARN] = "▲",
        [vim.diagnostic.severity.HINT] = "⚑",
        [vim.diagnostic.severity.INFO] = "",
      },
      -- numhl = {
      --   [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      --   [vim.diagnostic.severity.WARN] = "WarningMsg",
      -- },
    }
  })

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
        automatic_installation = true,
      })
    end
  end

  vim.api.nvim_create_user_command("LspCapabilities", function ()
    local curBuf = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients { bufnr = curBuf }

    for _, client in pairs(clients) do
      if client.name ~= "null-ls" then
        local capAsList = {}
        for key, value in pairs(client.server_capabilities) do
          if value and key:find("Provider") then
            local capability = key:gsub("Provider$", "")
            table.insert(capAsList, "- " .. capability)
          end
        end
        table.sort(capAsList)  -- sorts alphabetically
        local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
        vim.notify(msg, "trace", {
          on_open = function (win)
            local buf = vim.api.nvim_win_get_buf(win)
            vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
          end,
          timeout = 14000,
        })
        vim.fn.setreg("+", "Capabilities = " .. vim.inspect(client.server_capabilities))
      end
    end
  end, {})

  local common_on_attach = function (client, bufnr)
    -- vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
    local isOk, wk = pcall(require, "which-key")
    if not isOk then
      vim.notify("which-key not okay in lspconfig")
      return
    end
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
    elseif client.name == "volar" then
      client.server_capabilities.documentFormattingProvider = true
      client.server_capabilities.documentRangeFormattingProvider = false
      client.server_capabilities.definitionProvider = false
    elseif client.name == "cssmodules_ls" then
      client.server_capabilities.definitionProvider = true
    end
    wk.add({
      {
        { buffer = bufnr },
        { "<leader>l", group = "+LSP", icon = { icon = "", color = "yellow" } },
        { "<leader>lC", "<cmd>LspCapabilities<cr>", desc = "Server Capabilities" },
        { "<leader>lD", "<cmd>Telescope lsp_declarations<cr>", desc = "Declarations" },
        { "<leader>lF", "<cmd>lua vim.lsp.buf.format({ async = false })<CR>", desc = "Format Document (Sync)" },
        { "<leader>lL", "<cmd>LspLog<CR>", desc = "Logs", icon = { icon = " ", color = "green" } },
        { "<leader>lR", "<cmd>lua vim.lsp.buf.code_action({context = {only = {'refactor'}}})<cr>", desc = "Refactor" },
        { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>lc", "<cmd>e $HOME/.config/nvim/lua/lsp/init.lua<cr>", desc = "Config" },
        { "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", desc = "Definitions" },
        -- f = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format Document" }, covered by conform.nvim
        -- with lsp_fallback
        { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
        { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
        { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens" },
        { "<leader>lq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
        { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
        { "<F2>", vim.lsp.buf.rename, desc = "Rename" },
        { "<leader>lv", "<cmd>lua vim.lsp.diagnostic.get_line_diagnostics()<CR>", desc = "Virtual Text" },
        { "<leader>lw", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", desc = "Workspace" },
        { "<leader>lx", "<cmd>cclose<cr>", desc = "Close Quickfix" },
        { "<leader>s", group = "Search" },
        { "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
        { "<leader>sS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols (LSP)" },
        { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
        { "<leader>si", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
        { "<leader>sr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "<leader>sS", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols (LSP)" },
        { "<leader>ss", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols (LSP)" },
        { "K", vim.lsp.buf.hover, desc = "Hover" },
        { "<C-K>", vim.lsp.buf.signature_help, desc = "Signature", mode = { "n", "i" } },
        {
          mode = { "n", "x", "v" },
          { "gD", vim.lsp.buf.declaration, desc = "Declaration" },
          { "gd", vim.lsp.buf.definition, desc = "Definition" },
          { "gI", vim.lsp.buf.implementation, desc = "Implementations" },
          { "gr", vim.lsp.buf.references, desc = "References" },
          { "gt", vim.lsp.buf.type_definition, desc = "Type Definition" },
          { "gS", vim.lsp.buf.signature_help, desc = "Signature" },
        }
      }
    })
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

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
    ["harper_ls"] = function ()
      lspconfig.harper_ls.setup({
        settings = {
          ["harper-ls"] = {
            userDictPath = "~/dict.txt"
          }
        },
      })
    end,
    ["basedpyright"] = function ()
      lspconfig.basedpyright.setup({
        -- before_init = function (_, config)
        --   -- config.settings.python.pythonPath = Get_python_venv() .. "/bin/python"
        --   config.settings.basedpyright.analysis.stubPath =
        --     vim.fs.joinpath(
        --     -- vim.fn.expand(vim.fn.stdpath("data")),
        --     -- "lazy",
        --     -- "python-type-stubs",
        --     -- "stubs"
        --       vim.fs.joinpath(vim.fn.expand("~"), ".local", "src", "python-type-stubs", "stubs")
        --     )
        -- end,
        settings = {
          basedpyright = {
            analysis = {
              inlayHints = {
                typeHints = true,
                parameterHints = true,
                chainedCallHints = true,
                variableTypeHints = true,
                memberVariableTypeHints = true,
              },
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              autoImportCompletions = true,
              disableOrganizeImports = true,
            },
            disableOrganizeImports = true,
            useLibraryCodeForTypes = true,
            autoImportCompletions = true,
            autoSearchPaths = true,
            typeCheckingMode = "standard",
          },
        },
      })
    end,
    ["pyright"] = function ()
      lspconfig.pyright.setup({
        before_init = function (_, config)
          config.settings.python.pythonPath = Get_python_venv() .. "/bin/python"
          config.settings.python.analysis.stubPath =
            vim.fs.joinpath(vim.fn.expand("~"), ".local", "src", "python-type-stubs", "stubs")
        end,
      })
    end,
    ["lua_ls"] = function ()
      lspconfig.lua_ls.setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            completion = {
              callSnippet = "Replace",
            },
          },
          diagnostics = { globals = { "vim", "bit", "pcall", "require", "print", "unpack" } },
          telemetry = { enable = false },
          workspace = {
            checkThirdParty = true,
            maxPreload = 10000,
            preloadFileSize = 1000,
            library = {
              vim.fn.expand "~/.local/share/nvim/site/pack/packer/start/neodev.nvim/types/stable",
              "/usr/share/nvim/runtime/lua",
              vim.fn.expand "~/.local/share/nvim/site/pack/packer/start/nvim-dap-ui/lua",
              vim.fn.expand "~/.config/nvim/lua",
              "${3rd}/luv/library",
              "${3rd}/luv/library"
            }
          },
        },
      })
    end,
    ["pylsp"] = function ()
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
    ["ts_ls"] = function ()
      local mason_registry = require("mason-registry")
      local vue_language_server_path = mason_registry
        .get_package("vue-language-server")
        :get_install_path() .. "/node_modules/@vue/language-server"
      lspconfig.ts_ls.setup({
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = "./node_modules/@vue/typescript-plugin",
              languages = { "javascript", "typescript", "vue" },
            },
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
      local get_typescript_server_path = function (root_dir)
        -- local global_ts = "$PNPM_HOME/global/5"
        local global_ts =
          vim.fn.expand("$HOME/.local/share/pnpm/global/5/node_modules/typescript/lib")
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
          -- vim.notify("Using global typescript")
          return global_ts
        end
      end
      lspconfig.volar.setup({
        capabilities = lsp_defaults.capabilities,
        init_options = {
          typescript = {
            tsdk = get_typescript_server_path(vim.fn.getcwd()),
          },
          vue = {
            hybridMode = true,
          },
        },
        on_new_config = function (new_config, new_root_dir)
          new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
        end,
      })
    end,
    ["texlab"] = function ()
      lspconfig.texlab.setup({
        settings = {
          texlab = {
            build = {
              args = { "-pdf", "-interaction", "nonstopmode", "-synctex", "1", "%f" },
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
              onSave = false,
            },
            formatterLineLength = 120,
            latexFormatter = "latexindent",
            latexindent = {
              modifyLineBreaks = false,
              replacement = "-rv",
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
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
    end,
    ["yamlls"] = function ()
      lsp_defaults.capabilities.textDocument.completion.completionItem.snippetSupport = true
      lspconfig.jsonls.setup({
        capabilities = lsp_defaults.capabilities,
        on_attach = lsp_defaults.on_attach,
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })
    end,
    ["ltex"] = function ()
      lspconfig.ltex.setup({
        capabilities = lsp_defaults.capabilities,
        filetypes = {
          "bib",
          "markdown",
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
            ["ltex-ls"] = {
              logLevel = "warning",
            },
          },
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
