---@diagnostic disable-next-line: duplicate-set-field
package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end

require("mini.bracketed").setup({})
require("mini.pairs").setup({})
require("mini.move").setup({})
require("mini.files").setup({
  mappings = {
    synchronize = "s",
    go_in_plus = "<CR>",
  },
})

vim.keymap.set("n", "-", function()
  local filepath = vim.api.nvim_buf_get_name(0)
  MiniFiles.open(filepath)
end, { desc = "Open parent directory" })
