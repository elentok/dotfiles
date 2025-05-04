return {
  "lewis6991/gitsigns.nvim",
  event = { "LazyFile" },
  opts = {
    preview_config = {
      border = "rounded",
    },
  },
  keys = {
    {
      "<leader>gb",
      function() require("gitsigns").blame_line({ full = true }) end,
      desc = "Git blame",
    },
    {
      "<leader>gh",
      function() require("gitsigns").preview_hunk() end,
      desc = "Git preview hunk",
    },
    {
      "<leader>gt",
      function() require("gitsigns").toggle_word_diff() end,
      desc = "Git toggle word diff",
    },
  },
}
