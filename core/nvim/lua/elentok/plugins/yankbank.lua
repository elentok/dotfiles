return {
  "ptdewey/yankbank-nvim",
  config = function()
    require("yankbank").setup()
  end,
  keys = {
    {
      "<leader>yy",
      "<cmd>YankBank<cr>",
      desc = "YankBank",
    },
  },
}
