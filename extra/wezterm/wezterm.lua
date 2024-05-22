local wezterm = require("wezterm")
local setupUi = require("ui")
local setupKeys = require("keys")
local setupSplitPanes = require("split-panes")

local local_config_dir = os.getenv("HOME") .. "/.dotprivate/wezterm"

local config = {}
setupUi(config)
setupKeys(config)
setupSplitPanes(config)

for _, file in ipairs(wezterm.glob(local_config_dir .. "/*.lua")) do
  local config_fn = dofile(file)
  config_fn(config)
end

return config
