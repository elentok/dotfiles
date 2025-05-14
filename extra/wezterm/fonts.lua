local wezterm = require("wezterm")
local h = require("helpers")

local function setupFonts(config)
  config.font = wezterm.font("CaskaydiaCove Nerd Font", { weight = "Regular" }) -- freetype_load_flags = "NO_HINTING"
  config.line_height = 1.2
  config.underline_position = -3
  -- config.cell_width = 1.05
  config.font_rules = {
    {
      italic = true,
      font = wezterm.font("Operator Mono", { weight = 325, italic = true }),
    },
  }
  if h.is_macos() then
    config.font_size = 16
  else
    config.font_size = 12
  end

  config.window_frame = {
    font_size = 14,
  }

  config.command_palette_font_size = 16

  -- Disable ligatures
  config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
end

return setupFonts
