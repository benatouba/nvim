-- Core Git: signs and hunks.
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>gB", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" },
      { "<leader>gv", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this (gitsigns)" },
      { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
      { "<leader>gT", "<cmd>Gitsigns toggle_deleted<cr>", desc = "Toggle Deleted" },
      { "<leader>gh", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
      { "<leader>gj", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
      { "<leader>gk", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
      { "<leader>gQ", "<cmd>Gitsigns setloclist<cr>", desc = "Set loclist" },
      { "<leader>gq", "<cmd>Gitsigns setqflist<cr>", desc = "Set quickfix" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
      { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
    },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "┆" },
        untracked = { text = "┆" },
      },
      signcolumn = true,
      numhl = true,
      linehl = false,
      word_diff = false,
      watch_gitdir = { interval = 1000, follow_files = true },
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = { virt_text = true, virt_text_pos = "right_align", delay = 500 },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      auto_attach = true,
      max_file_length = 10000,
      preview_config = { border = "single", style = "minimal", relative = "cursor", row = 0, col = 1 },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, l, r, opts)
          vim.keymap.set(mode, l, r, vim.tbl_extend("force", { buffer = bufnr }, opts or {}))
        end
        -- ]g / [g fall through to the built-in diff-mode motions inside :diffthis
        map("n", "]g", function()
          if vim.wo.diff then
            return "]g"
          end
          vim.schedule(gs.next_hunk)
          return "<Ignore>"
        end, { expr = true, desc = "Next git hunk" })
        map("n", "[g", function()
          if vim.wo.diff then
            return "[g"
          end
          vim.schedule(gs.prev_hunk)
          return "<Ignore>"
        end, { expr = true, desc = "Previous git hunk" })
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git hunk" })
      end,
    },
  },
}
