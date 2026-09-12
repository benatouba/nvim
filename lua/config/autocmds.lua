-- Autocommands that do not belong to any plugin.

local function augroup(name)
  return vim.api.nvim_create_augroup("ben_" .. name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

-- Filetype detection for files Neovim does not recognise on its own.
vim.filetype.add({
  extension = {
    pro = "idlang",
    ipynb = "ipynb",
    sls = "sls",
    R = "r",
    r = "r",
    Rmd = "rmd",
    rmd = "rmd",
    rasi = "rasi",
    rofi = "rasi",
    wofi = "rasi",
  },
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
    [".*_p3d.*"] = "fortran",
    [".*/w[^/]*_namelist[^/]*"] = "fortran",
    [".*%.bash.*"] = "bash",
    [".*swa[^/]*%.conf.*"] = "i3config",
    -- firenvim buffers for Jupyter cells
    [".*ipynb_er%-DIV.*%.txt"] = "python",
    [".*ipynb_ontainer%-DIV.*%.txt"] = "markdown",
  },
})

-- Absolute line numbers while typing a command, relative otherwise.
local cmdline = augroup("cmdline_numbers")
autocmd("CmdlineEnter", {
  group = cmdline,
  callback = function()
    vim.o.relativenumber = false
  end,
})
autocmd("CmdlineLeave", {
  group = cmdline,
  callback = function()
    vim.o.relativenumber = true
  end,
})

-- Per-filetype buffer settings
local ft = augroup("filetype_settings")
autocmd("FileType", {
  group = ft,
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
  end,
})
autocmd("FileType", {
  group = ft,
  pattern = "org",
  callback = function()
    vim.opt_local.concealcursor = "nc"
  end,
})
autocmd("FileType", {
  group = ft,
  pattern = "directory",
  callback = function()
    vim.opt_local.winbar = "[dir] %f"
  end,
})
autocmd({ "BufRead", "BufNewFile" }, {
  group = ft,
  pattern = { "*.txt", "*.json" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Close transient windows with q / <esc>
local close_with = {
  q = {
    "checkhealth",
    "dashboard",
    "floaterm",
    "fugitive",
    "help",
    "httpResult",
    "lspinfo",
    "neotest-*",
    "neotest-output-panel",
    "nofile",
    "notify",
    "qf",
    "query",
  },
  ["<esc>"] = {
    "acwrite",
    "checkhealth",
    "dashboard",
    "floaterm",
    "fugitive",
    "help",
    "httpResult",
    "lspinfo",
    "nofile",
    "notify",
    "qf",
    "query",
  },
}
for key, patterns in pairs(close_with) do
  autocmd("FileType", {
    group = augroup("close_with_" .. key:gsub("[<>]", "")),
    pattern = patterns,
    callback = function(args)
      vim.keymap.set("n", key, "<cmd>q<CR>", { buffer = args.buf, silent = true, desc = "Close window" })
    end,
  })
end

-- No diagnostics for vendored dependencies
autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("node_modules"),
  pattern = "*/node_modules/*",
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})

-- Python: tidy imports after save (pyflyby), then reload the buffer.
autocmd("BufWritePost", {
  group = augroup("pyflyby"),
  pattern = "*.py",
  callback = function(args)
    if vim.fn.executable("tidy-imports") ~= 1 then
      return
    end
    vim.system(
      { "tidy-imports", "--quiet", "--black", "--replace-star-imports", "--action", "REPLACE", args.file },
      {},
      vim.schedule_wrap(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.cmd.checktime(args.buf)
        end
      end)
    )
  end,
})

-- LaTeX template workflow
autocmd("BufWipeout", {
  group = augroup("tex_template"),
  pattern = "template.tex",
  command = "!cp template.pdf manuscript.pdf",
})
