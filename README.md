# Neovim configuration for an effective workflow on any machine (even headless)

The configuration is written in Lua as are most of the used plugins.

config is based on LunarVim but extremely modified and refactored

### Minimal setup includes
- system-wide fuzzy file finding and grepping (nvim-telescope   the best plugin)
    - uses fzf or fzy for file matching
    - uses ripgrep (rg) for text matching
- basic language specific features for ~60 languages (nvim-treesitter)
    - highlighting
    - tree structure
    - indenting
- git helper
    - function wrapper (Neogit in lua, vim-fugitive in vimL)
    - gutter (gitsigns.nvim)
- status bar (galaxyline.nvim)
- top bar (barbar.nvim)
- highly customizable package management (packer.nvim)
- incrementing/decrementing basically anything (dial.nvim)
- key mappings helper (which-key.nvim)
- snippets for most languages (vim-vsnip)
- developer icons (nvim-web-devicons, based on vim-devicons)
- database access (sql.nvim)
- color schemes (nvcode-color-schemes)
- and other stuff (check lua/plugins.lua for a list)

### If you want more functionality checkout
- LSP support (nvim-lspconfig, lspsaga, lspinstall and nvim-compe, requires various languages to install the servers)
- debugging (nvim-dap in lua or vimspector in vimL, requires debuggers)
- ranger file browser (rnvimr, requires ranger (and Ueberzug for media file rendering))
- testing (vim-ultest, requires test libraries)
- efficiency stuff (anything by tpope)
- visual/UI stuff (anything by folke)

### Dependencies
- neovim >=0.5 (nightly) and its install requirements (check neovim build instructions)
- git (if it is an old version you may need to tweak packer.nvim config, check their GH)

#### Optional:
- A patched font on the machine that is rendering your output (best just install NerdFonts)
- fzf (for good fuzzy file finding)
- rg (for text matching, requires rust)
- sqlite3 (for database conns and frecency)
- python3 with pynvim package

## TODO:
- find best, minimal setup
- ship some patched fonts
- handle installation of dependencies
- figure out simple installation (via saltstack)
- figure out how to ship globally
