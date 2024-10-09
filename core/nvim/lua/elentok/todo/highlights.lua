local config = require("elentok.todo.config")
local string_helpers = require("elentok.lib.string")

---@param name string
---@return string
local function highlight_group(name)
  return "Todo" .. string_helpers.snake_to_camel_case(name)
end

local function create_highlights()
  vim.api.nvim_set_hl(0, "TodoContext", { fg = "#88c0d0", italic = true })
  vim.api.nvim_set_hl(0, "TodoImportant", { fg = "#d57780" })

  for name, status in pairs(config.statuses) do
    if status.hl ~= nil then
      vim.api.nvim_set_hl(0, highlight_group(name), status.hl)
    end
  end
end

local function create_highlight_matchers()
  vim.fn.matchadd("TodoContext", "@[^ ]*")
  vim.fn.matchadd("TodoImportant", " !.*$")

  for _, status in pairs(config.statuses) do
    if status.hl ~= nil and status.is_custom then
      vim.fn.matchadd(status.hl_group, "\\[" .. status.char .. "\\].*$")
    end
  end
end

return {
  create_highlights = create_highlights,
  create_highlight_matchers = create_highlight_matchers,
  highlight_group = highlight_group,
}
