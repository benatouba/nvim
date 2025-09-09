local isOk, gitsigns = pcall(require, "gitsigns")
if not isOk then
  vim.notify("Gitsigns not okay")
  return
end

local M = {}

M.config = function ()
  gitsigns.setup({
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
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "right_align",
      delay = 500,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,  -- Use default
    auto_attach = true,
    max_file_length = 10000,  -- Disable if file is longer than this (in lines)
    preview_config = {
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1
    },
    on_attach = function (bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]g", "", {
        desc = "Git hunk",
        callback = function ()
          if vim.wo.diff then
            return "]g"
          end
          vim.schedule(function ()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end,
        expr = true,
      })

      map("n", "[g", "", {
        desc = "Git hunk",
        callback = function ()
          if vim.wo.diff then
            return "[g"
          end
          vim.schedule(function ()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end,
        expr = true,
      })
      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end,
  })
end

return M
