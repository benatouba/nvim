return {
  {
    "folke/snacks.nvim",
    enabled = true,
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      animate = { enabled = false },
      bigfile = { enabled = false },
      keys = {
        {
          "<leader>sc",
          function()
            Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
          end,
          desc = "Find Config File",
        },
      },
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
      input = { enabled = false },
      notifier = {
        enabled = vim.env.NVIM == nil,
      },
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

  -- Colorize hex and other colors in code
  {
    "nvchad/nvim-colorizer.lua",
    opts = require("ben.colorizer").opts,
    lazy = true,
    event = "BufReadPost",
    enabled = O.misc,
  },

  -- Icons and visuals
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
      require("nvim-web-devicons").set_icon({
        nvim = {
          icon = "",
          color = "#67B25E",
          cterm_color = "83",
          name = "Neovim",
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = require("ben.indent-blankline").opts,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-treesitter",
    enabled = O.language_parsing,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "AndreM222/copilot-lualine",
        enabled = tonumber(string.sub(Capture("node --version"), 2, 3)) >= 20 and O.copilot,
      },
    },
    config = function()
      require("ben.lualine").config()
    end,
    enabled = true,
  },
  {
    "romgrk/barbar.nvim",
    opts = require("ui.barbar").opts,
    init = require("ui.barbar").init,
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
    enabled = O.misc,
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    init = function()
      -- Patch lib.attach before plugin/rainbow-delimiters.lua sets up autocommands.
      -- Must be in init (not config) so it runs before the plugin's runtime files.
      local lib = require("rainbow-delimiters.lib")
      local orig_attach = lib.attach
      lib.attach = function(bufnr, ...)
        local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
        if not ok or not parser then
          return
        end
        return orig_attach(bufnr, ...)
      end
    end,
    config = function()
      require("ui.rainbow-delimiters").config()
    end,
    event = "VeryLazy",
    enabled = O.language_parsing,
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("ui.noice").config()
    end,
    keys = {
      {
        "<leader>sn",
        "<cmd>Noice telescope<cr>",
        desc = "Notifications",
      },
      {
        "<leader>sN",
        "<cmd>Noice<cr>",
        desc = "Messages",
      },
    },
    enabled = true,
  },
  {
    "folke/todo-comments.nvim",
    opts = {},
    lazy = false,
    enabled = O.language_parsing,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "norg", "org", "rmd", "rst", "tex", "Avante" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { "markdown", "norg", "org", "rmd", "Avante" },
      completions = { lsp = { enabled = true } },
    },
    enabled = O.markdown,
  },
  {
    "brianhuster/live-preview.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
}
