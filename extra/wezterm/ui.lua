local wezterm = require("wezterm")
local h = require("helpers")

local function setupFonts(config)
  --[[ config.font = wezterm.font("Hack Nerd Font", { weight = "Regular" }) ]]
  -- config.font = wezterm.font("MonaspiceKr NF", { weight = "Light" })
  -- config.font = wezterm.font("MonaspiceKr NF")
  -- config.font = wezterm.font("ZedMono NF", { weight = "Regular" })
  config.font = wezterm.font("ZedMono NF Light")
  -- config.font = wezterm.font("ComicShannsMono Nerd Font Mono")
  config.font_rules = {
    {
      italic = true,
      font = wezterm.font("Operator Mono", { weight = 325, italic = true }),
    },
  }
  -- config.line_height = 1.1
  -- config.cell_width = 1.05
  if h.is_macos() then
    config.font_size = 14
  else
    config.font_size = 12
  end
  config.command_palette_font_size = 16
end

local function setupUi(config)
  setupFonts(config)
  config.color_scheme = "Catppuccin Mocha"
  -- config.color_scheme = "MaterialDarker",
  config.audible_bell = "Disabled"

  config.window_decorations = "RESIZE"
  config.tab_bar_at_bottom = false
  config.use_fancy_tab_bar = true
  config.tab_max_width = 30
  config.show_new_tab_button_in_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = false
  config.underline_position = -3

  config.window_frame = {
    -- Berkeley Mono for me again, though an idea could be to try a
    -- serif font here instead of monospace for a nicer look?
    -- font = wezterm.font("Operator Mono", { weight = 325, italic = true }),
    font = wezterm.font("ComicShannsMono Nerd Font Mono"),
    font_size = config.font_size,
  }

  config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  }
end

return setupUi
