return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        NeogitCommitMessage = { "commitlint" },
        c = { "compiler" },
        gitcommit = { "commitlint" },
        htmldjango = { "djlint" },
        jinja = { "djlint" },
        nix = { "statix" },
        tex = { "proselint" },
        zsh = { "zsh" },
        [".*/.github/workflows/.*%.yml"] = { "yaml.ghaction" },
      }
      local ns = require("lint").get_namespace("commitlint")
      vim.diagnostic.config({ virtual_text = true, signs = true, update_in_insert = true }, ns)
      vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = "lint",
        callback = function()
          require("lint").try_lint()
        end,
      })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = "lint",
        callback = function()
          require("lint").try_lint("editorconfig-checker")
        end,
      })
      vim.api.nvim_create_autocmd({ "TextChanged" }, {
        group = "lint",
        pattern = "*COMMIT_EDITMSG*",
        callback = function()
          require("lint").try_lint("commitlint")
        end,
      })
    end,
    enabled = O.language_parsing,
  },
}
