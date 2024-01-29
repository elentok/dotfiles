return {
  "max397574/colortils.nvim",
  cmd = "Colortils",
  config = function()
    require("colortils").setup()
  end,
  keys = {
    { "<leader>cp", "<cmd>Colortils<cr>", mode = "n", desc = "Color picker" },
  },
}
