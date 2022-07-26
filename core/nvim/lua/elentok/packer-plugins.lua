return require("packer").startup({
  function()
    use("wbthomason/packer.nvim")

    -- Optimizations.
    use("lewis6991/impatient.nvim")
    use("nathom/filetype.nvim")

    -- Color scheme.
    use("rmehri01/onenord.nvim")

    -- File manager.
    -- use "cocopon/vaffle.vim"
    use("vifm/vifm.vim")
    use("tamago324/lir.nvim")

    -- Comments
    use("numToStr/Comment.nvim")

    use("tpope/vim-abolish")
    use("tpope/vim-dispatch")
    use("tpope/vim-eunuch")
    use("tpope/vim-fugitive")
    use("tpope/vim-repeat")
    use("tpope/vim-surround")
    use("tpope/vim-unimpaired")

    -- Automatically close bracket and tag pairs
    use({
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup()
      end,
    })

    -- LSP.
    use("neovim/nvim-lspconfig")
    -- use "hrsh7th/nvim-compe"
    -- use "anott03/nvim-lspinstall"
    use("ray-x/lsp_signature.nvim")
    use("stevearc/aerial.nvim")
    use("jose-elias-alvarez/null-ls.nvim")
    use({
      "j-hui/fidget.nvim",
      config = function()
        require("fidget").setup()
      end,
    })
    use({ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" })
    -- use({
    --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --   config = function()
    --     require("lsp_lines").setup()
    --
    --     -- Disable virtual_text since it's redundant due to lsp_lines.
    --     vim.diagnostic.config({
    --       virtual_text = false,
    --     })
    --   end,
    -- })

    -- Completion.
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/nvim-cmp")
    use("onsails/lspkind-nvim")
    use("lukas-reineke/cmp-rg")
    use("uga-rosa/cmp-dictionary")

    -- Snippets
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")
    use("rafamadriz/friendly-snippets") -- collection of snippets for all langs

    -- Allows running "nvim {filename}:{line-number}".
    use("bogado/file-line")

    -- FZF.
    use("junegunn/fzf")
    use("junegunn/fzf.vim")

    -- Telescope
    use("nvim-telescope/telescope.nvim")
    use("nvim-telescope/telescope-file-browser.nvim")
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

    -- Treesitter
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("nvim-treesitter/nvim-treesitter-textobjects")
    use("SmiteshP/nvim-gps")
    use("folke/twilight.nvim") -- focus active code block
    use({
      "lewis6991/spellsitter.nvim",
      config = function()
        require("spellsitter").setup()
      end,
    })

    -- Syntax.
    use("aklt/plantuml-syntax")

    -- Misc.
    -- use "junegunn/vim-easy-align"
    -- use({
    --   "stevearc/dressing.nvim",
    --   config = function()
    --     require("dressing").setup({
    --       input = {
    --         relative = "win", -- center the input prompt
    --       },
    --     })
    --   end,
    -- })
    use("mhinz/vim-signify")
    use("michaeljsmith/vim-indent-object")
    use("nelstrom/vim-visual-star-search")
    use("christoomey/vim-tmux-navigator")
    use("voldikss/vim-floaterm")
    use("numToStr/FTerm.nvim")
    use("nvim-lua/popup.nvim")
    use("nvim-lua/plenary.nvim")
    use("AndrewRadev/splitjoin.vim")
    use("jamessan/vim-gnupg")
    use("davidbeckingsale/writegood.vim")
    use("sotte/presenting.vim") -- Presentation tool
    use("karb94/neoscroll.nvim") -- Smooth scrolling
    use("kyazdani42/nvim-web-devicons")
    use("TimUntersberger/neogit") -- Git client
    use("nvim-lualine/lualine.nvim") -- Statusline
    use("tversteeg/registers.nvim") -- Shows registers contents when using them
    use("b0o/incline.nvim") -- Shows buffer names on windows
    use({
      "salkin-mada/openscad.nvim",
      config = function()
        pcall(require, "openscad")
      end,
    })

    -- use "ggandor/lightspeed.nvim" -- Move quickly between positions

    -- Toggles words (e.g. true/false, top/bottom)
    use({
      "elentok/togglr.vim",
      config = function()
        require("togglr").setup()
      end,
    })

    -- Lazy
    use({ "itchyny/calendar.vim", opt = true, cmd = "Calendar" })

    -- dark/zen room, no distraction mode
    use({ "junegunn/goyo.vim", opt = true, cmd = "Goyo" })

    -- use {
    --   "nvim-neo-tree/neo-tree.nvim",
    --   branch = "v2.x",
    --   requires = {
    --     "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
    --     "MunifTanjim/nui.nvim"
    --   }
    -- }
  end,
  config = {
    display = { open_fn = require("packer.util").float },
    max_jobs = 10,
    -- disable for now (https://github.com/wbthomason/packer.nvim/issues/201)
    -- Move to lua dir so impatient.nvim can cache it
    -- compile_path = vim.fn.stdpath("cache") .. "/lua/packer_compiled.lua",
    -- compile_on_sync = true
  },
})
