local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    execute 'packadd packer.nvim'
end

--- Check if a file or directory exists in this path
local function require_plugin(plugin)
    local plugin_prefix = fn.stdpath("data") .. "/site/pack/packer/opt/"

    local plugin_path = plugin_prefix .. plugin .. "/"
    --	print('test '..plugin_path)
    local ok, err, code = os.rename(plugin_path, plugin_path)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    --	print(ok, err, code)
    if ok then vim.cmd("packadd " .. plugin) end
    return ok, err, code
end

vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua
-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]

--[[ Plugins to checkout
    sqls.nvim
    neuron.nvim
    nvim-hlslens
]]

return require('packer').startup(function(use)
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = true}

    use {"neovim/nvim-lspconfig", opt = true}
    use {"glepnir/lspsaga.nvim", opt = true}
    use {"kabouzeid/nvim-lspinstall", opt = true}

    -- Telescope
    use {"nvim-lua/popup.nvim", opt = true}
    use {"nvim-lua/plenary.nvim", opt = true}
    use {"nvim-telescope/telescope.nvim", opt = true}

	-- Autocomplete/snippets
	use {"hrsh7th/nvim-compe", opt = true}
    use {'hrsh7th/vim-vsnip', opt = true}
    use {"rafamadriz/friendly-snippets", opt = true}

	-- Treesitter
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
    use {"windwp/nvim-ts-autotag", opt = true}

	-- help me find my way  around
    use {"folke/which-key.nvim", opt = true}

    -- Color
    use {"christianchiarulli/nvcode-color-schemes.vim", opt = true}
    use {'norcalli/nvim-colorizer.lua', opt = true}

    -- Icons
    use {"kyazdani42/nvim-web-devicons", opt = true}

	-- Status Line and Bufferline
    use {"glepnir/galaxyline.nvim", opt = true}
    use {"romgrk/barbar.nvim", opt = true}
    
    -- manipulation
    use 'monaqa/dial.nvim' -- increment/decrement basically everything
    use {'lukas-reineke/indent-blankline.nvim', branch = 'lua'}
    use {"windwp/nvim-autopairs", opt = true}
    use {"terrortylor/nvim-comment", opt = true}
    use 'mbbill/undotree'

    -- moving / movements / navigation
    use 'phaazon/hop.nvim'
    use 'MattesGroeger/vim-bookmarks'
    use 'numToStr/Navigator.nvim'

    use {'tpope/vim-surround', opt = true}
    use {'tpope/vim-fugitive', opt = true}
    use {'TimUntersberger/neogit', requires = {'sindrets/diffview.nvim'}}
    use {'lewis6991/gitsigns.nvim', opt = true}
    use {'Shougo/context_filetype.vim', opt = true }


    require_plugin("nvim-lspconfig")
    require_plugin("lspsaga.nvim")
    require_plugin("nvim-lspinstall")
    require_plugin("popup.nvim")
    require_plugin("plenary.nvim")
    require_plugin("telescope.nvim")
    require_plugin("nvim-compe")
    require_plugin("vim-vsnip")
    require_plugin("friendly-snippets")
    require_plugin("nvim-treesitter")
    require_plugin("nvim-ts-autotag")
    require_plugin("which-key.nvim")
    require_plugin("nvim-autopairs")
    require_plugin("nvim-comment")
    require_plugin("nvcode-color-schemes.vim")
    require_plugin("nvim-web-devicons")
    require_plugin("galaxyline.nvim")
    require_plugin("barbar.nvim")
    require_plugin('dial.nvim')
    require_plugin('indent-blankline.nvim')
    require_plugin('undotree')
    require_plugin('hop.nvim')
    require_plugin('vim-bookmarks')
    require_plugin('nvim-colorizer.lua')
    require_plugin('context_filetype.vim')
    require_plugin('vim-surround')
    require_plugin('vim-fugitive')
    require_plugin('gitsigns.nvim')
end
)
