# Neovim configuration
for an effective workflow on any machine (even headless)

The configuration is written in Lua as are most of the used plugins.

config is based on LunarVim but extended, modified and refactored

[_TOC_]

# What is Neo(vim)

Neovim hyperextensible Vim-based text editor. It has lua built-in functionality and 30% less source-code than Vim. This enables features on the command line that definitely improve your workflow on the command line and save you a ton of time. No other editor can compare. No, Emacs can't compete.

# Why should I use it?
1. Vim is a good, fast text editor.
2. IDEs are usually just very practical for one or a couple of languages. So if you code in a different language, you will have to get familiar with a whole different setup. Neovim is highly extensible and you can set it up for any language.
3. It works on the command line on any machine, also on headless machines e.g. HPC.
4. It is open source, free (both beer and freedom) and does not collect your telemetry data.
5. etc.

# Setup
### Minimal setup includes
- system-wide fuzzy file finding and grepping (nvim-telescope   the best plugin out there)
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
