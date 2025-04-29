local config = require("elentok.todo.config")

local function render_markdown_checkbox_config()
  local checkbox_config = { custom = {} }

  for name, status in pairs(config.statuses) do
    if status.is_custom then
      checkbox_config.custom[name] = {
        raw = "[" .. status.char .. "]",
        rendered = status.icon,
        highlight = status.hl_group,
        scope_highlight = status.hl_group,
      }
    else
      checkbox_config[name] = {
        icon = status.icon,
        highlight = status.hl_group,
        scope_highlight = status.hl_group,
      }
    end
  end

  return checkbox_config
end

return render_markdown_checkbox_config
