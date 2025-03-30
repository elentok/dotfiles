return {
  "allaman/emoji.nvim",
  ft = "markdown",
  opts = {},
  cmds = { "Emoji" },
  keys = {
    {
      "<leader>ie",
      function()
        require("emoji").insert()
      end,
      desc = "Insert emoji",
    },
    {
      "<c-x><c-i>",
      function()
        require("emoji").insert()
      end,
      mode = "i",
      desc = "Insert emoji",
    },
  },
}
