-- Git: signs/hunks (gitsigns), porcelain (neogit), diffs (diffview), GitHub (octo).

-- Open Diffview with `cmd`, or close it if a view is already open.
local function diffview_toggle(cmd)
  if next(require("diffview.lib").views) == nil then
    vim.cmd(cmd or "DiffviewOpen")
  else
    vim.cmd("DiffviewClose")
  end
end

return {
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit", "NeogitLogCurrent" },
    dependencies = { "nvim-lua/plenary.nvim", "dlyongemallo/diffview-plus.nvim", "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>gb", "<cmd>Neogit branch<cr>", desc = "Branch (Menu)" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Commit (Menu)" },
      { "<leader>gC", "<cmd>Neogit cherry_pick<cr>", desc = "Cherry Pick (Menu)" },
      { "<leader>gD", "<cmd>Neogit diff<cr>", desc = "Diff (Menu)" },
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit (alias)" },
      { "<leader>gl", "<cmd>NeogitLogCurrent<cr>", desc = "Log" },
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Pull" },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Push" },
    },
    opts = {
      process_spinner = true,
      env = { GIT_PAGER = "cat" },
      integrations = { diffview = true, telescope = true },
      commit_editor = { kind = "auto" },
      disable_commit_confirmation = true,
      graph_style = "unicode",
      git_services = {
        ["gitlab.klima.tu-berlin.de"] = {
          pull_request = "https://gitlab.klima.tu-berlin.de/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
          commit = "https://gitlab.klima.tu-berlin.de/${owner}/${repository}/-/commit/${oid}",
          tree = "https://gitlab.klima.tu-berlin.de/${owner}/${repository}/-/tree/${branch_name}?ref_type=heads",
        },
      },
    },
  },
  {
    "dlyongemallo/diffview-plus.nvim",
    version = "*",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      {
        "<leader>gd",
        function()
          diffview_toggle()
        end,
        desc = "Diffview",
      },
      { "<leader>gS", "<cmd>DiffviewFileHistory -g --range=stash<cr>", desc = "Check Stash" },
      {
        "<leader>gm",
        function()
          diffview_toggle("DiffviewOpen master..HEAD")
        end,
        desc = "Diff master",
      },
      {
        "<leader>gf",
        function()
          diffview_toggle("DiffviewFileHistory %")
        end,
        desc = "Open diffs for current File",
      },
    },
    opts = function()
      local actions = require("diffview.config").actions
      return {
        diff_binaries = false,
        enhanced_diff_hl = true,
        hide_merge_artifacts = true,
        clean_up_buffers = true,
        auto_close_on_empty = true,
        diffopt = { algorithm = "histogram" },
        default_args = { DiffviewOpen = { "--imply-local" } },
        file_panel = { show_branch_name = true, always_show_sections = true },
        view = {
          default = { layout = "diff2_horizontal", winbar_info = true, disable_diagnostics = true },
          merge_tool = { layout = "diff4_mixed", disable_diagnostics = true, winbar_info = true },
          cycle_layouts = {
            merge_tool = { "diff4_mixed", "diff3_mixed", "diff3_horizontal", "diff1_plain" },
          },
          file_history = { layout = "diff2_horizontal", winbar_info = true },
        },
        keymaps = {
          view = { { "n", "q", actions.close, { desc = "Close" } } },
          file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close" } } },
          file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close" } } },
        },
      }
    end,
  },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    keys = {
      { "<leader>go", "<cmd>Octo pr list<cr>", desc = "Octo PR List" },
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "Octo Issue List" },
    },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
}
