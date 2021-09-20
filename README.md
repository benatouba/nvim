# [Neovim](https://github.com/neovim/neovim) configuration
for an effective workflow on any machine (even headless)

The configuration is written in Lua as are most of the used plugins.

config is based on LunarVim but extended, modified and refactored

[_TOC_]

# What is Neo(vim)

Neovim hyperextensible Vim-based text editor. It has lua built-in functionality and 30% less source-code than Vim. This enables features on the command line that definitely improve your workflow on the command line and save you a ton of time. No other editor can compare.

# Why should I use it?
1. Vim is a good, fast text editor.
2. IDEs are usually just very practical for one or a couple of languages. So if you code in a different language, you will have to get familiar with a whole different setup. Neovim is highly extensible and you can set it up for any language.
3. It works on the command line on any machine, also on headless machines e.g. HPC.
4. It is open source, free (both beer and freedom) and does not collect your telemetry data.
5. etc.

# Setup
### Minimal setup includes
- system-wide fuzzy file finding and grepping ([nvim-telescope](https://github.com/nvim-telescope/telescope.nvim)   the best plugin out there)
    - uses [fzf](https://github.com/junegunn/fzf) for file matching
    - uses ripgrep for text matching NEED [ripgrep](https://github.com/BurntSushi/ripgrep)
- status bar ([galaxyline.nvim](https://github.com/NTBBloodbath/galaxyline.nvim))
- top bar ([barbar.nvim](https://github.com/romgrk/barbar.nvim)
- highly customizable package management ([packer.nvim](https://github.com/wbthomason/packer.nvim))
- incrementing/decrementing/toggle basically anything ([dial.nvim](https://github.com/monaqa/dial.nvim))
- key mappings helper ([which-key.nvim](https://github.com/folke/which-key.nvim))
- syntax highlighting via regex ([vim-polyglot](https://github.com/sheerun/vim-polyglot))
- developer icons ([nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)) NEED ONE OR ALL [PATCHED FONTS](https://github.com/ryanoasis/nerd-fonts)!
- database access ([sql.nvim](https://github.com/tami5/sql.nvim))
- color schemes ([nvcode-color-schemes.vim](https://github.com/ChristianChiarulli/nvcode-color-schemes.vim))
check [lua/plugins.lua](lua/plugins.lua) for the full list

### If you want more functionality checkout
- Language Servers (diagnostics, linting, formatting)
    - [language server protocol](https://microsoft.github.io/language-server-protocol/) support ([nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
    - Server install helper ([nvim-lspinstall](https://github.com/kabouzeid/nvim-lspinstall), use ":LspInstall")
    - Auto Completion engine ([nvim-cmp](https://github.com/hrsh7th/nvim-cmp))
    - TO ACTIVATE: enable lsp in [user-settings](user-settings.lua)
- git helper
    - function wrapper ([Neogit](https://github.com/TimUntersberger/neogit) in lua, [vim-fugitive](https://github.com/tpope/vim-fugitive) in vimL)
    - gutter/git line info ([gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)) NOTE: deactivate if it causes problems (seems to be an issue with older git versions)
    - TO ACTIVATE: enable git in [user-settings](user-settings.lua)
- language parsing features for ~60 languages ([nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter))
    - highlighting
    - syntax tree structure
    - indenting
    - refactoring
    - scope
    - textobjects
    - colored parenthesis
    - commenting
    - TO ACTIVATE: enable language_parsing in [user-settings](user-settings.lua)
- snippets for most languages ([LuaSnip](https://github.com/L3MON4D3/LuaSnip) and [friendly-snippets](https://github.com/rafamadriz/friendly-snippets))
    - TO ACTIVATE: enable language_parsing in [user-settings](user-settings.lua)
- debugging ([nvim-dap](https://github.com/mfussenegger/nvim-dap) in lua or [vimspector](https://github.com/puremourning/vimspector) in vimL, requires debuggers) NOT YET IMPLEMENTED
- Not installed: ranger file browser ([rnvimr](https://github.com/kevinhwang91/rnvimr), requires [ranger](https://github.com/ranger/ranger) (and [Ueberzug](https://github.com/seebye/ueberzug) for media file rendering))
- testing ([vim-ultest](https://github.com/rcarriga/vim-ultest), requires test libraries) NOT YET IMPLEMENTED
- efficiency stuff (anything by [tpope](https://github.com/tpope))
- visual/UI stuff (anything by [folke](https://github.com/folke))

### Dependencies
- neovim >=0.5 and its install requirements (check neovim build instructions)
- git (if it is an old version you may need to tweak [packer.nvim](https://github.com/wbthomason/packer.nvim) config, check their GH)

#### Optional:
- A patched font on the machine that is rendering your output (best just install NerdFonts)
- fzf (for good fuzzy file finding)
- rg (for text matching, requires rust)
- sqlite3 (for database conns and frecency)
- python3 with pynvim package

# How to start using it
- The entry barrier can be quite high. If you are new to Vim, I recommend start you start with the vimtutor. Open neovim ``` nvim ``` and type ``` :Tutor ```.
- Once you are familiar with vim movements and basic editing commands, you NEED to read [vim-galore](https://github.com/mhinz/vim-galore)
- Start by only using it for basic tasks. Once you can move around, explore more functionality. Plugins are listed in [plugins.lua](lua/plugins.lua)
- Have a look at the [command list](lua/base/which-key/init.lua) and implement nvim-telescope to find and open files. Once that is implemented, move on.
- Explore the config and feel free to add/remove/change anything you want.

# Some Keymaps
- Get familiar with the usual vim keys.
- Keymaps specific to this config can be found in [here](lua/which-key/init.lua) and [here](lua/keymappings.lua).
- The leader key (<space> for us) opens up a menu, that shows you some commands.
- Some mappings are listed below but the source of truth will be the above mentioned file.

### Mnemonics of vim
- vim aims to make you use your whole keyboard but mostly the keys on your home row.
- vim commands are actually quite easy to remember as they follow a system (most of the time)
An example:
- Think of the first letter of the action you want to perform e.g. d = delete. Think of the first letter of the the word describing where you want to perform the action (mostly i = in or a = around, t = 'til). Think of the subject for the action e.g. w = word, p = paragraph, l = letter. Ergo diw = delete in word. Another way is to use motion commands, instead of location and subject. This is how you perform basic actions.

The mnemomics for this config should extend that way of thinking. Say you want to fuzzy find a file in your curretn project and open it in vertical split (nvim-telescope). In normal mode, hit leader (<space>) to activate your personal mode. Think of the first letter of the action you want to perform (s = search). Think of the thing you want to search (f = file, s = symbols, t = text (grep), p = projects). <space>sf will put you in file search mode. Use Ctrl-n/p to go to next/prev item in the list. Once you have a file selected, you can open it (Enter) in vertical split (Ctrl-v) or in horizontal split (Ctrl-x). This plugin can find literally anything for you. Here are some examples: Files, Text (grep, using ripgrep), Document/Workspace symbols (like tags but better, needs LSP or treesitter), git commits, git branches, items in your quickfix list, old files (recent files), marks, man pages (help), colorschemes, diagnostic errors (needs LSP).

# TODO:
- find best, minimal setup
- ship some patched fonts
- handle installation of dependencies
- figure out simple installation (via saltstack)
- figure out how to ship globally
