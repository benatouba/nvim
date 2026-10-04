-- Formatting via conform.nvim.
-- Save-time contract (#8): general formatting stays manual. There is
-- deliberately no format_on_save/format_after_save here; <leader>lf formats
-- explicitly. The sole auto-format is the commit-message InsertLeave below
-- (kept, scoped to *COMMIT_EDITMSG*, never on save).
return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    ft = { "gitcommit" },
    keys = {
      { "<leader>Lf", "<cmd>ConformInfo<cr>", desc = "Conform Info" },
      {
        "<leader>lf",
        function()
          require("conform").format({ lsp_format = "fallback", timeout_ms = 5000 })
        end,
        desc = "Format",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      -- Kept save-time behavior (#8): commit messages are reflowed on
      -- InsertLeave (not on save), scoped to commit buffers only.
      vim.api.nvim_create_autocmd("InsertLeave", {
        group = vim.api.nvim_create_augroup("ben_conform_commitmsg", { clear = true }),
        pattern = "*COMMIT_EDITMSG*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf, timeout_ms = 2500, lsp_format = "never" })
        end,
      })
    end,
    opts = {
      formatters_by_ft = {
        css = { "oxfmt" },
        dockerfile = { "lsp" },
        gitcommit = { "commitmsgfmt" },
        html = { "oxfmt" },
        javascript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        json = { "oxfmt" },
        jsonc = { "jq", stop_after_first = true },
        lua = { "stylua", stop_after_first = true },
        markdown = { "markdownlint", "markdownlint-cli2", "markdownfmt", stop_after_first = true },
        nix = { "nixfmt", stop_after_first = true },
        python = { "ruff_organize_imports", "ruff_fix", "ruff_format", stop_after_first = false },
        quarto = { "injected" },
        r = { "air", stop_after_first = true },
        rmd = { "injected" },
        scss = { "oxfmt" },
        tex = { "latexindent", stop_after_first = true },
        typescript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        typst = { "typstyle", stop_after_first = true },
        vue = { "oxfmt" },
        xhtml = { "lsp" },
        xml = { "lsp" },
        yaml = { "yamlfmt", stop_after_first = true },
        ["yaml.docker-compose"] = { "yamlfmt", stop_after_first = true },
        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },
      default_format_opts = { lsp_format = "fallback" },
    },
  },
}
