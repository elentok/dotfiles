return {
  "FabijanZulj/blame.nvim",
  cmd = { "BlameToggle" },
  keys = {
    {
      "<leader>tb",
      "<cmd>BlameToggle<cr>",
      mode = "n",
      desc = "Toggle git blame",
    },
  },
  opts = {
    merge_consecutive = true,
  },
}
