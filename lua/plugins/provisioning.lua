-- Automatic installs: Mason tools, Tree-sitter parsers and native plugin builds.
return {
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
