return {
  {
    "lewis6991/gitsigns.nvim",
    opts = require("git.gitsigns").opts,
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>g", group = "Git" },
      { "<leader>gB", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" },
      { "<leader>gD", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this" },
      { "<leader>gR", "<cmd>lua require'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
      { "<leader>gT", "<cmd>lua require'gitsigns'.toggle_deleted()<cr>", desc = "Toggle Deleted" },
      { "<leader>gh", "<cmd>lua require'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
      { "<leader>gj", "<cmd>lua require'gitsigns.actions'.next_hunk()<cr>", desc = "Next Hunk" },
      { "<leader>gk", "<cmd>lua require'gitsigns.actions'.prev_hunk()<cr>", desc = "Prev Hunk" },
      { "<leader>gl", "<cmd>Gitsigns setloclist<cr>", desc = "Set loclist" },
      { "<leader>gq", "<cmd>Gitsigns setqflist<cr>", desc = "Set quickfix" },
      { "<leader>gr", "<cmd>lua require'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
      { "<leader>gs", "<cmd>lua require'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk" },
    },
    enabled = O.git,
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "diffview.nvim" },
    keys = {
      { "<leader>g", group = "+Git", nowait = false, remap = false },
      { "<leader>gb", "<cmd>Neogit branch<cr>", desc = "Branch (Menu)", nowait = false, remap = false },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Commit (Menu)", nowait = false, remap = false },
      { "<leader>gC", "<cmd>Neogit cherry_pick<cr>", desc = "Cherry Pick (Menu)", nowait = false, remap = false },
      { "<leader>gD", "<cmd>Neogit diff<cr>", desc = "Diff (Menu)", nowait = false, remap = false },
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit (alias)", nowait = false, remap = false },
      { "<leader>gl", "<cmd>NeogitLogCurrent<cr>", desc = "Log", nowait = false, remap = false },
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit", nowait = false, remap = false },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Pull", nowait = false, remap = false },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Push", nowait = false, remap = false },
    },
    config = function()
      require("git.neogit").config()
    end,
    enabled = O.git,
  },
  {
    "pwntester/octo.nvim",
    keys = {
      { "<leader>go", "<cmd>Octo pr list<cr>", desc = "Octo PR List" },
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "Octo Issue List" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup()
    end,
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gd", "<cmd>lua DiffviewToggle()<cr>", desc = "Diffview" },
      { "<leader>gS", "<cmd>DiffviewFileHistory -g --range=stash<cr>", desc = "Check Stash" },
      { "<leader>gm", "<cmd>lua DiffviewToggle('DiffviewOpen master..HEAD')<cr>", desc = "Diff master" },
      {
        "<leader>gf",
        "<cmd>lua DiffviewToggle('DiffviewFileHistory %')<cr>",
        desc = "Open diffs for current File",
      },
    },
    cmd = "DiffviewOpen",
    config = function()
      require("git.diffview").config()
    end,
  },
}
