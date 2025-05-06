return {
  "MagicDuck/grug-far.nvim",
  opts = {},
  keys = {
    { "<leader>fr", "<Cmd>GrugFar<cr>", desc = "Find and replace" },
    {
      "<leader>fr",
      function() require("grug-far").with_visual_selection() end,
      mode = "v",
      desc = "Find and replace (selection)",
    },
    {
      "<leader>wfr",
      function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end,
      mode = "n",
      desc = "Find and replace (selection)",
    },
  },
}
