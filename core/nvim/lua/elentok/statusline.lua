local util = require("elentok/util")
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

-- local M = {}

-- function M.set_in_progress(text)
--   vim.b.statusline_in_progress = text
--   vim.o.statusline = vim.o.statusline -- force redraw of the statusline.
-- end

-- function _G.StatusLineInProgress()
--   return vim.b.statusline_in_progress or ""
-- end

-- function _G.StatusLineGps()
--   local location = ""

--   if gps and gps.is_available() then
--     location = gps.get_location()
--     if location ~= "" then
--       location = "[" .. location .. "]"
--     end
--   end

--   return location
-- end

-- _G.StatusLineFileName = M.filename

-- vim.o.statusline = table.concat({
--   -- Path to the file in the buffer, as typed or relative to current directory.
--   "%{v:lua.StatusLineFileName()}", -- Where to truncate line.
--   "%< ", "%{&modified?' +':''}", "%{&readonly?' ':''}",
--   -- Separation point between left and right aligned items.
--   "%= ", -- Filetype.
--   " %{v:lua.StatusLineGps()}", -- Which function am I in?
--   " %{v:lua.StatusLineInProgress()}", -- Operation in progress (e.g. formatting)
--   " [%{''!=#&filetype?&filetype:'none'}]", -- Line number + column number.
--   " %l:%v"
-- })

-- return M
