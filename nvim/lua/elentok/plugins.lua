return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Color scheme.
  use {'embark-theme/vim', as = 'embark'}

  -- File manager.
  use 'cocopon/vaffle.vim'

  use 'tpope/vim-abolish'
  use 'tpope/vim-commentary'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'

  -- Automatically close bracket and tag pairs
  use 'windwp/nvim-autopairs'

  -- Move arguments to the left and right.
  use 'AndrewRadev/sideways.vim'

  -- LSP.
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-compe'
  use 'anott03/nvim-lspinstall'

  -- Allows running "nvim {filename}:{line-number}".
  use 'bogado/file-line'

  -- FZF.
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  -- Telescope
  use 'nvim-telescope/telescope.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}

  -- Treesitter
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- Syntax.
  use 'aklt/plantuml-syntax'

  -- Misc.
  use 'junegunn/vim-easy-align'
  use 'mhinz/vim-signify'
  use 'mhinz/vim-grepper'
  use 'michaeljsmith/vim-indent-object'
  use 'nathanaelkane/vim-indent-guides'
  use 'nelstrom/vim-visual-star-search'
  use 'christoomey/vim-tmux-navigator'
  use 'voldikss/vim-floaterm'
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'AndrewRadev/splitjoin.vim'
  use 'elentok/togglr.vim' -- Toggles words (e.g. true/false, top/bottom)
  use 'elentok/replace-all.vim'
  use 'jamessan/vim-gnupg'
  use 'davidbeckingsale/writegood.vim'

  -- Lazy
  use {'itchyny/calendar.vim', opt = true, cmd = 'Calendar'}

  -- dark/zen room, no distraction mode
  use {'junegunn/goyo.vim', opt = true, cmd = 'Goyo'}

end, {display = {open_fn = require('packer.util').float}})
