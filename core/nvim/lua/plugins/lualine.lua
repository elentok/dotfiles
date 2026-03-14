local spinner = { "", "", "", "", "", "" }

local filename = {
  "filename",
  symbols = {
    modified = " ",
    readonly = " ",
    unnamed = " No name",
  },
}

local long_filename_block = vim.tbl_extend("force", filename, {
  path = 1, -- relative path
})

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "echasnovski/mini.icons", "SmiteshP/nvim-navic" },
  opts = {
    options = {
      theme = "auto",
      disabled_filetypes = {
        statusline = { "snacks_dashboard" },
        winbar = { "snacks_dashboard" },
      },
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_c = { long_filename_block },
      lualine_x = { { "lsp_status", symbols = { spinner = spinner } }, "filetype" },
    },
    winbar = { lualine_b = { filename }, lualine_c = { "navic" } },
    inactive_winbar = { lualine_b = { filename }, lualine_c = { "navic" } },
    extensions = { require("elentok.lualine-oil-extension") },
  },
}
