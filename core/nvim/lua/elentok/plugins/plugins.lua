return {
  { dir = "~/.dotprivate/nvim" },

  -- Color scheme.
  -- "rmehri01/onenord.nvim",
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- File manager.
  "tamago324/lir.nvim",

  -- Comments
  "numToStr/Comment.nvim",

  "tpope/vim-abolish",
  "tpope/vim-dispatch",
  "tpope/vim-eunuch",
  "tpope/vim-repeat",
  -- "tpope/vim-surround",
  "tpope/vim-unimpaired",

  "mbbill/undotree",

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  },

  -- Automatically close bracket and tag pairs
  { "windwp/nvim-autopairs", opts = {} },

  -- Allows running "nvim {filename}:{line-number}".
  "bogado/file-line",

  -- focus active code block
  -- {
  --   "folke/twilight.nvim",
  --   context = 14,
  --   dimming = {
  --     alpha = 0.5,
  --   },
  --   expand = {
  --     "function",
  --     "method",
  --     "table",
  --   },
  -- },
  -- "aklt/plantuml-syntax",
  "michaeljsmith/vim-indent-object",
  "bronson/vim-visual-star-search",
  "christoomey/vim-tmux-navigator",
  "numToStr/FTerm.nvim",
  "nvim-lua/plenary.nvim",
  "AndrewRadev/splitjoin.vim",
  "jamessan/vim-gnupg",
  "davidbeckingsale/writegood.vim",
  -- Presentation tool
  "sotte/presenting.vim",
  "nvim-tree/nvim-web-devicons",
  "nvim-lualine/lualine.nvim",
  -- Shows registers contents when using them
  -- "tversteeg/registers.nvim",
  -- "b0o/incline.nvim", -- Shows buffer names on windows

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    opts = {},
    keys = {
      {
        "<space>a",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Harpoon add file",
      },
      {
        "<space>e",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "Harpoon menu",
      },
      {
        "<space>1",
        function()
          require("harpoon.ui").nav_file(1)
        end,
        desc = "Harpoon jump to #1",
      },
      {
        "<space>2",
        function()
          require("harpoon.ui").nav_file(2)
        end,
        desc = "Harpoon jump to #2",
      },
      {
        "<space>3",
        function()
          require("harpoon.ui").nav_file(3)
        end,
        desc = "Harpoon jump to #3",
      },
      {
        "<space>4",
        function()
          require("harpoon.ui").nav_file(4)
        end,
        desc = "Harpoon jump o #4",
      },
    },
  },

  -- Color Picker
  {
    "ziontee113/color-picker.nvim",
    opts = {},
    keys = {
      { "<space>cp", "<cmd>PickColor<cr>", mode = "n", desc = "Color picker" },
    },
  },

  "ojroques/nvim-osc52",

  {
    "salkin-mada/openscad.nvim",
    ft = { "openscad" },
    config = function()
      require("openscad")
    end,
  },

  -- dark/zen room, no distraction mode
  { "junegunn/goyo.vim", cmd = "Goyo" },

  -- Make vim.ui.input and vim.ui.select prettier
  { "stevearc/dressing.nvim", opts = {} },

  -- URLView
  {
    "axieax/urlview.nvim",
    config = function()
      require("urlview").setup({})
    end,
  },

  { "kevinhwang91/nvim-bqf", ft = "qf" },

  "mfussenegger/nvim-lint",

  -- {
  --   "nvim-neorg/neorg",
  --   build = ":Neorg sync-parsers",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function()
  --     require("neorg").setup({
  --       load = {
  --         ["core.defaults"] = {}, -- Loads default behaviour
  --         ["core.concealer"] = {}, -- Adds pretty icons to your documents
  --         ["core.dirman"] = { -- Manages Neorg workspaces
  --           config = {
  --             workspaces = {
  --               notes = "~/notes",
  --             },
  --           },
  --         },
  --       },
  --     })
  --   end,
  -- },
}
