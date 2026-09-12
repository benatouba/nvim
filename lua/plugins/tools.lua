-- Pickers, projects, diagnostics list, marks, tasks, terminals, HTTP client, env masking.
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
      },
    },
    keys = {
      { "<leader>b", "<cmd>Telescope buffers theme=dropdown<cr>", desc = "Buffers" },
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
    opts = function()
      return require("plugins.configs.telescope").opts()
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("ben_telescope", { clear = true }),
        pattern = "TelescopePreviewerLoaded",
        callback = function()
          vim.opt_local.wrap = true
        end,
      })
    end,
  },
  {
    "DrKJeff16/project.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>sp",
        function()
          require("telescope").load_extension("projects")
          vim.cmd("Telescope projects")
        end,
        desc = "Projects",
      },
    },
    init = function()
      -- write_history() truncates the history file with open('w') *before* it
      -- encodes, so a failed encode or an nvim that dies mid-write leaves it at
      -- zero bytes. Its re-seed guard is `if not Path.exists(path)`, which only
      -- covers a *missing* file, so an empty one makes every BufEnter throw
      -- "Unable to decode JSON data!" until it is repaired by hand.
      local hist = vim.fs.joinpath(vim.fn.stdpath("data"), "project_nvim", "project_history.json")
      local stat = vim.uv.fs_stat(hist)
      if not stat then
        return
      end

      local ok = stat.size > 0
      if ok then
        ok = pcall(vim.json.decode, table.concat(vim.fn.readfile(hist), "\n"))
      end
      if not ok then
        vim.fn.writefile({ "[]" }, hist)
      end
    end,
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
      lsp = { ignore = { "salt-lsp", "copilot" } },
      exclude_dirs = { "*/node_modules/*" },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {},
    keys = {
      {
        "]D",
        function()
          require("trouble").next({ skip_groups = true, jump = true })
        end,
        desc = "Next trouble item",
      },
      {
        "[D",
        function()
          require("trouble").prev({ skip_groups = true, jump = true })
        end,
        desc = "Previous trouble item",
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = function()
      local h = function()
        return require("harpoon")
      end
      local keys = {
        {
          "<C-e>",
          function()
            h().ui:toggle_quick_menu(h():list())
          end,
          desc = "Toggle harpoon menu",
        },
        {
          "<leader>mm",
          function()
            h():list():add()
          end,
          desc = "Add mark",
        },
        {
          "<leader>mn",
          function()
            h():list():next()
          end,
          desc = "Next mark",
        },
        {
          "<leader>mp",
          function()
            h():list():prev()
          end,
          desc = "Prev mark",
        },
        {
          "]m",
          function()
            h():list():next()
          end,
          desc = "Next mark",
        },
        {
          "[m",
          function()
            h():list():prev()
          end,
          desc = "Prev mark",
        },
        { "<leader>mt", "<cmd>Telescope harpoon marks<cr>", desc = "Toggle menu" },
      }
      for i = 1, 10 do
        table.insert(keys, {
          "<leader>m" .. (i % 10),
          function()
            h():list():select(i)
          end,
          desc = "Go to mark " .. i,
        })
      end
      return keys
    end,
    opts = { settings = { save_on_toggle = true, save_on_change = true } },
    config = function(_, opts)
      require("harpoon").setup(opts)
      require("telescope").load_extension("harpoon")
    end,
  },
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerOpen", "OverseerInfo", "OverseerBuild" },
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = { dap = false },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = {
      "ToggleTerm",
      "TermExec",
      "ToggleTermSendVisualLines",
      "ToggleTermSendCurrentLine",
      "DirtBoot",
      "TidalBoot",
    },
    keys = {
      { "<leader>t", "<cmd>ToggleTermSendVisualLines<cr>", mode = "v", desc = "Send to terminal" },
      { "<leader>TT", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal" },
      { "<leader>Tt", "<cmd>ToggleTerm direction=tab<cr>", desc = "Terminal (Tab)" },
      { "<leader>Tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Terminal (Vert)" },
      { "<leader>Tx", "<cmd>ToggleTerm<cr>", desc = "Terminal (bot)" },
      {
        "<leader>Tb",
        function()
          require("plugins.configs.toggleterm").btop()
        end,
        desc = "BTop",
      },
      {
        "<leader>TV",
        function()
          require("plugins.configs.toggleterm").visidata(vim.api.nvim_buf_get_name(0))
        end,
        desc = "VisiData (File)",
      },
      {
        "<leader>Tu",
        function()
          require("plugins.configs.toggleterm").update_project()
        end,
        desc = "Update Project",
      },
      {
        "<leader>gL",
        function()
          require("plugins.configs.toggleterm").lazygit()
        end,
        desc = "LazyGit",
      },
      { "<leader>Md", "<cmd>DirtBoot<cr>", desc = "Dirt Sampler" },
      { "<leader>Mr", "<cmd>TidalBoot<cr>", desc = "Tidal REPL" },
    },
    opts = function()
      return require("plugins.configs.toggleterm").opts
    end,
    config = function(_, opts)
      require("toggleterm").setup(opts)
      local tt = require("plugins.configs.toggleterm")
      vim.api.nvim_create_user_command("DirtBoot", tt.dirt_boot, { desc = "Boot the dirt sampler" })
      vim.api.nvim_create_user_command("TidalBoot", tt.tidal_boot, { desc = "Boot tidal ghci" })
    end,
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    keys = {
      {
        "<leader>Rs",
        function()
          require("kulala").run()
        end,
        ft = { "http", "rest" },
        desc = "Send request",
      },
      {
        "<leader>Ra",
        function()
          require("kulala").run_all()
        end,
        ft = { "http", "rest" },
        desc = "Send all requests",
      },
      {
        "<leader>Rp",
        function()
          require("kulala").scratchpad()
        end,
        desc = "Open scratchpad",
      },
    },
    opts = { global_keymaps = false, global_keymaps_prefix = "<leader>R", kulala_keymaps_prefix = "" },
  },
  {
    "ph1losof/shelter.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      modules = { files = true, telescope_previewer = true, snacks_previewer = true, oil_previewer = true },
    },
  },
}
