return {
  "lewis6991/gitsigns.nvim",
  "tpope/vim-fugitive",
  -- { "akinsho/git-conflict.nvim", version = "v1.1.2" },
  {
    "linrongbin16/gitlinker.nvim",
    opts = { mappings = "" },
    keys = {
      {
        "<space>gy",
        function()
          require("gitlinker").link({ action = require("gitlinker.actions").clipboard })
        end,
        mode = { "n", "v" },
        desc = "Git yank URL",
      },
      {
        "<space>go",
        function()
          require("gitlinker").link({ action = require("gitlinker.actions").system })
        end,
        mode = { "n", "v" },
        desc = "Git open in browser",
      },
    },
  },
}
