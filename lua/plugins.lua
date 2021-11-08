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
        use {"lewis6991/impatient.nvim", config = function() require('impatient') end}

        -- Telescope
        -- use {
        --     "nvim-telescope/telescope-project.nvim",
        --     after = "telescope.nvim",
        --     config = function()
        --         require('telescope').load_extension('project')
        --     end
        -- }
        use {
            "nvim-telescope/telescope-fzf-writer.nvim",
            after = "telescope.nvim"
        }
        use {
            'nvim-telescope/telescope-fzf-native.nvim',
            run = 'make',
            after = "telescope.nvim",
            config = function()
                require('telescope').load_extension('fzf')
            end
        }
        use {
            "nvim-telescope/telescope-frecency.nvim",
            requires = "tami5/sql.nvim",
            after = "telescope.nvim"
            -- config = function() require('telescope').load_extension('frecency') end,
        }
        use {
            "nvim-telescope/telescope.nvim",
            config = function() require('base.telescope').config() end,
            cmd = "Telescope",
            event = "InsertEnter"
        }
        -- use {
        --     "oberblastmeister/rooter.nvim",
        --     opt = true,
        --     config = function() require('base.rooter') end,
        --     disable = O.lsp
        -- }
        use {
            "ahmedkhalf/project.nvim",
            config = function() require("base.project").setup() end,
            after = "telescope.nvim"
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
            "NTBBloodbath/galaxyline.nvim",
            config = function() require('base.galaxyline') end
        }
        use "romgrk/barbar.nvim"
        use {
            "kyazdani42/nvim-tree.lua",
            -- opt = true,
            config = function() require("base.nvim-tree").config() end,
            -- cmd = "NvimTreeToggle"
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
        use 'saltstack/salt-vim'
        use 'Glench/Vim-Jinja2-Syntax'

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
                after = "nvim-lsp-installer"
            }
            use {"williamboman/nvim-lsp-installer", event = {"CmdlineEnter", "InsertEnter"}, config = function() require('lsp.lsp_installer').config() end}
            -- use "williamboman/nvim-lsp-installer"
            use {
                "hrsh7th/nvim-cmp",
                -- event = "InsertEnter",
                requires = {
                    "hrsh7th/cmp-buffer",
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-path",
                    "hrsh7th/cmp-nvim-lua",
                    "hrsh7th/cmp-calc",
                    "hrsh7th/cmp-emoji",
                    "hrsh7th/cmp-cmdline",
                    "petertriho/cmp-git",
                    "andersevenrud/compe-tmux",
                    "ray-x/cmp-treesitter",
                    "lukas-reineke/cmp-under-comparator",
                    "lukas-reineke/cmp-rg",
                    { "David-Kunz/cmp-npm", filetype={'javascript', 'vue', 'typescript'}},
                    "L3MON4D3/LuaSnip",
                    "saadparwaiz1/cmp_luasnip",
                    {"kdheepak/cmp-latex-symbols", ft='latex'},
                    "f3fora/cmp-spell",
                    "quangnguyen30192/cmp-nvim-tags",
                    "octaltree/cmp-look",
                    "tamago324/cmp-zsh"
                },
                config = function() require("lsp.cmp").config() end,
                -- disable = true,
            }
            use "rafamadriz/friendly-snippets"
            use {
                "jose-elias-alvarez/nvim-lsp-ts-utils",
                after = "nvim-lspconfig",
                ft = {
                    "javascript", "javascriptreact", "javascript.jsx",
                    "typescript", "typescriptreact", "typescript.tsx"
                }
            }
            use {"folke/trouble.nvim", cmd = "TroubleToggle"}
        end

        if O.git then -- Git (helpers)
            use {'tpope/vim-fugitive', opt = true, cmd = {"G", "Git push", "Git pull"}}
            use {
                'TimUntersberger/neogit',
                requires = {'sindrets/diffview.nvim'},
                cmd = "Neogit"
            }
            use {
                'lewis6991/gitsigns.nvim',
                config = function() require "git.gitsigns" end,
                event = "BufReadPost",
                -- disable = true
            } -- fails on startup. TODO: activate when #205 is fixed
        end

        -- if O.snippets then -- miscellaneous stuff
        --     use 'hrsh7th/vim-vsnip'
        --     use 'rafamadriz/friendly-snippets'
        -- end

        if O.format then
            use {
                "mhartington/formatter.nvim",
                config = function()
                    require('format.formatter').config()
                end
            }
        end

        if O.test then
            use {
                "rcarriga/vim-ultest",
                requires = {"vim-test/vim-test"},
                run = ":UpdateRemotePlugins"
            }
        end

        if O.dap then -- debug adapter protocol
            use {
                "mfussenegger/nvim-dap",
                config = function() require("debug") end
            }
            use {"rcarriga/nvim-dap-ui", after = "nvim-dap", config = function ()
                require('dapui').setup()
            end}
            use {"Pocco81/DAPInstall.nvim", after = "nvim-dap"}
            use {'jbyuki/one-small-step-for-vimkind',
                after = 'nvim-dap',
                ft = 'lua',
                config = function()
                    require('debug.one_small_step_for_vimkind').config()
                end
            }
        end

        if O.project_management then
            use {
                'kristijanhusak/orgmode.nvim',
                keys = "<leader>o",
                config = function() require('org').config() end
            }
        end

        -- TODO: test todo-comments with sidebar
        if O.misc then
            use 'kevinhwang91/nvim-bqf'
            use 'andymass/vim-matchup'
            use {'GustavoKatel/sidebar.nvim', config = function()
                require('sidebar-nvim').setup({
                    bindings = {
                        ["q"] = function ()
                            require('sidebar-nvim').close()
                        end
                    }})
            end}
            use {'folke/todo-comments.nvim', config = function ()
                require('todo-comments').setup()
            end}
            use {
                "numtostr/FTerm.nvim",
                -- config = function() require("FTerm") end
            }
            use {
                "danymat/neogen",
                config = function()
                    require("misc.neogen")
                end,
                requires = "nvim-treesitter/nvim-treesitter"
            }
        end
        use "wuelnerdotexe/vim-enfocado"
    end,
    config = {
        profile = {
            enable = true,
            threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
        },
        compile_path = packer_compile_path
    }
})
