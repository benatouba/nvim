vim.cmd('set iskeyword+=-') -- treat dash separated words as a word text object"
vim.cmd('set shortmess+=c') -- Don't pass messages to |ins-completion-menu|.
vim.cmd('set inccommand=split') -- Make substitution work in realtime
vim.o.hidden = O.hidden_files -- Required to keep multiple buffers open multiple buffers
vim.o.title = true
TERMINAL = vim.fn.expand('$TERMINAL')
vim.cmd('let &titleold="'..TERMINAL..'"')
vim.o.titlestring="%<%F%=%l/%L - nvim"
vim.wo.wrap = O.wrap_lines -- Display long lines as just one line
vim.cmd('set whichwrap+=<,>,[,]') -- move to next line with theses keys
vim.o.syntax = 'on' -- syntax highlighting
vim.o.pumheight = 10 -- Makes popup menu smaller
vim.o.fileencoding = "utf-8" -- The encoding written to file
vim.o.cmdheight = 1 -- More space for displaying messages
vim.cmd('set colorcolumn=99999') -- fix indentline for now
-- vim.o.mouse = "a" -- Enable your mouse
vim.o.splitbelow = true -- Horizontal splits will automatically be below
vim.o.termguicolors = true -- set term gui colors most terminals support this
vim.o.splitright = true -- Vertical splits will automatically be to the right
vim.o.t_Co = "256" -- Support 256 colors
vim.o.conceallevel = 0 -- So that I can see `` in markdown files
vim.cmd('set ts=4') -- Insert 2 spaces for a tab
vim.cmd('set sw=4') -- Change the number of space characters inserted for indentation
vim.cmd('set nojoinspaces') -- do not insert space on line join
vim.cmd('set listchars+=tab:→→\\|,space:.,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨')
vim.bo.tabstop = 8
vim.bo.expandtab = true -- Converts tabs to spaces
vim.bo.smartindent = true -- Makes indenting smart
vim.wo.number = O.number -- set numbered lines
vim.wo.relativenumber = O.relative_number -- set relative number
vim.wo.cursorline = true -- Enable highlighting of the current line
vim.o.showtabline = 2 -- Always show tabs
vim.o.showmode = false -- We don't need to see things like -- INSERT -- anymore
vim.o.backup = true -- backup files
vim.o.writebackup = true -- backup files during writing
vim.wo.signcolumn = "yes:1" -- Always show the signcolumn, otherwise it would shift the text each time
vim.o.updatetime = 500 -- Faster completion
vim.o.timeoutlen = 500 -- By default timeoutlen is 1000 ms
-- vim.o.clipboard = "unnamedplus" -- Copy paste between vim and everything else

vim.o.ignorecase = true -- ignore case makes searching case insensitive
vim.o.smartcase = true -- smartcase makes it so that searching becomes case sensitive if you use a capital letter
vim.o.backupdir = vim.fn.stdpath('data') .. '/backup' -- set backup directory to be a subdirectory of data to ensure that backups are not written to git repos
vim.cmd('silent! [ -d ' .. vim.fn.stdpath('data') .. '/backup ] && mkdir ' .. vim.fn.stdpath('data') .. '/backup')
-- vim.o.undodir = vim.fn.stdpath('data') .. '/undo'        -- set undodir to ensure that the undofiles are not saved to git repos.
-- vim.o.undofile = true                                    -- enable persistent undo (meaning if you quit Neovim and come back to a file and want to undo previous changes you can)
-- vim.o.directory = vim.fn.stdpath('data') .. '/directory' -- Configure 'directory' to ensure that Neovim swap files are not written to repos.
vim.o.conceallevel = 0 -- Every character can be seen
