local wezterm = require("wezterm")
return {
  font = wezterm.font("agave Nerd Font Mono"),
  line_height = 1.2,
  font_size = 17.0,
  color_scheme = "MaterialDarker",
  audible_bell = "Disabled",
  keys = {
    {
      key = "r",
      mods = "CMD|SHIFT",
      action = wezterm.action.ReloadConfiguration,
    },
  },
}
