return {
  "allaman/emoji.nvim",
  ft = "markdown",
  opts = {
    -- default is false, also needed for blink.cmp integration!
    enable_cmp_integration = true,
  },
  keys = {
    {
      "<leader>ie",
      function()
        require("emoji").insert()
      end,
    },
    {
      "<c-x>e",
      function()
        require("emoji").insert()
      end,
      mode = "i",
    },
  },
}
