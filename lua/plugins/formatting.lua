return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        gitcommit = { "commitmsgfmt" },
        jsonc = { "jq", stop_after_first = true },
        lua = { "stylua", stop_after_first = true },
        markdown = { "markdownlint", "markdownlint-cli2", "markdownfmt", stop_after_first = true },
        nix = { "nixfmt", stop_after_first = true },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports", "docformatter", stop_after_first = false },
        quarto = { "injected" },
        r = { "air", stop_after_first = true },
        rmd = { "injected" },
        scss = { "oxfmt" },
        tex = { "latexindent", stop_after_first = true },
        javascript = { "oxfmt" },
        typescript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        vue = { "oxfmt" },
        json = { "oxfmt" },
        html = { "oxfmt" },
        css = { "oxfmt" },
        typst = { "typstyle", stop_after_first = true },
        yaml = { "yamlfmt", stop_after_first = true },
        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.api.nvim_create_autocmd("InsertLeave", {
        pattern = "*COMMIT_EDITMSG*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf, timeout_ms = 2500, lsp_format = "never" })
        end,
      })
    end,
    ft = { "gitcommit" },
    keys = {
      { "<leader>Lf", "<cmd>ConformInfo<cr>", desc = "Conform Info" },
      {
        "<leader>lf",
        '<cmd>lua require("conform").format({ lsp_format = "fallback", timeout_ms = 5000 })<cr>',
        desc = "Format",
      },
    },
    enabled = O.language_parsing,
  },
}
