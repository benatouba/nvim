local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local packer_ok, _ = pcall(require, "packer")
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
        install_path
    })
    execute 'packadd packer.nvim'
    if not packer_ok then
    print("Packer not okay")
        return
    end
    execute 'PackerSync'
end

if not packer_ok then
    print("Packer not okay")
    return
end

vim.cmd "autocmd BufWritePost plugins.lua PackerCompile profile=true"

return require('packer').startup({
    function(use)
        -- Packer can manage itself as an optional plugin
        use 'wbthomason/packer.nvim' -- plugin manager
        use "nvim-lua/popup.nvim" -- handle popup (important)
        use "nvim-lua/plenary.nvim" -- most important functions (very important)
        use "tjdevries/astronauta.nvim" -- better plugin config loading

        -- Telescope
        use {"nvim-telescope/telescope-project.nvim",
            after = "telescope.nvim",
            config = function() require('telescope').load_extension('project') end,
        }
        use {"nvim-telescope/telescope-fzf-writer.nvim",
            after = "telescope.nvim",
        }
        use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make',
            after = "telescope.nvim",
            config = function() require('telescope').load_extension('fzf') end,
        }
        use { "nvim-telescope/telescope-frecency.nvim",
            requires = "tami5/sql.nvim",
            after = "telescope.nvim",
            -- config = function() require('telescope').load_extension('frecency') end,
        }
        use {
            "nvim-telescope/telescope.nvim",
            config = function() require('base.telescope').config() end,
            cmd = "Telescope",
            event = "InsertEnter",
        }
        use {
            "oberblastmeister/rooter.nvim",
            opt = true,
            config = function() require('base.rooter') end,
            disable = O.lsp
        }

        -- help me find my way  around
        use "folke/which-key.nvim"

        -- Color
        use {"christianchiarulli/nvcode-color-schemes.vim", opt = true}
        use {
            'norcalli/nvim-colorizer.lua',
            config = function() require'colorizer'.setup() end,
            event = "BufReadPost"
        }
        use 'sheerun/vim-polyglot'

        -- Icons and visuals
        use "kyazdani42/nvim-web-devicons"
        use {
            "lukas-reineke/indent-blankline.nvim",
            opt = true,
            event = "BufReadPost"
        }

        -- Status Line and Bufferline
        use {
            "glepnir/galaxyline.nvim",
            config = function() require('base.galaxyline') end
        }
        use "romgrk/barbar.nvim"
        use {
            "kyazdani42/nvim-tree.lua",
            opt = true,
            config = function() require("base.nvim-tree").config() end,
            cmd = "NvimTreeToggle"
        }

        -- manipulation
        use {
            "monaqa/dial.nvim",
            opt = true,
            config = function() require('base.dial').config() end,
            event = "BufReadPost"
        } -- increment/decrement basically everything
        use {
            "terrortylor/nvim-comment",
            cmd = "CommentToggle",
            config = function() require("nvim_comment").setup() end
        }
        use {"mbbill/undotree", opt = true, cmd = "UndotreeToggle"}
        use 'tpope/vim-surround'

        -- language specific
        use {
            'saltstack/salt-vim',
            ft = {'saltfile', 'salt', 'sls', 'jinja', 'jinja2'}
        }
        use {
            'Glench/Vim-Jinja2-Syntax',
            ft = {'saltfile', 'salt', 'sls', 'jinja', 'jinja2'}
        }

        if O.language_parsing then
            -- Treesitter
            use {
                "nvim-treesitter/nvim-treesitter",
                run = ":TSUpdate",
                config = function()
                    require("language_parsing.treesitter")
                end
            }
            use {
                "nvim-treesitter/nvim-treesitter-refactor",
                after = "nvim-treesitter"
            }
            use {
                "nvim-treesitter/nvim-treesitter-textobjects",
                after = "nvim-treesitter"
            }
            use {"p00f/nvim-ts-rainbow", after = "nvim-treesitter"}
            use {"windwp/nvim-ts-autotag", after = "nvim-treesitter"}
            use {
                "windwp/nvim-autopairs",
                after = "nvim-treesitter",
                config = function()
                    require "language_parsing.autopairs"
                end
            }
            use {
                "JoosepAlviste/nvim-ts-context-commentstring",
                after = "nvim-treesitter"
            }
        end

        if O.lsp then
            use {
                "neovim/nvim-lspconfig",
                config = function() require('lsp') end,
                event = {"BufReadPost", "InsertEnter"},
                fn = {"edit", "e"},
                cmd = {"LspStart", "LspInfo", "TSUpdate"},
                after = "nvim-lspinstall"
            }
            use "kabouzeid/nvim-lspinstall"
            use {
                "hrsh7th/nvim-compe",
                event = "InsertEnter",
                config = function() require("lsp.compe").config() end,
                after = "nvim-lspconfig"
            }
            use {
                "jose-elias-alvarez/nvim-lsp-ts-utils",
                after = "nvim-lspconfig",
                ft = {
                    "javascript", "javascriptreact", "javascript.jsx",
                    "typescript", "typescriptreact", "typescript.tsx"
                }
            }
            use {
                "ahmedkhalf/lsp-rooter.nvim",
                config = function() require("lsp-rooter").setup() end,
                after = "nvim-lspconfig"
            }
            use {"folke/trouble.nvim", cmd = "TroubleToggle"}
        end

        if O.git then -- Git (helpers)
            use {'tpope/vim-fugitive', opt = true, cmd = "G"}
            use {
                'TimUntersberger/neogit',
                requires = {'sindrets/diffview.nvim'},
                cmd = "Neogit"
            }
            use {
                'lewis6991/gitsigns.nvim',
                config = function() require "git.gitsigns" end,
                event = "BufReadPost"
            } -- fails on startup. TODO: activate when #205 is fixed
        end

        if O.snippets then -- miscellaneous stuff
            use 'hrsh7th/vim-vsnip'
            use {'rafamadriz/friendly-snippets', opt = true}
        end

        if O.format then
            use {
                "mhartington/formatter.nvim",
                config = function() require('format.formatter').config() end
            }
        end

        if O.dap then -- debug adapter protocol
            use {
                "mfussenegger/nvim-dap",
                config = function() require("debug") end
            }
            use {"rcarriga/nvim-dap-ui", after = "nvim-dap"}
            use {"Pocco81/DAPInstall.nvim", after = "nvim-dap"}
        end

        if O.project_management then
            use {'kristijanhusak/orgmode.nvim', config = function() require('orgmode').setup{} end }
        end

        if O.misc then
            use 'kevinhwang91/nvim-bqf'
            use 'andymass/vim-matchup'
            use {
                "numtostr/FTerm.nvim",
                config = function() require("FTerm").setup() end
            }
        end
    end,
    config = {
        profile = {
            enable = true,
            threshold = 1 -- the amount in ms that a plugins load time must be over for it to be included in the profile
        }
    }
})
