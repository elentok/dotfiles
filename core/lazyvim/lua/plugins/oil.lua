return {
  "stevearc/oil.nvim",
  version = "*",
  ft = "oil",
  lazy = false,
  opts = {
    skip_confirm_for_simple_edits = false,
    delete_to_trash = true,
    columns = {
      "icon",
      "size",
    },
    keymaps = {
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["<C-c>"] = false,
      ["<C-p>"] = false,
      ["<leader><leader>"] = "actions.preview",
      ["q"] = "actions.close",
      ["L"] = "actions.select",
      ["J"] = "actions.select",
      ["H"] = "actions.parent",
      ["K"] = "actions.parent",
      ["R"] = "actions.refresh",
    },
  },
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
