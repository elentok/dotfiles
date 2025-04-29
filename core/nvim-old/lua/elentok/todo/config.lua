require("elentok.todo.types")
local build_config = require("elentok.todo.build-config")

local DONE_COLOR = "#6C7A96"

---@type TodoConfig
return build_config({
  statuses = {
    unchecked = {
      title = "Todo",
      char = " ",
      icon = "󱓼",
    },
    in_progress = {
      title = "In progress",
      char = "/",
      icon = "󰪠",
      hl = { fg = "#EBCB8B" },
    },
    waiting = {
      title = "Waiting",
      char = "w",
      icon = "󰏦",
      hl = { fg = "#C27D00" },
    },
    code_review = {
      title = "Code Review",
      char = "r",
      icon = "",
      hl = { fg = "#9369DB" },
    },
    checked = {
      title = "Done",
      char = "x",
      hl = { fg = DONE_COLOR },
      icon = "󰄬",
    },
  },
})
