require("elentok/loadtime")

if vim.env.DOTF == nil then
  vim.env.DOTF = vim.fn.expand("~/.dotfiles")
end

require("elentok/startup")
