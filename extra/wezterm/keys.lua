local wezterm = require("wezterm")
local h = require("helpers")
local act = wezterm.action
local nvimScrollbackKey = require("nvim-scrollback")

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

local function setupCopyMode(config)
  config.key_tables.copy_mode = wezterm.gui.default_key_tables().copy_mode
  h.extend_array(config.key_tables.copy_mode, {
    { key = "/", action = act.Search({ CaseInSensitiveString = "" }) },
    { key = "p", action = act.CopyMode("PriorMatch") },
    { key = "n", action = act.CopyMode("NextMatch") },
  })
end

local function setupSearchMode(config)
  config.key_tables.search_mode = wezterm.gui.default_key_tables().search_mode
  h.extend_array(config.key_tables.search_mode, {
    { key = "Enter", action = act.ActivateCopyMode },
  })
end

local function setupKeys(config)
  config.key_tables = {}
  config.leader = { key = "e", mods = "CMD" }
  config.keys = {
    -- Pane actions
    { key = "s", mods = "LEADER", action = act.SplitPane({ direction = "Down" }) },
    { key = "v", mods = "LEADER", action = act.SplitPane({ direction = "Right" }) },

    -- Tab actions
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
    { key = ",", mods = h.ctrl_or_cmd, action = act.ActivateTabRelative(-1) },
    { key = ".", mods = h.ctrl_or_cmd, action = act.ActivateTabRelative(1) },
    { key = "c", mods = "LEADER", action = act.SpawnTab("DefaultDomain") },

    { key = "r", mods = "LEADER", action = act.ShowLauncher },

    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {
      key = "d",
      mods = "LEADER",
      action = act.Multiple({
        act.ActivateCopyMode,
        act.CopyMode("ClearPattern"),
      }),
    },
    { key = "/", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },

    -- Misc
    { key = "p", mods = "LEADER", action = act.ActivateCommandPalette },
    { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
    nvimScrollbackKey,
  }

  if h.is_macos() then
    mapCmdToCtrl(config)
  end

  setupCopyMode(config)
  setupSearchMode(config)
end

return setupKeys
