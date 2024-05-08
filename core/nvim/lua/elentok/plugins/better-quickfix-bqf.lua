return {
  "kevinhwang91/nvim-bqf",
  ft = "qf",
  dependencies = {
    {
      "junegunn/fzf",
      run = function()
        vim.fn["fzf#install"]()
      end,
    },
  },
}
