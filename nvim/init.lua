-- Source `.vimrc`
vim.cmd [[
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vimrc
]]

-- packer (from <https://github.com/wbthomason/packer.nvim>)
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
  -- self-managing package manager *mind blown*
  use 'wbthomason/packer.nvim'

  -- pretty icons
  use 'nvim-tree/nvim-web-devicons'

  -- telescope
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } }

  -- treesitter
  use { 'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' } }

  -- undotree
  use 'mbbill/undotree'

  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  -- snippets for above lsp
  use 'l3mon4d3/luasnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- rust <https://github.com/hrsh7th/nvim-cmp/wiki/Language-Server-Specific-Samples#rust-with-rust-toolsnvim>
  use 'simrat39/rust-tools.nvim'
end)
