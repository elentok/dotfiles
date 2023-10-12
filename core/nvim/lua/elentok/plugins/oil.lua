return {
  "stevearc/oil.nvim",
  version = "*",
  ft = "oil",
  opts = {
    skip_confirm_for_simple_edits = false,
    win_options = {
      winbar = "%f",
    },
    keymaps = {
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["<C-c>"] = false,
      ["<C-p>"] = false,
      ["<C-s>"] = "actions.save",
      ["<space>p"] = "actions.preview",
      ["q"] = "actions.close",
      ["L"] = "actions.select",
      ["J"] = "actions.select",
      ["H"] = "actions.parent",
      ["K"] = "actions.parent",
      ["R"] = "actions.refresh",
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "-",
      function()
        require("oil").open()
      end,
      desc = "Open parent directory",
    },
  },
}
