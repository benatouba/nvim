-- Core Tree-sitter: highlighting and indentation for parsers already present. Parsers are
-- installed by hand with :TSInstall unless the provisioning group is selected.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    -- Upstream `main` does not support lazy-loading: load eager.
    lazy = false,
    dependencies = {
      { "LiadOz/nvim-dap-repl-highlights", opts = {} },
    },
    config = function()
      require("nvim-treesitter").setup()
      vim.treesitter.language.register("markdown", "octo")

      local group = vim.api.nvim_create_augroup("ben_treesitter", { clear = true })
      -- Highlighting and indentation for every buffer that has a parser
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          -- Salt uses mixed YAML/Jinja syntax and predictable autoindent.
          if args.match ~= "salt" and args.match ~= "sls" and pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
          end
        end,
      })
      -- Install a missing parser the first time its filetype is opened.
      local available_parsers = nil
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang or pcall(vim.treesitter.language.inspect, lang) then
            return
          end
          if not available_parsers then
            available_parsers = {}
            for _, l in ipairs(require("nvim-treesitter.config").get_available()) do
              available_parsers[l] = true
            end
          end
          if available_parsers[lang] then
            require("nvim-treesitter.install").install({ lang })
          end
        end,
      })
    end,
  },
}
