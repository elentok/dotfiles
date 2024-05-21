local wezterm = require("wezterm")

local function is_macos()
  return wezterm.target_triple:find("darwin") ~= nil
end

local ctrl_or_cmd = "CTRL"
if is_macos() then
  ctrl_or_cmd = "CMD"
end

local function extend_array(dest, source)
  for _, v in ipairs(source) do
    table.insert(dest, v)
  end
end

return { is_macos = is_macos, ctrl_or_cmd = ctrl_or_cmd, extend_array = extend_array }
