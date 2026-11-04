-- Linting via nvim-lint (no setup(); options are assigned in config).
-- Save-time contract (#8): BufWritePost hooks below only refresh diagnostics;
-- they never rewrite the buffer. Autofix on save lives solely in
-- after/lsp/eslint.lua (eslint-attached buffers).
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
        salt = { "saltlint" },
        sls = { "saltlint" }, -- legacy salt-vim filetype
        tex = { "proselint" },
        yaml = { "yamllint" },
        zsh = { "zsh" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft
      -- Resolve project devenv tools when invoked, even when Neovim was started
      -- outside the shell. Never send raw SLS templates to yamllint.
      for name, bin in pairs({ saltlint = "salt-lint", yamllint = "yamllint" }) do
        lint.linters[name].cmd = function()
          return require("util.python").executable(vim.fn.expand("%:p:h"), bin) or bin
        end
      end

      -- commitlint diagnostics update while typing
      vim.diagnostic.config(
        { virtual_text = true, signs = true, update_in_insert = true },
        lint.get_namespace("commitlint")
      )

      local group = vim.api.nvim_create_augroup("ben_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = function()
          local ft = vim.bo.filetype
          local bin = (ft == "salt" or ft == "sls") and "salt-lint" or (ft:match("^yaml") and "yamllint")
          if bin then
            local dir = vim.fn.expand("%:p:h")
            if require("util.python").executable(dir, bin) then
              -- salt-lint looks for .salt-lint in cwd, not beside the file.
              lint.try_lint(nil, { cwd = vim.fs.root(dir, { ".salt-lint", "devenv.nix", ".git" }) or dir })
            end
          else
            lint.try_lint()
          end
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
