return {
  "folke/trouble.nvim",
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble" },
  keys = {
    {
      "<leader>tt",
      "<cmd>TroubleToggle<cr>",
      desc = "Toggle Trouble",
    },
  },
}
