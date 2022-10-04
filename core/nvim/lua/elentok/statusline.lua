local shortener = require("elentok/shortener")

local has_gps, gps = pcall(require, "nvim-gps")
local has_lualine, lualine = pcall(require, "lualine")
if not has_gps or not has_lualine then
  return
end

lualine.setup({
  options = { theme = "onedark" },
  sections = {
    lualine_a = { "filename" },
    lualine_b = { { shortener.dir, icon = "" } },
    lualine_c = {},
    lualine_x = { { gps.get_location, cond = gps.is_available } },
    lualine_y = { "filetype" },
  },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = { { shortener.dir, icon = "" } },
    lualine_z = { "filename" },
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = { { shortener.dir, icon = "" } },
    lualine_z = { "filename" },
  },
})

if vim.fn.has("nvim-0.8") == 1 then
  vim.o.laststatus = 3
end
