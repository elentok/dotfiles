---@module "oil"

require("oil").setup({
  skip_confirm_for_simple_edits = false,
  delete_to_trash = true,
  keymaps = {
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-c>"] = false,
    ["<C-p>"] = false,
    ["<C-s>"] = ":w<cr>",
    ["<leader>p"] = "actions.preview",
    q = "actions.close",
    L = "actions.select",
    J = "actions.select",
    H = "actions.parent",
    K = "actions.parent",
    R = "actions.refresh",
    [","] = "actions.parent",
    ["."] = "actions.select",
  },
})

vim.keymap.set("n", "-", function() require("oil").open() end, { desc = "Open parent directory" })
