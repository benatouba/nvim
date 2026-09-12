-- Linting via nvim-lint (no setup(); options are assigned in config).
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      linters_by_ft = {
        NeogitCommitMessage = { "commitlint" },
        c = { "compiler" },
        gitcommit = { "commitlint" },
        htmldjango = { "djlint" },
        jinja = { "djlint" },
        nix = { "statix" },
        tex = { "proselint" },
        zsh = { "zsh" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      -- commitlint diagnostics update while typing
      vim.diagnostic.config(
        { virtual_text = true, signs = true, update_in_insert = true },
        lint.get_namespace("commitlint")
      )

      local group = vim.api.nvim_create_augroup("ben_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = function()
          lint.try_lint()
        end,
      })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = group,
        callback = function()
          lint.try_lint("editorconfig-checker")
        end,
      })
      vim.api.nvim_create_autocmd("TextChanged", {
        group = group,
        pattern = "*COMMIT_EDITMSG*",
        callback = function()
          lint.try_lint("commitlint")
        end,
      })
    end,
  },
}
