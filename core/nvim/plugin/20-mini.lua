---@diagnostic disable-next-line: duplicate-set-field
package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end

require("mini.bracketed").setup({})
require("mini.pairs").setup({})
require("mini.move").setup({})
require("mini.files").setup({
  windows = {
    max_number = 2,
  },
  options = {
    permanent_delete = false,
  },
  mappings = {
    synchronize = "s",
    reset = "r",
    go_out = ",",
    go_in = ".",
    go_in_plus = "<cr>",
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    vim.keymap.set(
      "n",
      "-",
      MiniFiles.go_out,
      { buffer = args.data.buf_id, desc = "Go out of directory" }
    )
    vim.keymap.set(
      "n",
      "<CR>",
      function() MiniFiles.go_in({ close_on_file = true }) end,
      { buffer = args.data.buf_id, desc = "Go in entry plus" }
    )

    vim.keymap.set(
      "n",
      "m",
      function() MiniFiles.go_in({ close_on_file = true }) end,
      { buffer = args.data.buf_id, desc = "Go in entry plus" }
    )

    vim.keymap.set(
      "n",
      "<space>w",
      MiniFiles.synchronize,
      { buffer = args.data.buf_id, desc = "Synchronize" }
    )

    vim.keymap.set(
      "n",
      "<c-s>",
      MiniFiles.synchronize,
      { buffer = args.data.buf_id, desc = "Synchronize" }
    )
  end,
})

vim.keymap.set("n", "-", function()
  local filepath = vim.api.nvim_buf_get_name(0)
  MiniFiles.open(filepath)
end, { desc = "Open parent directory" })

vim.keymap.set("n", "<leader>k", function()
  local filepath = vim.api.nvim_buf_get_name(0)
  MiniFiles.open(filepath)
end, { desc = "Open parent directory" })
