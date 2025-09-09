---@brief
---
--- https://github.com/blopker/codebook
---
---  An unholy spell checker for code.
---
--- `codebook-lsp` can be installed by following the instructions [here](https://github.com/blopker/codebook/blob/main/README.md#installation).
---
--- The default `cmd` assumes that the `codebook-lsp` binary can be found in `$PATH`.
---

---@type vim.lsp.Config
local config = {
  cmd = { "codebook-lsp", "serve" },
  filetypes = {
    "c",
    "css",
    "gitcommit",
    "go",
    "haskell",
    "html",
    "java",
    "javascript",
    "javascriptreact",
    "lua",
    "markdown",
    "php",
    "python",
    "ruby",
    "rust",
    "toml",
    "text",
    "typescript",
    "typescriptreact",
    "vue",
  },
  root_markers = { ".git", "codebook.toml", ".codebook.toml" },
}
vim.lsp.config("codebook", config)
