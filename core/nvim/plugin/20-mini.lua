---@diagnostic disable-next-line: duplicate-set-field
package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end

require("mini.bracketed").setup({})
require("mini.pairs").setup({})
require("mini.move").setup({})
require("mini.files").setup({
  -- windows = {
  --   preview = true,
  -- },
  options = {
    permanent_delete = false,
  },
  mappings = {
    synchronize = "<space>w",
    go_in = "",
    go_in_plus = "l",
    -- go_out = "-",
  },
})

vim.keymap.set("n", "-", function()
  local filepath = vim.api.nvim_buf_get_name(0)
  MiniFiles.open(filepath)
end, { desc = "Open parent directory" })

vim.keymap.set("n", "<leader>k", function()
  local filepath = vim.api.nvim_buf_get_name(0)
  MiniFiles.open(filepath)
end, { desc = "Open parent directory" })
