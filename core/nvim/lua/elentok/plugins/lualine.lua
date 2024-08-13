-- local shortener = require("elentok/lib/shortener")

local function oil_pretty_dir()
  return vim.fn.fnamemodify(require("oil").get_current_dir(), ":~")
end

local oil_extension = {
  sections = {
    lualine_a = { oil_pretty_dir },
  },
  winbar = {
    lualine_z = { oil_pretty_dir },
  },
  filetypes = { "oil" },
}

return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      -- theme = "onedark",
      theme = "catppuccin",
      section_separators = { left = "", right = "" },
    },
    extensions = { oil_extension },
    sections = {
      lualine_a = { { "filename", path = 4 } },
      lualine_b = {},
      lualine_c = {},
      -- lualine_b = { { "filename", path = 1, icon = "" } },
      -- lualine_b = { { shortener.dir, icon = "" } },
      -- lualine_c = { "branch" },
      -- lualine_x = {
      --   { navic_get_location, cond = navic_is_available },
      -- },
      lualine_x = { "diagnostics", "filetype" },
      lualine_y = { "branch" },
      lualine_z = { "location" },
    },
    winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      -- lualine_y = { { shortener.dir, icon = "" } },
      lualine_z = { "filename" },
    },
    inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      -- lualine_y = { { shortener.dir, icon = "" } },
      lualine_z = { "filename" },
    },
  },
  init = function()
    vim.o.laststatus = 3
  end,
}
