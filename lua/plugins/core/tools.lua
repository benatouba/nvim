-- Core picker.
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
}
