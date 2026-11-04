-- Automatic installs: Mason tools, Tree-sitter parsers and native plugin builds.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = { auto_install = true },
  },
  {
    "L3MON4D3/LuaSnip",
    -- jsregexp speeds up transformations; the make step is skipped on Nix.
    build = (not vim.g.is_nixos) and "make install_jsregexp" or nil,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
      },
    },
    opts = {
      extensions = {
        fzf = { override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("lsp.servers").mason_servers()
    end,
    enabled = not vim.g.is_nixos,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true, -- never pull in an unselected DAP group
    opts = { ensure_installed = { "js" } },
  },
  {
    -- Non-NixOS fallback provisioning for editor-level formatter/linter
    -- binaries consumed via $PATH (see docs/provisioning.md). Project-managed
    -- tools (ruff via uv, node_modules binaries) are deliberately excluded.
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = { "InsertEnter", "CmdlineEnter", "BufReadPost", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "air",
        "commitlint",
        "djlint",
        "editorconfig-checker",
        "jq",
        "latexindent",
        "markdownlint",
        "markdownlint-cli2",
        "nixfmt",
        "proselint",
        "statix",
        "stylua",
        "typstyle",
      },
    },
    enabled = not vim.g.is_nixos,
  },
}
