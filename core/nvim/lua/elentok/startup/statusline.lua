local shortener = require("elentok/lib/shortener")

local navic = require("nvim-navic")
local lualine = require("lualine")

local function navic_get_location()
  return navic.get_location()
end

local function navic_is_available()
  return navic.is_available()
end

lualine.setup({
  options = { theme = "onedark" },
  sections = {
    lualine_a = { "filename" },
    lualine_b = { { shortener.dir, icon = "" } },
    lualine_c = {},
    lualine_x = { { navic_get_location, cond = navic_is_available } },
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

vim.o.laststatus = 3
