-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- telescope
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.x', requires = {{'nvim-lua/plenary.nvim'}}
  }

  -- theme: gruber-darker
  use({ 'blazkowolf/gruber-darker.nvim' })

  use( 'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})
  use('theprimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use('stevearc/conform.nvim')
  use({ 'numToStr/Comment.nvim', config = function() require('Comment').setup() end })
  use({ 'nvim-pack/nvim-spectre', requires = { 'nvim-lua/plenary.nvim' } })
  use({ 'supermaven-inc/supermaven-nvim' })

end)
