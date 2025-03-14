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

---@module "lazy"
---@type LazySpec
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "SmiteshP/nvim-navic",
    opts = {
      lsp = {
        auto_attach = true,
      },
    },
  },
  opts = {
    options = {
      -- theme = "onedark",
      theme = "catppuccin",
      section_separators = { left = "", right = "" },
    },
    extensions = { oil_extension, "fzf" },
    sections = {
      lualine_a = { { "filename", path = 4, shorting_target = 60 } },
      lualine_b = {},
      lualine_c = {},
      -- lualine_b = { { "filename", path = 1, icon = "" } },
      -- lualine_b = { { shortener.dir, icon = "" } },
      -- lualine_c = { "branch" },
      -- lualine_x = {
      --   { navic_get_location, cond = navic_is_available },
      -- },
      lualine_x = { "diagnostics", "filetype" },
      lualine_y = { { "branch", icon = "" } },
      -- Location with total lines: line/total:char
      lualine_z = { "%l/%L:%c" },
    },
    winbar = {
      lualine_a = { "navic" },
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
