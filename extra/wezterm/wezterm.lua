local wezterm = require("wezterm")
require("status")

local config = wezterm.config_builder()
config:set_strict_mode(true)

config.adjust_window_size_when_changing_font_size = false
require("keys")(config)
require("fonts")(config)
require("smart-splits")(config)

config.color_scheme = "Catppuccin Mocha"
config.audible_bell = "Disabled"

config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true
config.tab_max_width = 40
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

return config
