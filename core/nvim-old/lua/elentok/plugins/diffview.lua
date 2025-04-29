return {
  "sindrets/diffview.nvim",
  lazy = true,
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  opts = {
    keymaps = {
      view = {
        ["q"] = "<Cmd>DiffviewClose<cr>",
      },
      file_panel = {
        ["q"] = "<Cmd>DiffviewClose<cr>",
      },
    },
  },
}
