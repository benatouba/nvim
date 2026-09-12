-- UI: dashboard/pickers/notifications (snacks), statusline, bufferline, cmdline, colours.
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      animate = { enabled = false },
      bigfile = { enabled = false },
      dashboard = {
        enabled = vim.env.NVIM == nil,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "t", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            {
              icon = " ",
              key = "o",
              desc = "Orgmode",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.expand('~') .. '/documents/vivere/org'})",
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },
      rename = { enabled = false },
      indent = { enabled = false },
      input = { enabled = true }, -- vim.ui.input
      picker = { enabled = true }, -- also installs vim.ui.select (ui_select defaults to true)
      notifier = { enabled = vim.env.NVIM == nil },
      notify = { enabled = vim.env.NVIM == nil },
      quickfile = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      terminal = { enabled = false },
      toggle = { enabled = false },
      win = { enabled = false },
      words = { enabled = true },
      zen = { enabled = true },
    },
    init = function()
      -- LSP progress as a single updating notification
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
          vim.schedule(function()
            local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            vim.notify(vim.lsp.status(), "info", {
              id = "lsp_progress",
              title = "LSP Progress",
              opts = function(notif)
                notif.icon = ev.data.params.value and ev.data.params.value.kind == "end" and " "
                  or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
              end,
            })
          end)
        end,
      })
    end,
    keys = {
      {
        "<leader>sc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File",
      },
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Zen Mode",
      },
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override = {
        nvim = { icon = "", color = "#67B25E", cterm_color = "83", name = "Neovim" },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "AndreM222/copilot-lualine",
        enabled = function()
          return vim.fn.executable("node") == 1
        end,
      },
    },
    opts = function()
      return require("plugins.configs.lualine").opts()
    end,
  },
  {
    "romgrk/barbar.nvim",
    event = "VeryLazy",
    -- <C-l>/<C-h> in config/keymaps.lua go through these commands too.
    cmd = { "BufferNext", "BufferPrevious", "BufferClose", "BufferPick", "BufferRestore" },
    keys = { { "<leader>ac", "<cmd>BufferClose<CR>", desc = "Close Buffer" } },
    dependencies = { "lewis6991/gitsigns.nvim", "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.g.barbar_auto_setup = false -- setup() is called with `opts` below
    end,
    opts = {
      animation = true,
      auto_hide = 1,
      clickable = false,
      tabpages = true,
      highlight_alternate = true,
      exclude_ft = { "oil" },
      icons = {
        gitsigns = {
          added = { enabled = true, icon = "+" },
          changed = { enabled = true, icon = "~" },
          deleted = { enabled = true, icon = "-" },
        },
        inactive = { button = false },
        button = false,
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>sn", "<cmd>Noice telescope<cr>", desc = "Notifications" },
      { "<leader>sN", "<cmd>Noice<cr>", desc = "Messages" },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        mode = { "n", "i", "s" },
        expr = true,
        desc = "Scroll hover forward",
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        mode = { "n", "i", "s" },
        expr = true,
        desc = "Scroll hover backward",
      },
    },
    opts = {
      notify = { enabled = true, view = "notify" },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = false,
        },
        hover = { enabled = true },
        signature = { enabled = true },
      },
      presets = {
        bottom_search = true, -- classic bottom cmdline for search
        command_palette = false,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      cmdline = { enabled = true, view = "cmdline" },
      routes = {
        { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
        { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
        { filter = { event = "notify", min_height = 15 }, view = "split" },
      },
    },
  },
  {
    "nvchad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
    keys = { { "<leader>cC", "<cmd>ColorizerToggle<cr>", desc = "Colorizer" } },
    opts = {
      lazy_load = false,
      user_default_options = {
        names_opts = { uppercase = true },
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        tailwind = true,
        tailwind_opts = { update_names = true },
        sass = { enable = true, parsers = { "css" } },
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { highlight = { "Whitespace" }, tab_char = "" },
      scope = { enabled = false },
      whitespace = { highlight = { "Whitespace" }, remove_blankline_trail = true },
      exclude = {
        buftypes = { "terminal", "fugitive", "neogit" },
        filetypes = { "help", "dashboard", "neogitstatus", "fugitive" },
      },
    },
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    main = "rainbow-delimiters.setup",
    config = function(_, opts)
      -- Skip buffers without a treesitter parser. The plugin's autocommands look up
      -- lib.attach at call time, so wrapping it here (after load) is enough - doing it
      -- in init would require the module and load the plugin at startup.
      local lib = require("rainbow-delimiters.lib")
      local orig_attach = lib.attach
      lib.attach = function(bufnr, ...)
        local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
        if not ok or not parser then
          return
        end
        return orig_attach(bufnr, ...)
      end
      require("rainbow-delimiters.setup").setup(opts)
    end,
    opts = {
      strategy = {
        [""] = "rainbow-delimiters.strategy.global",
        vim = "rainbow-delimiters.strategy.local",
      },
      query = { [""] = "rainbow-delimiters", lua = "rainbow-blocks" },
      priority = { [""] = 110, lua = 210 },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoTelescope", "TodoTrouble", "TodoQuickFix", "TodoLocList" },
    opts = {},
    keys = {
      {
        "]T",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[T",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "norg", "org", "rmd", "rst", "tex" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { "markdown", "norg", "org", "rmd" },
      completions = { lsp = { enabled = true } },
    },
  },
  {
    "brianhuster/live-preview.nvim",
    cmd = { "LivePreview" },
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
}
