return {
  "linrongbin16/gitlinker.nvim",
  opts = { mappings = "" },
  keys = {
    {
      "<leader>gy",
      function()
        require("gitlinker").link({ action = require("gitlinker.actions").clipboard })
      end,
      mode = { "n", "v" },
      desc = "Git yank URL",
    },
    {
      "<leader>go",
      function()
        require("gitlinker").link({ action = require("gitlinker.actions").system })
      end,
      mode = { "n", "v" },
      desc = "Git open in browser",
    },
  },
}
