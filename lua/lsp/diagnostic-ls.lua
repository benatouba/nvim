local config = {
  filetypes = {
    "haskell",
    "python",
    "javascript",
    "typescript",
    "bash",
    "lua",
    "vim",
    "json",
    "sh",
    "scss",
    "css",
    "markdown",
    "javascriptreact",
    "typescriptreact",
    "sql",
    "fortran"
  },
  init_options = {

    linters = {

      shellcheck = {
        command = "shellcheck",
        debounce = 100,
        args = {"--format", "json", "-"},
        sourceName = "shellcheck",
        parseJson = {
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "${message} [${code}]",
          security = "level"
        },
        securities = {
          error = "error",
          warning = "warning",
          info = "info",
          style = "hint"
        }
      },

      markdownlint = {
        command = "markdownlint",
        isStderr = true,
        debounce = 100,
        args = {"--stdin"},
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = "markdownlint",
        formatLines = 1,
        formatPattern = {
          "^.*?:\\s?(\\d+)(:(\\d+)?)?\\s(MD\\d{3}\\/[A-Za-z0-9-/]+)\\s(.*)$",
          {
            line = 1,
            column = 3,
            message = {4}
          }
        }
      }

    },

    formatters = {

      shfmt = {
        command = "shfmt",
        args = {"-i", "2", "-bn", "-ci", "-sr"}
      },

      prettier = {
        command = "prettier",
        args = {"--stdin-filepath", "%filepath"},
      }

    },

    filetypes = {
      haskell = "hlint",
      lua = { "luacheck", "selene" },
      markdown = { "markdownlint" },
      python = { "flake8", "mypy" },
      scss = "stylelint",
      sh = "shellcheck",
      vim = "vint",
      yaml = "yamllint",
    },

    formatFiletypes = {
      javascript = "prettier",
      javascriptreact = "prettier",
      json = "prettier",
      lua = { "lua-format", "stylua" },
      python = { "isort", "black" },
      sh = "shfmt",
      sql = "pg_format",
      typescript = "prettier",
      typescriptreact = "prettier",
    },
  },
}

return config
