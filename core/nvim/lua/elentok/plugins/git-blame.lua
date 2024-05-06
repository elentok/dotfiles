return {
  "FabijanZulj/blame.nvim",
  cmd = { "BlameToggle" },
  keys = {
    {
      "<leader>gbt",
      "<cmd>BlameToggle<cr>",
      mode = "n",
      desc = "Toggle git blame",
    },
  },
  opts = {
    merge_consecutive = true,
  },
}
