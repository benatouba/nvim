-- AI: copilot ghost text (accepted via <C-a>/<C-s>/<C-d>) and sidekick (NES + CLI agents).
return {
  {
    "zbirenbaum/copilot.lua",
    enabled = function()
      return vim.fn.executable("node") == 1
    end,
    event = "InsertEnter",
    cmd = "Copilot",
    keys = {
      {
        "<M-g>",
        function()
          require("copilot.panel").open()
        end,
        mode = "i",
        desc = "Copilot panel",
      },
    },
    opts = {
      panel = {
        enabled = false,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-cr>",
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.3,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 150,
        -- Buffer-local pass-through maps: with no ghost text visible each key keeps its
        -- previous meaning (<C-a> insert last text, <C-s> LSP signature help, <C-d> dedent).
        keymap = {
          accept_word = "<C-a>",
          accept_line = "<C-s>",
          accept = "<C-d>",
          next = "<M-j>",
          prev = "<M-k>",
          dismiss = "<M-e>",
        },
      },
      filetypes = {
        vue = true,
        nix = true,
        yaml = true,
        markdown = true,
        help = false,
        dotenv = false,
        gitcommit = true,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        TelescopePrompt = false,
        sls = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), ".*user.*") then
            -- disable for user files
            return false
          end
          return true
        end,

        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
            -- disable for .env files
            return false
          end
          return true
        end,
        ["."] = false,
      },
      -- The plugin's default downloads a glibc-linked native server that does not run
      -- on NixOS.  Use the one the system provides (nixpkgs copilot-language-server,
      -- on PATH via the neovim wrapper); a name alone means "resolve via PATH".
      server = {
        type = "binary",
        custom_server_filepath = "copilot-language-server",
      },
      server_opts_overrides = {},
    },
  },
  {
    "folke/sidekick.nvim",
    event = "VeryLazy", -- next-edit suggestions need the plugin resident, not only its keys
    opts = {
      cli = { mux = { backend = "tmux", enabled = true } },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function()
          require("sidekick.cli").focus()
        end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select()
        end,
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      {
        "<leader>aC",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Sidekick Toggle Claude",
      },
    },
  },
}
