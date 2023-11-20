return {
  "mickael-menu/zk-nvim",
  config = function()
    require("zk").setup({
      picker = "telescope",
    })

    vim.keymap.set("n", "<leader>jn", "<cmd>ZkNotes<cr>")
  end,
}
