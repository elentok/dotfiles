local wezterm = require("wezterm")
return {
  font = wezterm.font("agave Nerd Font Mono"),
  line_height = 1.2,
  font_size = 13.0,
  color_scheme = "MaterialDarker",
  audible_bell = "Disabled",
  keys = {
    {
      key = "V",
      mods = "SUPER|SHIFT",
      action = wezterm.action {PasteFrom = "Clipboard"}
    },
    {
      key = "V",
      mods = "CTRL|SHIFT",
      action = wezterm.action {PasteFrom = "PrimarySelection"}
    }
  }
}
