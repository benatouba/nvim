return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
        dependencies = "telescope.nvim",
        config = function()
          pcall(require("telescope").load_extension, "fzf")
        end,
      },
    },
    lazy = true,
    keys = {
      { "<leader>b", "<cmd>Telescope buffers theme=dropdown<cr>", desc = "Buffers" },
      { "<leader>sB", "<cmd>Telescope file_browser<cr>", desc = "Browser" },
      { "<leader>sb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
      { "<leader>sC", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
      { "<leader>sf", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find File" },
      { "<leader>sg", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>so", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
      { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
      { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>st", "<cmd>Telescope live_grep<cr>", desc = "Text" },
    },
    config = function()
      require("ben.telescope").config()
    end,
  },
  {
    "DrKJeff16/project.nvim",
    keys = {
      { "<leader>sp", "<cmd>Telescope projects<cr>", desc = "Projects" },
    },
    dependencies = { "telescope.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    ---@module 'project'
    ---@type Project.Config.Options
    opts = {
      patterns = {
        ".git",
        "src",
        ">projects",
        ">scripts",
        "pyproject.toml",
        "package.json",
        "*.latexmain",
        "pillar",
        "=nvim",
      },
      lsp = { ignore = { "null-ls", "salt-lsp", "copilot" } },
      exclude_dirs = { "*/node_modules/*" },
    },
    cond = vim.fn.has("nvim-0.11") == 1,
    enabled = O.lsp,
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    enabled = O.language_parsing or O.lsp,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "InsertEnter" },
    keys = { "m", "'" },
    config = function()
      require("misc.harpoon").config()
      require("misc.harpoon").maps()
    end,
    enabled = O.misc and O.language_parsing,
  },
  {
    "stevearc/overseer.nvim",
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {
      dap = false,
    },
    enabled = O.misc,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("misc.toggleterm").config()
    end,
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>T", group = "+Terminal" },
      { "<leader>TT", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal" },
      { "<leader>Tt", "<cmd>ToggleTerm<cr>", desc = "Terminal (bot)" },
      { "<leader>gL", "<cmd>lua require('misc.toggleterm').LazyGit()<cr>", desc = "LazyGit" },
      {
        "<leader>Tb",
        "<cmd>lua require('misc.toggleterm').btop()<cr>",
        desc = "BTop",
      },
      { "<leader>Tv", 'yi"<cmd>lua P(vim.cmd[[p]])<cr>"', desc = "VisiData" },
      {
        "<leader>TV",
        "<cmd>lua require('misc.toggleterm').VisiData(vim.api.nvim_buf_get_name(0))<cr>",
        desc = "VisiData (File)",
      },
      { "<leader>Tu", "<cmd>lua require('misc.toggleterm').UpdateProject()<cr>", desc = "Update Project" },
    },
    enabled = O.misc,
  },
  {
    "yetone/avante.nvim",
    keys = {
      { "<leader>Aa", "<cmd>AvanteAsk<cr>", desc = "Avante Ask" },
      { "<leader>AC", "<cmd>AvanteChat<cr>", desc = "Avante Chat" },
    },
    version = false,
    opts = {
      provider = "copilot",
      providers = {
        gemini = {
          model = "gemini-2.5-pro-exp-03-25",
        },
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000,
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "gpt-5-mini",
          timeout = 30000,
          temperature = 0,
          extra_request_body = { max_tokens = 20480 },
        },
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-5",
          extra_request_body = {
            timeout = 45000,
            temperature = 0.75,
            max_completion_tokens = 8192,
          },
        },
      },
      file_selector = {
        provider = "telescope",
        provider_opts = {},
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
      "zbirenbaum/copilot.lua",
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    enabled = O.misc,
  },
  {
    "mistweaverco/kulala.nvim",
    keys = {
      { "<leader>Rs", desc = "Send request" },
      { "<leader>Ra", desc = "Send all requests" },
      { "<leader>Rp", desc = "Open scratchpad" },
    },
    ft = { "http", "rest" },
    opts = {
      global_keymaps = false,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    },
    enabled = O.webdev and O.misc,
  },
}
