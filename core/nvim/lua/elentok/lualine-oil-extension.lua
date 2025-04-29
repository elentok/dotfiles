local function oil_pretty_dir()
  local dir = require("oil").get_current_dir()
  if dir == nil then
    return nil
  end
  return " " .. vim.fn.fnamemodify(dir, ":~")
end

local oil_extension = {
  sections = {
    lualine_a = { oil_pretty_dir },
  },
  winbar = {
    lualine_a = { oil_pretty_dir },
  },
  filetypes = { "oil" },
}

return oil_extension
