return {
  { "tpope/vim-abolish", lazy = true, cmd = "S" },
  -- "tpope/vim-dispatch",
  { "tpope/vim-eunuch", lazy = true, cmd = { "Rename", "Mkdir", "Chmod", "SudoWrite" } },
  "tpope/vim-repeat",
  "tpope/vim-unimpaired",
  { "mbbill/undotree", lazy = true, cmd = { "UndotreeShow", "UndotreeToggle", "UndotreeFocus" } },
  "bogado/file-line", -- Allows running "nvim {filename}:{line-number}".
  "michaeljsmith/vim-indent-object",
  "bronson/vim-visual-star-search",
  "christoomey/vim-tmux-navigator",
  "numToStr/FTerm.nvim",
  "nvim-lua/plenary.nvim",
  "AndrewRadev/splitjoin.vim",
  -- "jamessan/vim-gnupg",
  "davidbeckingsale/writegood.vim",
  "sotte/presenting.vim", -- Presentation tool
  "nvim-tree/nvim-web-devicons",
  "nvim-lualine/lualine.nvim",
  "ojroques/nvim-osc52",

  { "junegunn/goyo.vim", cmd = "Goyo" }, -- dark/zen room, no distraction mode
  { "axieax/urlview.nvim", opts = {} },
  { "windwp/nvim-autopairs", opts = {} },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  },

  -- Color Picker
  -- {
  --   "ziontee113/color-picker.nvim",
  --   opts = {},
  --   keys = {
  --     { "<leader>cp", "<cmd>PickColor<cr>", mode = "n", desc = "Color picker" },
  --   },
  -- },

  {
    "salkin-mada/openscad.nvim",
    ft = { "openscad" },
    config = function()
      require("openscad")
    end,
  },
}
