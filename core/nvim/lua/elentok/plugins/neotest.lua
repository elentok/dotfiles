local function test_file()
  require("neotest").run.run({ vim.fn.expand("%"), vitestCommand = "yarn test watch" })
  print("Neotest: watching current file")
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "antoinemadec/FixCursorHold.nvim",
    "marilari88/neotest-vitest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest"),
      },
    })

    vim.keymap.set("n", "<leader>tr", test_file, { desc = "Test current file" })
    vim.keymap.set(
      "n",
      "<leader>to",
      "<cmd>Neotest output-panel<cr>",
      { desc = "Test current file" }
    )
  end,
}
