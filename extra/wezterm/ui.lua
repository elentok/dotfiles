local wezterm = require("wezterm")
local h = require("helpers")

local function setupFonts(config)
  --[[ config.font = wezterm.font("Hack Nerd Font", { weight = "Regular" }) ]]
  -- config.font = wezterm.font("MonaspiceKr NF", { weight = "Light" })
  -- config.font = wezterm.font("MonaspiceKr NF")
  -- config.font = wezterm.font("ZedMono NF", { weight = "Regular" })
  -- config.font = wezterm.font("ZedMono NF Light")
  -- config.font = wezterm.font("Agave Nerd Font")
  -- config.font = wezterm.font("IosevkaTerm Nerd Font", { weight = "Regular" }) -- freetype_load_flags = "NO_HINTING"
  -- config.font = wezterm.font("Inconsolata Nerd Font", { weight = "Regular" }) -- freetype_load_flags = "NO_HINTING"
  config.font = wezterm.font("CaskaydiaCove Nerd Font", { weight = "Regular" }) -- freetype_load_flags = "NO_HINTING"
  -- config.font = wezterm.font_with_fallback({ "Agave Nerd Font" })

  -- freetype_load_flags = "NO_HINTING"
  --   freetype_load_flags = "NO_HINTING"
  --   freetype_load_flags = "NO_HINTING"
  config.line_height = 1.2
  -- config.freetype_load_flags = "NO_HINTING"
  -- config.font = wezterm.font("ComicShannsMono Nerd Font Mono", { weight = "Regular" })
  -- config.font = wezterm.font("CaskaydiaMono Nerd Font Mono", { weight = "Light" })
  -- config.font = wezterm.font_with_fallback({
  --   { family = "CaskaydiaCove Nerd Font", weight = "Regular" },
  --   "Symbols Nerd Font Mono",
  -- })
  -- config.font = wezterm.font("CaskaydiaMono Nerd Font Mono", { weight = "Regular" })
  config.freetype_load_target = "Normal"
  -- config.freetype_render_target = "HorizontalLcd"
  config.font_rules = {
    {
      italic = true,
      font = wezterm.font("Operator Mono", { weight = 325, italic = true }),
    },
  }
  -- config.line_height = 1.1
  -- config.cell_width = 1.05
  if h.is_macos() then
    config.font_size = 16
  else
    config.font_size = 12
  end
  config.command_palette_font_size = 16

  -- Disable ligatures
  config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
end

local function setupUi(config)
  setupFonts(config)
  config.color_scheme = "Catppuccin Mocha"
  -- config.color_scheme = "MaterialDarker",
  config.audible_bell = "Disabled"

  -- config.window_decorations = "TITLE | RESIZE"
  config.tab_bar_at_bottom = false
  config.use_fancy_tab_bar = true
  config.tab_max_width = 40
  config.show_new_tab_button_in_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = true
  config.underline_position = -3
  -- config.underline_position = 0

  config.window_frame = {
    -- Berkeley Mono for me again, though an idea could be to try a
    -- serif font here instead of monospace for a nicer look?
    -- font = wezterm.font("Operator Mono", { weight = 325, italic = true }),
    -- font = wezterm.font("ComicShannsMono Nerd Font Mono"),
    -- font = wezterm.font("Agave Nerd Font Regular"),
    -- font = wezterm.font("ZedMono NF Light"),
    font_size = 14,
  }

  config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  }
end

return setupUi
