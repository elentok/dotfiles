local spinner = { "", "", "", "", "", "" }

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    options = {
      theme = "catppuccin",
      disabled_filetypes = {
        statusline = { "snacks_dashboard" },
      },
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_x = { { "lsp_status", symbols = { spinner = spinner } } },
    },
    winbar = { lualine_b = { "filename" } },
    inactive_winbar = { lualine_b = { "filename" } },
    extensions = { require("elentok.lualine-oil-extension") },
  },
}
