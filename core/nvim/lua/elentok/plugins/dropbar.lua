return {
  "Bekaboo/dropbar.nvim",
  -- optional, but required for fuzzy finder support
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  lazy = false,
  keys = {
    {
      "gm",
      function()
        require("dropbar.api").pick()
      end,
      desc = "Open dropbar picker",
    },
  },
}
