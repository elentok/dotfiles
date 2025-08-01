-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local Event = require("lazy.core.handler.event")
Event.mappings.LazyFile =
  { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }

-- Setup lazy.nvim
require("lazy").setup({
  root = vim.fn.stdpath("data") .. "/lazy",
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  dev = {
    path = "~/dev/nvim",
    fallback = true,
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "catppuccin" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
  ui = {
    border = "rounded",
  },
})
