return {
  { "tpope/vim-abolish", lazy = true, cmd = "S" },
  -- "tpope/vim-dispatch",
  { "tpope/vim-eunuch", lazy = true, cmd = { "Rename", "Mkdir", "Chmod", "SudoWrite" } },
  "tpope/vim-repeat",
  "tpope/vim-unimpaired",
  -- { "mbbill/undotree", lazy = true, cmd = { "UndotreeShow", "UndotreeToggle", "UndotreeFocus" } },
  "bogado/file-line", -- Allows running "nvim {filename}:{line-number}".
  "michaeljsmith/vim-indent-object",
  {
    "bronson/vim-visual-star-search",
    lazy = true,
    keys = { { "*", mode = { "v" } }, { "#", mode = { "v" } } },
  },
  -- {
  --   "christoomey/vim-tmux-navigator",
  --   cond = function()
  --     return vim.env.TMUX ~= nil
  --   end,
  -- },
  "numToStr/FTerm.nvim",
  "nvim-lua/plenary.nvim",
  "AndrewRadev/splitjoin.vim",
  "sotte/presenting.vim", -- Presentation tool
  { "nvim-tree/nvim-web-devicons", lazy = true },
  "nvim-lualine/lualine.nvim",

  { "windwp/nvim-autopairs", opts = {} },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  },

  {
    "salkin-mada/openscad.nvim",
    ft = { "openscad" },
    config = function()
      require("openscad")
    end,
  },
}
