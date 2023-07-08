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
  "hrsh7th/cmp-cmdline",

  -- Snippets
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },

  -- Extra LSP plugins
  -- "ray-x/lsp_signature.nvim",
  "stevearc/aerial.nvim",
  "jose-elias-alvarez/null-ls.nvim",
  "onsails/lspkind-nvim",
  "lukas-reineke/cmp-rg",
  {
    "folke/trouble.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },
  -- {
  --   "j-hui/fidget.nvim", -- Shows LSP init progress
  --   tag = "legacy",
  --   config = function()
  --     require("fidget").setup()
  --   end,
  -- },

  -- Allows running "nvim {filename}:{line-number}".
  "bogado/file-line",

  -- FZF.
  "junegunn/fzf",
  "junegunn/fzf.vim",

  -- Telescope
  { "nvim-telescope/telescope.nvim", tag = "0.1.2" },
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
  -- Presentation tool
  "sotte/presenting.vim",
  -- Smooth scrolling
  "karb94/neoscroll.nvim",
  "kyazdani42/nvim-web-devicons",
  "kdheepak/lazygit.nvim",
  { "akinsho/git-conflict.nvim", version = "v1.1.2" },
  "nvim-lualine/lualine.nvim",
  -- Shows registers contents when using them
  "tversteeg/registers.nvim",
  "b0o/incline.nvim", -- Shows buffer names on windows
  "ThePrimeagen/harpoon",
  "ziontee113/color-picker.nvim",
  "ojroques/nvim-osc52",
  "mizlan/iswap.nvim",
  { "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async" } },
  {
    "salkin-mada/openscad.nvim",
    config = function()
      require("openscad")
    end,
  },

  -- Toggles words (e.g. true/false, top/bottom)
  {
    "elentok/togglr.vim",
    config = function()
      require("togglr").setup()
    end,
  },

  { "itchyny/calendar.vim", cmd = "Calendar" },

  -- dark/zen room, no distraction mode
  { "junegunn/goyo.vim", cmd = "Goyo" },

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
      require("urlview").setup({})
    end,
  },
  "ruifm/gitlinker.nvim",

  { "kevinhwang91/nvim-bqf", ft = "qf" },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      -- {
      --   "S",
      --   mode = { "n", "o", "x" },
      --   function()
      --     require("flash").treesitter()
      --   end,
      --   desc = "Flash Treesitter",
      -- },
      -- {
      --   "r",
      --   mode = "o",
      --   function()
      --     require("flash").remote()
      --   end,
      --   desc = "Remote Flash",
      -- },
      -- {
      --   "R",
      --   mode = { "o", "x" },
      --   function()
      --     require("flash").treesitter_search()
      --   end,
      --   desc = "Flash Treesitter Search",
      -- },
      {
        "<Leader>fs",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
      messages = {
        enabled = false,
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
}
