-- Makes vim.ui.input and vim.ui.select prettier
return {
  "stevearc/dressing.nvim",
  opts = {
    --  Prevent <Esc> from closing the modal
    insert_only = false,
  },
}
