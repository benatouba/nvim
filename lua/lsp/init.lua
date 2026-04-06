local M = {}

M.config = function()
  vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

  -- vim.lsp.config() calls have the highest priority and cannot be
  -- overwritten by lsp/*.lua runtime files (including nvim-lspconfig defaults).

  -- Resolve vue-language-server and TypeScript SDK paths.
  -- On NixOS (devenv), derive from binaries in $PATH; on other systems, use Mason.
  local vue_language_server_path, tsdk

  local function workspace_tsdk(root_dir)
    if not root_dir or root_dir == "" then
      return nil
    end
    local candidate = root_dir .. "/node_modules/typescript/lib"
    if vim.fn.isdirectory(candidate) == 1 then
      return candidate
    end
    return nil
  end
  if O.is_nixos then
    local vue_ls_bin = vim.fn.exepath("vue-language-server")
    if vue_ls_bin ~= "" then
      local vue_ls_pkg = vim.fn.fnamemodify(vue_ls_bin, ":h:h")
      vue_language_server_path = vue_ls_pkg .. "/lib/language-tools/packages/language-server"
    end
    local vtsls_bin = vim.fn.exepath("vtsls")
    if vtsls_bin ~= "" then
      local vtsls_pkg = vim.fn.fnamemodify(vtsls_bin, ":h:h")
      local ts_glob = vim.fn.glob(vtsls_pkg .. "/lib/**/typescript/lib", true)
      if ts_glob ~= "" then
        tsdk = vim.split(ts_glob, "\n")[1]
      end
    end
  else
    vue_language_server_path = vim.fn.stdpath("data")
      .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
    tsdk = vim.fn.stdpath("data")
      .. "/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib"
  end

  vim.lsp.config("vtsls", {
    settings = {
      vtsls = {
        autoUseWorkspaceTsdk = true,
        tsserver = {
          globalPlugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_language_server_path,
              languages = { "vue" },
              configNamespace = "typescript",
              enableForWorkspaceTypeScriptVersions = true,
            },
          },
        },
      },
    },
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    on_new_config = function(new_config, root_dir)
      new_config.settings = new_config.settings or {}
      new_config.settings.typescript = new_config.settings.typescript or {}
      new_config.settings.typescript.tsdk = workspace_tsdk(root_dir) or tsdk
    end,
    on_attach = function(client)
      if vim.bo.filetype == "vue" then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end,
  })

  vim.lsp.config("vue_ls", {
    init_options = {
      typescript = {
        tsdk = tsdk,
      },
    },
    on_new_config = function(new_config, root_dir)
      new_config.init_options = new_config.init_options or {}
      new_config.init_options.typescript = new_config.init_options.typescript or {}
      new_config.init_options.typescript.tsdk = workspace_tsdk(root_dir) or tsdk
    end,
    on_init = function(client)
      local retries = 0

      local function find_ts_client(bufnr)
        local ts_client = vim.lsp.get_clients({ bufnr = bufnr, name = "vtsls" })[1]
          or vim.lsp.get_clients({ bufnr = bufnr, name = "ts_ls" })[1]
          or vim.lsp.get_clients({ bufnr = bufnr, name = "typescript-tools" })[1]
        if ts_client then
          return ts_client
        end
        return vim.lsp.get_clients({ name = "vtsls" })[1]
          or vim.lsp.get_clients({ name = "ts_ls" })[1]
          or vim.lsp.get_clients({ name = "typescript-tools" })[1]
      end

      local function typescriptHandler(_, result, context)
        local ts_client = find_ts_client(context.bufnr)

        if not ts_client then
          if retries <= 50 then
            retries = retries + 1
            vim.defer_fn(function()
              typescriptHandler(_, result, context)
            end, 200)
          else
            vim.notify(
              "Could not find `vtsls`, `ts_ls`, or `typescript-tools` lsp client required by `vue_ls`.",
              vim.log.levels.ERROR
            )
          end
          return
        end

        retries = 0
        local param = result[1]
        local id, command, payload = param[1], param[2], param[3]
        ts_client:exec_cmd({
          title = "vue_request_forward",
          command = "typescript.tsserverRequest",
          arguments = {
            command,
            payload,
          },
        }, { bufnr = context.bufnr }, function(_, r)
          local response_data = { { id, r and r.body } }
          ---@diagnostic disable-next-line: param-type-mismatch
          client:notify("tsserver/response", response_data)
        end)
      end

      client.handlers["tsserver/request"] = typescriptHandler
    end,
  })

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
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then
        vim.notify("LSP client not found for bufnr: " .. bufnr, vim.log.levels.ERROR)
        return
      end
      local isOk, wk = pcall(require, "which-key")
      if not isOk then
        vim.notify("which-key not okay in lspconfig")
        return
      end
      if client.server_capabilities.completionProvider then
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      end
      if client.name == "basedpyright" then
        client.server_capabilities.declarationProvider = true
        client.server_capabilities.definitionProvider = true
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        client.server_capabilities.hoverProvider = true
        client.server_capabilities.referencesProvider = true
        client.server_capabilities.renameProvider = false
      -- elseif client.name == "texlab" then
      --   -- Disable in favour of Conform
      --   client.server_capabilities.documentFormattingProvider = true
      --   client.server_capabilities.documentRangeFormattingProvider = true
      elseif client.name == "ty" then
        client.server_capabilities.callHierarchyProvider = false
        client.server_capabilities.codeActionProvider = true
        client.server_capabilities.codeLensProvider = false
        client.server_capabilities.colorProvider = false
        client.server_capabilities.declarationProvider = true
        client.server_capabilities.definitionProvider = true
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentHighlightProvider = true
        client.server_capabilities.documentLinkProvider = false
        client.server_capabilities.documentOnTypeFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        client.server_capabilities.documentSymbolProvider = true
        client.server_capabilities.foldingRangeProvider = false
        client.server_capabilities.hoverProvider = true
        client.server_capabilities.implementationProvider = false
        client.server_capabilities.referencesProvider = true
        client.server_capabilities.renameProvider = true
        -- client.server_capabilities.semanticTokensProvider = false
        client.server_capabilities.typeDefinitionProvider = true
        client.server_capabilities.typeHierarchyProvider = false
        client.server_capabilities.workspaceSymbolProvider = true
      elseif client.name == "mutt_ls" then
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
      elseif client.name == "ruff" then
        -- Disable hover in favour of pyright
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.definitionProvider = false
      elseif client.name == "r_language_server" then
        client.server_capabilities.completionProvider = false
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
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
      if client.server_capabilities.semanticTokensProvider then
        vim.lsp.semantic_tokens.enable(true, { bufnr = event.buf })
      end
      vim.keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.completion.trigger()<cr>")
      wk.add({
        {
          { buffer = bufnr },
          { "<C-K>", vim.lsp.buf.signature_help, desc = "Signature", mode = { "n", "i" } },
          { "<F2>", vim.lsp.buf.rename, desc = "Rename" },
          { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
          { "<leader>lc", "<cmd>e $HOME/.config/nvim/lua/lsp/init.lua<cr>", desc = "Config" },
          { "<leader>lC", "<cmd>LspCapabilities<cr>", desc = "Server Capabilities" },
          { "<leader>lI", "<cmd>checkhealth vim.lsp<cr>", desc = "Health" },
          { "<leader>lD", "<cmd>Telescope lsp_declarations<cr>", desc = "Declarations" },
          { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
          { "<leader>lF", "<cmd>lua vim.lsp.buf.format({ async = false })<CR>", desc = "Format Document (Sync)" },
          { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
          { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens" },
          { "<leader>lL", "<cmd>LspLog<CR>", desc = "Logs", icon = { icon = " ", color = "green" } },
          { "<leader>lq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
          { "<leader>lr", "<cmd>lsp restart<cr>", desc = "Restart Server" },
          {
            "<leader>lR",
            "<cmd>lua vim.lsp.buf.code_action({context = {only = {'refactor'}}})<cr>",
            desc = "Refactor",
          },
          {
            "<leader>lv",
            function()
              vim.diagnostic.open_float(0, { scope = "line", border = "rounded", source = true })
            end,
            desc = "Line Diagnostics",
          },
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
end
return M
