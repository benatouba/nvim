local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
  execute 'PackerSync'
end

local packer_ok, _ = pcall(require, "packer")
if not packer_ok then
    print("Packer not okay")
    return
end

vim.cmd "autocmd BufWritePost plugins.lua PackerCompile"

return require('packer').startup(function(use)
    -- Packer can manage itself as an optional plugin
    use 'wbthomason/packer.nvim' -- plugin manager
    use "nvim-lua/popup.nvim"  -- handle popup (important)
    use "nvim-lua/plenary.nvim"  -- most important functions (very important)
    use "tjdevries/astronauta.nvim"  -- better plugin config loading

    -- Telescope
    use "nvim-telescope/telescope-project.nvim"
    use "nvim-telescope/telescope-fzf-writer.nvim"
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use {"nvim-telescope/telescope-frecency.nvim", requires = "tami5/sql.nvim"}
    use {"nvim-telescope/telescope.nvim",
      config = function() require('base.telescope') end,
      cmd = "Telescope",
      after = {
      "telescope-frecency.nvim",
      "telescope-fzf-native.nvim",
      "telescope-fzf-writer.nvim",
      "telescope-project.nvim"
    }}
    use {"oberblastmeister/rooter.nvim", opt = true, config = function() require('base.rooter') end, cond = function() return not O.lsp end}

    -- help me find my way  around
    use "folke/which-key.nvim"

    -- Color
    use {"christianchiarulli/nvcode-color-schemes.vim", opt = true}
    use {'norcalli/nvim-colorizer.lua', config = function() require'colorizer'.setup() end, event = "BufEnter"}
    use 'sheerun/vim-polyglot'

    -- Icons and visuals
    use "kyazdani42/nvim-web-devicons"
    use {"lukas-reineke/indent-blankline.nvim", opt = true, event = "BufRead", }

    -- Status Line and Bufferline
    use {"glepnir/galaxyline.nvim", config = function() require('base.galaxyline') end}
    use {"romgrk/barbar.nvim", config = function() require('base.barbar') end}
    use {"kyazdani42/nvim-tree.lua", opt = true, config = function() require("base.nvim-tree").config() end, cmd="NvimTreeToggle"}

    -- manipulation
    use { "monaqa/dial.nvim", opt = true, config = function() require('base.dial').config() end, event = "InsertEnter", } -- increment/decrement basically everything
    use { "terrortylor/nvim-comment", cmd = "CommentToggle", config = function() require("nvim_comment").setup() end, }
    use { "mbbill/undotree", opt = true, cmd = "UndotreeToggle" }

    if O.language_parsing then
        -- Treesitter
        use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
        use "nvim-treesitter/nvim-treesitter-refactor"
        use "nvim-treesitter/nvim-treesitter-textobjects"
        use {"windwp/nvim-ts-autotag", opt = true, event = "InsertEnter", }
        use {"windwp/nvim-autopairs",
            opt = true,
            event = "InsertEnter",
            after = "telescope.nvim",
            config = function()
              require "language_parsing.autopairs"
            end,
        }
        use {
            "JoosepAlviste/nvim-ts-context-commentstring",
            event = "BufRead",
        }
    end

    if O.lsp then
        use {"neovim/nvim-lspconfig", config = function() require('lsp') end}
        use {"glepnir/lspsaga.nvim", opt = true, config = function() require('lspsaga').init_lsp_saga() end, event = "BufRead"}
        use "kabouzeid/nvim-lspinstall"
        use { "hrsh7th/nvim-compe", event = "InsertEnter", config = function() require("lsp.compe").config() end, }
        use { "jose-elias-alvarez/nvim-lsp-ts-utils",
            ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
        }
        use { "ahmedkhalf/lsp-rooter.nvim", config = function() require("lsp-rooter").setup() end }
        use { "folke/trouble.nvim", cmd = "TroubleToggle", }
    end

    if O.git then -- Git (helpers)
        use {'tpope/vim-fugitive', opt = true, cmd = "G"}
        use {'TimUntersberger/neogit', requires = {'sindrets/diffview.nvim'}, cmd = "Neogit"}
        use {'lewis6991/gitsigns.nvim', disable = true, config = function() require"nv-gitsigns" end}-- fails on startup. TODO: activate when #205 is fixed
    end

    if O.misc then --miscellaneous stuff
        use {'tpope/vim-surround', opt = true}
        -- Autocomplete/snippets
        use {'hrsh7th/vim-vsnip', opt = true}
        use 'voldikss/vim-floaterm'
    end

    -- language specific
    if O.ft_extras then
        use {'saltstack/salt-vim',
            config = function() require('salt-vim') end,
            ft = {'saltfile', 'salt', 'sls', 'jinja', 'jinja2'}
        }
        use 'Glench/Vim-Jinja2-Syntax'
    end
end
)
