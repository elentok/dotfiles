local wezterm = require("wezterm")
local setupUi = require("ui")
local setupKeys = require("keys")
local setupSplitPanes = require("split-panes")
require("status")

local local_config_dir = os.getenv("HOME") .. "/.dotprivate/wezterm"

local config = {
  enable_kitty_graphics = true,
}
setupUi(config)
setupKeys(config)
setupSplitPanes(config)

for _, file in ipairs(wezterm.glob(local_config_dir .. "/*.lua")) do
  local config_fn = dofile(file)
  config_fn(config)
end

return config
