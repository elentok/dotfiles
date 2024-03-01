return {
  "FabijanZulj/blame.nvim",
  cmd = { "ToggleBlame", "EnableBlame" },
  keys = {
    {
      "<leader>gbt",
      "<cmd>ToggleBlame virtual<cr>",
      mode = "n",
      desc = "Toggle git blame",
    },
  },
  opts = {
    merge_consecutive = true,
  },
}
