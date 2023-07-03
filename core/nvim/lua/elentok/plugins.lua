return {
  { dir = "~/.dotprivate/nvim" },

  -- Optimizations.
  "lewis6991/impatient.nvim",

  -- Color scheme.
  "rmehri01/onenord.nvim",

  -- File manager.
  -- use "cocopon/vaffle.vim"
  "tamago324/lir.nvim",

  -- Comments
  "numToStr/Comment.nvim",

  "tpope/vim-abolish",
  "tpope/vim-dispatch",
  "tpope/vim-eunuch",
  "tpope/vim-fugitive",
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "tpope/vim-unimpaired",

  -- Automatically close bracket and tag pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- LSP.
  "neovim/nvim-lspconfig",
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
  }, -- Optional
  "williamboman/mason-lspconfig.nvim",

  -- Autocompletion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "saadparwaiz1/cmp_luasnip",
  "hrsh7th/cmp-nvim-lua",

  -- Snippets
  { "L3MON4D3/LuaSnip" },             -- Required
  { "rafamadriz/friendly-snippets" }, -- Optional

  -- Extra LSP plugins
  "ray-x/lsp_signature.nvim",
  "stevearc/aerial.nvim",
  "jose-elias-alvarez/null-ls.nvim",
  "onsails/lspkind-nvim",
  "lukas-reineke/cmp-rg",
  { "folke/trouble.nvim",                       dependencies = { "kyazdani42/nvim-web-devicons" } },
  {
    "j-hui/fidget.nvim", -- Shows LSP init progress
    tag = "legacy",
    config = function()
      require("fidget").setup()
    end,
  },

  -- Allows running "nvim {filename}:{line-number}".
  "bogado/file-line",

  -- FZF.
  "junegunn/fzf",
  "junegunn/fzf.vim",

  -- Telescope
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-file-browser.nvim",
  "nvim-telescope/telescope-live-grep-args.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  },
  "nvim-treesitter/playground",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "SmiteshP/nvim-navic",
  "folke/twilight.nvim", -- focus active code block
  "aklt/plantuml-syntax",
  "lewis6991/gitsigns.nvim",
  "michaeljsmith/vim-indent-object",
  "nelstrom/vim-visual-star-search",
  "christoomey/vim-tmux-navigator",
  "voldikss/vim-floaterm",
  "numToStr/FTerm.nvim",
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "AndrewRadev/splitjoin.vim",
  "jamessan/vim-gnupg",
  "davidbeckingsale/writegood.vim",
  "sotte/presenting.vim",  -- Presentation tool
  "karb94/neoscroll.nvim", -- Smooth scrolling
  "kyazdani42/nvim-web-devicons",
  --"TimUntersberger/neogit",    -- Git client
  "kdheepak/lazygit.nvim",
  { "akinsho/git-conflict.nvim", version = "v1.0.0" },
  "nvim-lualine/lualine.nvim", -- Statusline
  "tversteeg/registers.nvim",  -- Shows registers contents when using them
  "b0o/incline.nvim",          -- Shows buffer names on windows
  "ThePrimeagen/harpoon",
  "ThePrimeagen/refactoring.nvim",
  "ziontee113/color-picker.nvim",
  "ojroques/nvim-osc52",
  "mizlan/iswap.nvim",
  { "kevinhwang91/nvim-ufo",     dependencies = { "kevinhwang91/promise-async" } },
  {
    "salkin-mada/openscad.nvim",
    config = function()
      require("openscad")
    end,
  },
  { "phaazon/hop.nvim",     branch = "v2" },

  -- Toggles words (e.g. true/false, top/bottom)
  {
    "elentok/togglr.vim",
    config = function()
      require("togglr").setup()
    end,
  },

  { "itchyny/calendar.vim", cmd = "Calendar" },

  -- dark/zen room, no distraction mode
  { "junegunn/goyo.vim",    cmd = "Goyo" },

  -- Make vim.ui.input and vim.ui.select prettier
  "stevearc/dressing.nvim",

  -- Improve neovim lua development (better completion, help, etc...)
  "folke/neodev.nvim",
  "jose-elias-alvarez/typescript.nvim",

  "mbbill/undotree",
  "Wansmer/sibling-swap.nvim",
  {
    "axieax/urlview.nvim",
    config = function()
      require("urlview").setup()
    end,
  },
  {
    "ruifm/gitlinker.nvim",
    config = function()
      require("gitlinker").setup()
    end,
  },

  { "kevinhwang91/nvim-bqf", ft = "qf" },
}
