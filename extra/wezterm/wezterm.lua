local wezterm = require("wezterm")
local h = require("helpers")
local setupKeys = require("keys")
local setupSplitPanes = require("split-panes")

local local_config_dir = os.getenv("HOME") .. "/.dotprivate/wezterm"

print(h.ctrl_or_cmd)

local config = {
  -- font = wezterm.font("agave Nerd Font Mono"),
  -- font = wezterm.font("CaskaydiaMono NFM Light"),
  -- font = wezterm.font("Hurmit Nerd Font"),
  font = wezterm.font("ComicShannsMono Nerd Font Mono"),
  font_rules = {
    {
      italic = true,
      font = wezterm.font("Operator Mono", { weight = 325, italic = true }),
    },
  },
  line_height = 1.2,
  cell_width = 1.0,
  font_size = 14.0,
  color_scheme = "MaterialDarker",
  audible_bell = "Disabled",

  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  tab_max_width = 30,
  -- window_frame = {
  --   font_size = 16,
  --   font = wezterm.font("ComicShannsMono Nerd Font Mono"),
  -- },
  -- key_tables = {
  --   copy_mode = {
  --     { key = "u", mods = "CTRL", action = act.CopyMode("PageUp") },
  --     { key = "d", mods = "CTRL", action = act.CopyMode("PageDown") },
  --   },
  -- },
  -- leader = { key = "a", mods = "CTRL" },

  -- Work like tmux locally
  -- unix_domains = {
  --   { name = "unix" },
  -- },
  --
  -- default_gui_startup_args = { "connect", "unix" },
}

setupKeys(config)
setupSplitPanes(config)

for _, file in ipairs(wezterm.glob(local_config_dir .. "/*.lua")) do
  local config_fn = dofile(file)
  config_fn(config)
end

return config
