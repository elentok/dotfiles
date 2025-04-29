return {
  "MagicDuck/grug-far.nvim",
  opts = {},
  cmd = { "GrugFar" },
  keys = {
    { "<leader>\\", "<Cmd>GrugFar<cr>", desc = "Find and replace" },
    {
      "<leader>\\",
      function()
        require("grug-far").with_visual_selection()
      end,
      mode = "v",
      desc = "Find and replace (selection)",
    },
    {
      "<leader>w\\",
      function()
        require("grug-far").grug_far({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      mode = "n",
      desc = "Find and replace (selection)",
    },
  },
}
