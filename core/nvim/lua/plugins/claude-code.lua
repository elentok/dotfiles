return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  lazy = false,
  opts = {
    keymaps = {
      toggle = {
        normal = "<leader>cc",
        terminal = "<c-q>",
      },
      window_navigation = false,
    },
  },
}
