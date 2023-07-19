vim.o.termguicolors = true
vim.o.background = "dark"

-- local ok, onenord = pcall(require, "onenord")
-- if not ok then
--   return
-- end
--
-- onenord.setup({
--   styles = {
--     comments = "italic",
--   },
--   custom_colors = {
--     bg = "#232730",
--   },
-- })

----------------------------------------------------
-- Set different background for active windows

-- vim.cmd([[
--   hi NormalNC guibg=#171b20
--   hi VertSplit guibg=#171b20
-- ]])

require("catppuccin").setup({
  flavour = "macchiato",
  dim_inactive = {
    enabled = true,
    shade = "dark",
  },
  integrations = {
    cmp = true,
    gitsigns = true,
    flash = true,
    mason = true,
    navic = true,
    aerial = true,
    harpoon = true,
    markdown = true,
    which_key = true,
    telescope = true,
    treesitter = true,
    fidget = true,
  },
  custom_highlights = function(colors)
    return {
      VertSplit = { fg = colors.surface2 },
    }
  end,
})

vim.cmd.colorscheme("catppuccin")

-- Tmux support (requires "focus-events" to be on in tmux.conf)
-- vim.api.nvim_create_autocmd({ "FocusGained" }, {
--   callback = function()
--     vim.api.nvim_set_hl(0, "Normal", { bg = "#232730" })
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({ "FocusLost" }, {
--   callback = function()
--     vim.api.nvim_set_hl(0, "Normal", { bg = "#171b20" })
--   end,
-- })
