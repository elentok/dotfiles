local string_helpers = require("elentok.lib.string")

---@param opts TodoConfigOpts
---@return TodoConfig
local function build_config(opts)
  local statuses = {}

  for name, status_opts in pairs(opts.statuses) do
    statuses[name] = {
      title = status_opts.title,
      char = status_opts.char,
      icon = status_opts.icon,
      hl = status_opts.hl,
      hl_group = "Todo" .. string_helpers.snake_to_camel_case(name),
      raw = "[" .. status_opts.char .. "]",
      is_custom = name ~= "checked" and name ~= "unchecked",
    }
  end

  return { statuses = statuses }
end

return build_config
