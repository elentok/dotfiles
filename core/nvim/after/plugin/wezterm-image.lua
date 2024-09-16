local expand = require("open-link.expand")

---@param path string
local function preview_image(path)
  -- vim.system({ "wezterm", "cli", "split-pane", "--right", "wezterm", "imgcat", "--hold", path })
  vim.system({ "wezterm", "cli", "split-pane", "--right", "wezimg", path })
end

local function preview_image_at_cursor()
  local line = vim.api.nvim_get_current_line()

  local url = line:match("%((.-)%)")
  if url == nil then
    url = vim.fn.expand("<cfile>")
  end

  local expanded_url = expand(url):gsub("file://", "")
  preview_image(expanded_url)
end

vim.keymap.set("n", "gp", preview_image_at_cursor)
