return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    options = {
      theme = "catppuccin",
    },
    winbar = { lualine_b = { "filename" } },
    inactive_winbar = { lualine_b = { "filename" } },
    extensions = { require("elentok.lualine-oil-extension") },
  },
}
