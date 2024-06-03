return {
  "ptdewey/yankbank-nvim",
  config = function()
    require("yankbank").setup()
  end,
  lazy = false,
  keys = {
    {
      "<leader>yy",
      "<cmd>YankBank<cr>",
      desc = "YankBank",
    },
  },
}
