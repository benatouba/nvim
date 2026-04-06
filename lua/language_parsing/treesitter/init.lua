local M = {}

M.config = function()
  local ts_ok, ts = pcall(require, "nvim-treesitter")
  if not ts_ok then
    vim.notify("Treesitter not okay")
    return
  end

  -- New nvim-treesitter API: setup() only accepts install_dir
  ts.setup()

  vim.filetype.add({
    extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
    filename = {
      [".env"] = "dotenv",
      ["vifmrc"] = "vim",
      [".ledger"] = "ledger",
      [".hledger"] = "hledger",
    },
    pattern = {
      [".*/waybar/config"] = "jsonc",
      [".*/mako/config"] = "dosini",
      [".*/kitty/.+%.conf"] = "bash",
      [".*/hypr/.+%.conf"] = "hyprlang",
      ["%.env%.[%w_.-]+"] = "dotenv",
    },
  })

  -- Enable treesitter highlighting and indent for every filetype
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
      vim.opt_local.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
    end,
  })

  -- Auto-install the parser for any filetype that doesn't have one yet.
  -- available_parsers is built once, only on first miss, then cached.
  local available_parsers = nil
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local lang = vim.treesitter.language.get_lang(args.match)
      if not lang then return end
      if pcall(vim.treesitter.language.inspect, lang) then return end
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

  vim.treesitter.language.register("markdown", "octo")
end
return M
