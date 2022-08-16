local wezterm = require("wezterm")
local act = wezterm.action

local local_config_dir = os.getenv("HOME") .. "/.dotlocal/wezterm"

local config = {
  font = wezterm.font("agave Nerd Font Mono"),
  font_rules = {
    {
      italic = true,
      font = wezterm.font("Operator Mono", { weight = 325, italic = true }),
    },
  },
  line_height = 1.2,
  font_size = 17.0,
  color_scheme = "MaterialDarker",
  audible_bell = "Disabled",
  keys = {
    { key = "r", mods = "CMD|SHIFT", action = act.ReloadConfiguration },

    { key = "r", mods = "LEADER", action = act.ShowLauncher },
    { key = "d", mods = "LEADER", action = act.DetachDomain("CurrentPaneDomain") },

    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = "a", mods = "LEADER|CTRL", action = act.SendString("\x01") },

    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },

    -- Command + [/] are used for switching tabs in tmux
    { key = "[", mods = "CMD", action = act.SendKey({ key = "[", mods = "ALT" }) },
    { key = "]", mods = "CMD", action = act.SendKey({ key = "]", mods = "ALT" }) },

    -- Command + hjkl are used for switching between tmux windows
    -- { key = "h", mods = "CMD", action = act.SendKey({ key = "h", mods = "ALT" }) },
    -- { key = "j", mods = "CMD", action = act.SendKey({ key = "j", mods = "ALT" }) },
    -- { key = "k", mods = "CMD", action = act.SendKey({ key = "k", mods = "ALT" }) },
    -- { key = "l", mods = "CMD", action = act.SendKey({ key = "l", mods = "ALT" }) },

    -- Command + hjkl to switch between panes
    { key = "h", mods = "CMD", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "CMD", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "CMD", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "CMD", action = act.ActivatePaneDirection("Right") },

    -- Command + Shift + hjkl to resize panes
    { key = "H", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "J", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
    { key = "K", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "L", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

    -- Tmux-like
    { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- Close tab and pane
    { key = "X", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  },
  -- key_tables = {
  --   copy_mode = {
  --     { key = "u", mods = "CTRL", action = act.CopyMode("PageUp") },
  --     { key = "d", mods = "CTRL", action = act.CopyMode("PageDown") },
  --   },
  -- },
  leader = { key = "a", mods = "CTRL" },

  -- Work like tmux locally
  unix_domains = {
    { name = "unix" },
  },

  default_gui_startup_args = { "connect", "unix" },
}

for _, file in ipairs(wezterm.glob(local_config_dir .. "/*.lua")) do
  local config_fn = dofile(file)
  config_fn(config)
end

return config
