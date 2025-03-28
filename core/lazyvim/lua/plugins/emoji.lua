return {
  "allaman/emoji.nvim",
  ft = "markdown",
  opts = {},
  keys = {
    {
      "<leader>ie",
      function()
        require("emoji").insert()
      end,
      desc = "Insert emoji",
    },
  },
}
