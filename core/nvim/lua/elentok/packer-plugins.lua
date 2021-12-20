return require("packer").startup({
  function()
    use "wbthomason/packer.nvim"

    -- Optimize startup.
    use {"lewis6991/impatient.nvim"}

    -- Color scheme.
    use "olimorris/onedarkpro.nvim"

    -- File manager.
    use "cocopon/vaffle.vim"
    use "vifm/vifm.vim"

    use "tpope/vim-abolish"
    use "tpope/vim-commentary"
    use "tpope/vim-dispatch"
    use "tpope/vim-eunuch"
    use "tpope/vim-fugitive"
    use "tpope/vim-repeat"
    use "tpope/vim-surround"
    use "tpope/vim-unimpaired"

    -- Automatically close bracket and tag pairs
    use "windwp/nvim-autopairs"

    -- LSP.
    use "neovim/nvim-lspconfig"
    -- use "hrsh7th/nvim-compe"
    use "anott03/nvim-lspinstall"
    use "ray-x/lsp_signature.nvim"
    use "stevearc/aerial.nvim"

    -- Completion.
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/nvim-cmp"
    use "onsails/lspkind-nvim"
    use "lukas-reineke/cmp-rg"
    use "uga-rosa/cmp-dictionary"

    -- Snippets
    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"
    use "rafamadriz/friendly-snippets" -- collection of snippets for all langs

    -- Allows running "nvim {filename}:{line-number}".
    use "bogado/file-line"

    -- FZF.
    use "junegunn/fzf"
    use "junegunn/fzf.vim"

    -- Telescope
    use "nvim-telescope/telescope.nvim"
    use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}

    -- Treesitter
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "SmiteshP/nvim-gps"

    -- Syntax.
    use "aklt/plantuml-syntax"

    -- Misc.
    use "junegunn/vim-easy-align"
    use "mhinz/vim-signify"
    use "michaeljsmith/vim-indent-object"
    use "nathanaelkane/vim-indent-guides"
    use "nelstrom/vim-visual-star-search"
    use "christoomey/vim-tmux-navigator"
    use "voldikss/vim-floaterm"
    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"
    use "AndrewRadev/splitjoin.vim"
    use "jamessan/vim-gnupg"
    use "davidbeckingsale/writegood.vim"
    use "sotte/presenting.vim" -- Presentation tool
    use "karb94/neoscroll.nvim" -- Smooth scrolling
    use "kyazdani42/nvim-web-devicons"
    use "TimUntersberger/neogit" -- Git client
    use "nvim-lualine/lualine.nvim" -- Statusline
    use "tversteeg/registers.nvim" -- Shows registers contents when using them
    -- use "ggandor/lightspeed.nvim" -- Move quickly between positions

    -- Toggles words (e.g. true/false, top/bottom)
    use {
      "elentok/togglr.vim",
      config = function()
        require("togglr").setup()
      end
    }

    -- Lazy
    use {"itchyny/calendar.vim", opt = true, cmd = "Calendar"}

    -- dark/zen room, no distraction mode
    use {"junegunn/goyo.vim", opt = true, cmd = "Goyo"}
  end,
  config = {
    display = {open_fn = require("packer.util").float}
    -- disable for now (https://github.com/wbthomason/packer.nvim/issues/201)
    -- Move to lua dir so impatient.nvim can cache it
    -- compile_path = vim.fn.stdpath("cache") .. "/lua/packer_compiled.lua",
    -- compile_on_sync = true
  }
})
