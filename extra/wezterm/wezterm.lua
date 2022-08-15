local wezterm = require("wezterm")
local act = wezterm.action

return {
  font = wezterm.font("agave Nerd Font Mono"),
  line_height = 1.2,
  font_size = 17.0,
  color_scheme = "MaterialDarker",
  audible_bell = "Disabled",
  keys = {
    { key = "r", mods = "CMD|SHIFT", action = act.ReloadConfiguration },

    -- Command + [/] are used for switching tabs in tmux
    { key = "[", mods = "CMD", action = act.SendKey({ key = "[", mods = "ALT" }) },
    { key = "]", mods = "CMD", action = act.SendKey({ key = "]", mods = "ALT" }) },

    -- Command + hjkl are used for switching between tmux windows
    { key = "h", mods = "CMD", action = act.SendKey({ key = "h", mods = "ALT" }) },
    { key = "j", mods = "CMD", action = act.SendKey({ key = "j", mods = "ALT" }) },
    { key = "k", mods = "CMD", action = act.SendKey({ key = "k", mods = "ALT" }) },
    { key = "l", mods = "CMD", action = act.SendKey({ key = "l", mods = "ALT" }) },
  },
}
