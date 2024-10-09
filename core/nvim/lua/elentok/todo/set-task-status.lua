local config = require("elentok.todo.config")

local statuses_with_icons = {}
for _, status in pairs(config.statuses) do
  table.insert(statuses_with_icons, status.icon .. " " .. status.title)
end

local function replace_in_current_line(pattern, replacement)
  local line = vim.api.nvim_get_current_line()
  local new_line = string.gsub(line, pattern, replacement)
  vim.api.nvim_set_current_line(new_line)
end

local function set_task_status()
  require("fzf-lua").fzf_exec(statuses_with_icons, {
    prompt = "Status> ",
    winopts = {
      width = 20,
      height = #statuses_with_icons + 2,
    },
    actions = {
      ["default"] = function(selected)
        local status_line = selected[1]
        local index = vim.fn.index(statuses_with_icons, status_line)
        local status = vim.tbl_values(config.statuses)[index + 1]
        replace_in_current_line("%[.%]", "[" .. status.char .. "]")
      end,
    },
  })
end

return set_task_status
