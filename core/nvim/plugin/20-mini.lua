---@diagnostic disable-next-line: duplicate-set-field
package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end

require("mini.bracketed").setup({})
require("mini.pairs").setup({})
require("mini.move").setup({})
