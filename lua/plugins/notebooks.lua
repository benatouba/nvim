-- Notebooks and REPLs: jupynium (Jupyter sync), jupytext (.ipynb as text), iron (REPL).
return {
  {
    "kiyoon/jupynium.nvim",
    build = "uv pip install user . --python=$HOME/.virtualenvs/jupynium/bin/python",
    ft = "python",
  },
  {
    "goerz/jupytext.nvim",
    version = "0.2.0",
    -- must be loaded before an .ipynb buffer is read
    event = { { event = "BufReadCmd", pattern = "*.ipynb" } },
    opts = {},
  },
  {
    "hkupty/iron.nvim",
    main = "iron.core",
    cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide", "IronSend" },
    keys = {
      { "<leader>rs", "<cmd>IronRepl<cr>", desc = "REPL open" },
      { "<leader>rr", "<cmd>IronRestart<cr>", desc = "REPL restart" },
      { "<leader>rF", "<cmd>IronFocus<cr>", desc = "REPL focus" },
      { "<leader>rh", "<cmd>IronHide<cr>", desc = "REPL hide" },
      -- the send/mark keys below are set by iron itself once it is loaded
      { "<leader>rc", mode = { "n", "x" }, desc = "REPL send motion/selection" },
      { "<leader>rf", desc = "REPL send file" },
      { "<leader>rl", desc = "REPL send line" },
    },
    opts = function()
      return {
        config = {
          scratch_repl = true,
          repl_definition = {
            markdown = { command = { "python" } },
            python = { command = { "python" } },
          },
          repl_open_cmd = require("iron.view").right(60),
        },
        keymaps = {
          send_motion = "<leader>rc",
          visual_send = "<leader>rc",
          send_file = "<leader>rf",
          send_line = "<leader>rl",
          send_mark = "<leader>rm",
          mark_motion = "<leader>rmc",
          mark_visual = "<leader>rmc",
          remove_mark = "<leader>rmd",
          cr = "<leader>r<cr>",
          interrupt = "<leader>r<space>",
          exit = "<leader>rq",
          clear = "<leader>rx",
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      }
    end,
  },
}
