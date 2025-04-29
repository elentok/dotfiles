---@class StatusConfigOpts
---@field title string
---@field char string
---@field icon? string
---@field hl? table<string, any>

---@class TodoConfigOpts
---@field statuses table<string, StatusConfigOpts>

---@class StatusConfig
---@field title string
---@field char string
---@field icon? string
---@field hl? table<string, any>
---@field hl_group string
---@field raw string
---@field is_custom boolean

---@class TodoConfig
---@field statuses table<string, StatusConfig>
