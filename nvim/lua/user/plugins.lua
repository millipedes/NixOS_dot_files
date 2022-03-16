local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Install your plugins here
return packer.startup(function(use)
    -- package manager
    use "wbthomason/packer.nvim"            -- Have packer manage itself

    -- A lot of other plugins need these
    use "nvim-lua/popup.nvim"               -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim"             -- Useful lua functions used ny lots of plugins

    -- multiple cursors
    use "mg979/vim-visual-multi"            -- <C-n> multiple cursors

    -- colorscheme I like
    use "NLKNguyen/papercolor-theme"        -- PaperColor Theme
    -- use "andreasvc/vim-256noir"             -- 256 Noir
    -- use "morhetz/gruvbox"
    
    -- completion plugins
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"

    -- Snippet engine + defaults
    use "L3MON4D3/LuaSnip"
    use "rafamadriz/friendly-snippets"
    use "saadparwaiz1/cmp_luasnip" -- ??? but it makes it work ig

    -- tab bar stuff
    -- use {
    --     'romgrk/barbar.nvim',
    --     requires = {'kyazdani42/nvim-web-devicons'} 
    -- }

    -- status line stuff
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    use 'ggandor/lightspeed.nvim'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
