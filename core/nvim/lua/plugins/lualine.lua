return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    options = {
      theme = "catppuccin",
      disabled_filetypes = {
        statusline = { "snacks_dashboard" },
      },
    },
    sections = {
      lualine_x = { { "lsp_status" } },
    },
    winbar = { lualine_b = { "filename" } },
    inactive_winbar = { lualine_b = { "filename" } },
    extensions = { require("elentok.lualine-oil-extension") },
  },
}
