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
})
