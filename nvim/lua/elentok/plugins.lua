return require('packer').startup(function()
  -- Color scheme
  use 'skbolton/embark'

  use {'fatih/vim-go', ft = 'go'}
  use {'Shougo/denite.nvim', run = ':UpdateRemotePlugins'}
  use {'elentok/replace-all.vim', cmd = {'FindAll', 'ReplaceAll'}}
  use {'gregsexton/gitv', cmd = 'Gitv' }
  use {'itchyny/calendar.vim', cmd = 'Calendar' }
  use {'junegunn/goyo.vim', cmd = 'Goyo' } -- zen room, no distraction mode
  use {'schickling/vim-bufonly', cmd = {'BufOnly', 'Bonly', 'BOnly'}}
  use {
    'scrooloose/nerdtree',
    cmd = {'NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind'}
  }
  use {
    'Xuyuanp/nerdtree-git-plugin',
    cmd = {'NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind'}
  }

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  use {
    'junegunn/fzf',
    run = function() vim.fn['fzf#install']() end
  }

  use 'AndrewRadev/sideways.vim'
  use 'AndrewRadev/splitjoin.vim'
  use 'Raimondi/delimitMate'
  use 'elentok/run.vim'
  use 'elentok/togglr.vim'
  use 'elentok/vim-rails-extra'
  use 'iandoe/vim-osx-colorpicker'
  use 'jamessan/vim-gnupg'
  use 'junegunn/fzf.vim'
  use 'pbogut/fzf-mru.vim'
  use 'junegunn/vim-easy-align'
  use 'mhinz/vim-signify'
  use 'mhinz/vim-grepper'
  use 'michaeljsmith/vim-indent-object'
  use 'nathanaelkane/vim-indent-guides'
  use 'nelstrom/vim-visual-star-search'
  use 'scrooloose/nerdcommenter'
  use 'tomtom/tlib_vim'
  use 'tpope/vim-abolish'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'xolox/vim-misc'
  use 'KabbAmine/vCoolor.vim'
  use 'davidbeckingsale/writegood.vim'
  use 'christoomey/vim-tmux-navigator'
  use 'cocopon/vaffle.vim'
  use 'bogado/file-line'
  use 'janko/vim-test'

  if vim.g.lsp_mode == 'coc' then
    use {'neoclide/coc.nvim', branch = 'release' }
  elseif vim.g.lsp_mode == 'native' then
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/completion-nvim'
  end

end)
