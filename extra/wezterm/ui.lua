local wezterm = require("wezterm")
local h = require("helpers")

local function setupFonts(config)
  config.font = wezterm.font("ComicShannsMono Nerd Font Mono")
  config.font_rules = {
    {
      italic = true,
      font = wezterm.font("Operator Mono", { weight = 325, italic = true }),
    },
  }
  config.line_height = 1.2
  config.cell_width = 1.0
  config.font_size = 14.0
  config.command_palette_font_size = 16.0
end

local function setupUi(config)
  setupFonts(config)
  config.color_scheme = "Catppuccin Mocha"
  -- config.color_scheme = "MaterialDarker",
  config.audible_bell = "Disabled"

  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  config.tab_max_width = 30
  config.show_new_tab_button_in_tab_bar = false
end

return setupUi
