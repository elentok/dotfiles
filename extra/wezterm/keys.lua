local wezterm = require("wezterm")
local h = require("helpers")
local act = wezterm.action

local function mapCmdToCtrl(config)
  -- Removed "e" on purpose since Cmd+E is the leader key
  -- Removed "v" on purpose since Cmd+V pastes
  -- Removed "hjkl" since they are used to switch panes
  local keys = "abcdfgimnopqrstuwxyz"
  for i = 1, #keys do
    local key = string.sub(keys, i, i)
    table.insert(
      config.keys,
      { key = key, mods = "CMD", action = act.SendKey({ key = key, mods = "CTRL" }) }
    )
  end
end

local function setupKeys(config)
  config.leader = { key = "e", mods = "CMD" }
  config.keys = {
    { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
    { key = "s", mods = "LEADER", action = act.SplitPane({ direction = "Down" }) },
    { key = "v", mods = "LEADER", action = act.SplitPane({ direction = "Right" }) },

    -- { key = "r", mods = "LEADER", action = act.ShowLauncher },
    -- { key = "d", mods = "LEADER", action = act.DetachDomain("CurrentPaneDomain") },

    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    -- { key = "a", mods = "LEADER|CTRL", action = act.SendString("\x01") },

    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
    -- { key = "/", mods = "LEADER", action = act.Search },
    { key = "p", mods = "LEADER", action = act.ActivateCommandPalette },
    -- { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    -- { key = "[", mods = "LEADER", action = act.ActivateCopyMode },

    -- Command + [/] are used for switching tabs in tmux
    -- { key = "[", mods = "CMD", action = act.SendKey({ key = "[", mods = "ALT" }) },
    -- { key = "]", mods = "CMD", action = act.SendKey({ key = "]", mods = "ALT" }) },

    -- Command + hjkl are used for switching between tmux windows
    -- { key = "h", mods = "CMD", action = act.SendKey({ key = "h", mods = "ALT" }) },
    -- { key = "j", mods = "CMD", action = act.SendKey({ key = "j", mods = "ALT" }) },
    -- { key = "k", mods = "CMD", action = act.SendKey({ key = "k", mods = "ALT" }) },
    -- { key = "l", mods = "CMD", action = act.SendKey({ key = "l", mods = "ALT" }) },

    -- Command + hjkl to switch between panes
    -- { key = "h", mods = "CMD", action = act.ActivatePaneDirection("Left") },
    -- { key = "j", mods = "CMD", action = act.ActivatePaneDirection("Down") },
    -- { key = "k", mods = "CMD", action = act.ActivatePaneDirection("Up") },
    -- { key = "l", mods = "CMD", action = act.ActivatePaneDirection("Right") },

    -- Command + Shift + hjkl to resize panes
    -- { key = "H", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
    -- { key = "J", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
    -- { key = "K", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
    -- { key = "L", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

    -- Tmux-like
    -- { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- { key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- Close tab and pane
    -- { key = "X", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
    -- { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  }

  if h.is_macos() then
    mapCmdToCtrl(config)
  end

  print(config.keys)
end

return setupKeys
