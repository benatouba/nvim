return {
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    keys = {
      { "<leader>od", "<cmd>Obsidian dailies<CR>", desc = "Dailies", remap = false },
      { "<leader>on", "<cmd>Obsidian new<CR>", desc = "New note", remap = false },
      { "<leader>oN", "<cmd>Obsidian new_from_template<CR>", desc = "New note from Template", remap = false },
      { "<leader>ot", "<cmd>Obsidian today<CR>", desc = "Today note", remap = false },
      { "<leader>oT", "<cmd>Obsidian tomorrow<CR>", desc = "Tomorrow note", remap = false },
      { "<leader>os", "<cmd>Obsidian search<CR>", desc = "Search Workspace", remap = false },
      { "<leader>or", "<cmd>Obsidian rename<CR>", desc = "Rename", remap = false },
      { "<leader>ov", "<cmd>Obsidian workspace vivere<CR>", desc = "Vivere (Workspace)", remap = false },
      { "<leader>ow", "<cmd>Obsidian workspace work<CR>", desc = "Work (Workspace)", remap = false },
      { "<leader>oy", "<cmd>Obsidian yesterday<CR>", desc = "Yesterday note", remap = false },
      { "<localleader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Backlinks", remap = false },
      { "<localleader>ol", "<cmd>Obsidian links<CR>", desc = "Links", remap = false },
      { "<localleader>oo", "<cmd>Obsidian open<CR>", desc = "Open in Obsidian", remap = false },
      { "<localleader>op", "<cmd>Obsidian paste_img<CR>", desc = "Paste image", remap = false },
      { "<localleader>or", "<cmd>Obsidian rename<CR>", desc = "Rename", remap = false },
      { "<localleader>os", "<cmd>Obsidian quick_switch<CR>", desc = "Quick switch", remap = false },
      { "<localleader>ot", "<cmd>Obsidian tags<CR>", desc = "Tags", remap = false },
      { "<localleader>oT", "<cmd>Obsidian template<CR>", desc = "Template", remap = false },
      { "<C-Space>", "<cmd>Obsidian toggle_checkbox<CR>", desc = "Toggle Checkbox", remap = false },
    },
    lazy = true,
    version = "*",
    config = function()
      require("management.obsidian").config()
    end,
    enabled = O.obsidian,
  },
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      "danilshvalov/org-modern.nvim",
      {
        "akinsho/org-bullets.nvim",
        config = function()
          require("org-bullets").setup()
        end,
      },
    },
    ft = { "org" },
    keys = {
      {
        "<leader>oa",
        "<cmd>lua require('orgmode').action('agenda.prompt')<CR>",
        desc = "org-Agenda",
        nowait = true,
        remap = false,
      },
      {
        "<leader>oc",
        "<cmd>lua require('orgmode').action('capture.prompt')<CR>",
        desc = "org-Capture",
        nowait = true,
        remap = false,
      },
    },
    enabled = O.project_management,
    config = function()
      require("management.orgmode").config()
    end,
  },
  {
    "renerocksai/telekasten.nvim",
    event = "BufReadPost",
    dependencies = { "telescope.nvim", "renerocksai/calendar-vim" },
    config = function()
      require("management.telekasten").config()
    end,
    enabled = false,
  },
}
