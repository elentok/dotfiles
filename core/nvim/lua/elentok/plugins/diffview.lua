return {
  "sindrets/diffview.nvim",
  lazy = true,
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
