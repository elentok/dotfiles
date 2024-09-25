local wezterm = require("wezterm")
local h = require("helpers")
local act = wezterm.action
local nvimScrollbackKey = require("nvim-scrollback")

local function mapCmdToCtrl(config)
  -- Removed "e" on purpose since Cmd+E is the leader key
  -- Removed "v" on purpose since Cmd+V pastes
  -- Removed "hjkl" since they are used to switch panes
  local keys = "bcdefgimnopqrstuwxyz[]\\^_0;"
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
  -- h.extend_array(config.key_tables.copy_mode, {
  h.extend_array(config.key_tables.copy_mode, {
    -- config.key_tables.copy_mode = {
    { key = "q", mods = "NONE", action = act({ CopyMode = "Close" }) },
    { key = "/", action = act.Search({ CaseInSensitiveString = "" }) },
    { key = "n", action = act.CopyMode("NextMatch") },
    { key = "N", mods = "SHIFT", action = act.CopyMode("PriorMatch") },
    { key = "u", action = act.CopyMode({ MoveByPage = -0.5 }) },
    { key = "d", action = act.CopyMode({ MoveByPage = 0.5 }) },
    { key = "u", mods = h.ctrl_or_cmd, action = act.CopyMode({ MoveByPage = -0.5 }) },
    { key = "d", mods = h.ctrl_or_cmd, action = act.CopyMode({ MoveByPage = 0.5 }) },
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
  config.leader = { key = "b", mods = h.ctrl_or_cmd }
  config.keys = {
    -- Pane actions
    { key = "s", mods = "LEADER", action = act.SplitPane({ direction = "Down" }) },
    { key = "v", mods = "LEADER", action = act.SplitPane({ direction = "Right" }) },

    -- Tab actions
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
    {
      key = ",",
      mods = h.ctrl_or_cmd,
      action = wezterm.action_callback(function(win, pane)
        if h.is_tmux(pane) then
          win:perform_action({ SendKey = { key = ",", mods = "META" } }, pane)
        else
          win:perform_action({ ActivateTabRelative = -1 }, pane)
        end
      end),
    },
    {
      key = ".",
      mods = h.ctrl_or_cmd,
      action = wezterm.action_callback(function(win, pane)
        if h.is_tmux(pane) then
          win:perform_action({ SendKey = { key = ".", mods = "META" } }, pane)
        else
          win:perform_action({ ActivateTabRelative = 1 }, pane)
        end
      end),
    },
    -- { key = ".", mods = h.ctrl_or_cmd, action = act.ActivateTabRelative(1) },
    { key = ",", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = ".", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "c", mods = "LEADER", action = act.SpawnTab("DefaultDomain") },

    { key = "l", mods = "LEADER", action = act.ShowDebugOverlay },
    { key = "r", mods = "LEADER", action = act.ShowLauncher },
    {
      key = "?",
      mods = "LEADER",
      action = wezterm.action_callback(function(win, pane)
        print("==============================")
        print("Variables:")
        print(pane:get_user_vars())
        win:perform_action(act.ShowDebugOverlay, pane)
      end),
    },

    {
      key = "d",
      mods = "LEADER|" .. h.ctrl_or_cmd,
      action = act.Multiple({
        act.ActivateCopyMode,
        act.ClearSelection,
        act.CopyMode("ClearSelectionMode"),
      }),
    },
    {
      key = "d",
      mods = "LEADER",
      action = act.Multiple({
        act.ActivateCopyMode,
        act.CopyMode("ClearPattern"),
      }),
    },
    {
      key = "u",
      mods = "LEADER|" .. h.ctrl_or_cmd,
      action = act.Multiple({
        act.ClearSelection,
        act.ActivateCopyMode,
        act.CopyMode("ClearPattern"),
        act.CopyMode("ClearSelectionMode"),
        act.CopyMode({ MoveByPage = -0.5 }),
      }),
    },
    -- { key = "d", action = act.ScrollByPage(0.5) },
    {
      key = "q",
      mods = "LEADER",
      action = act.QuickSelect,
    },
    { key = "/", mods = h.ctrl_or_cmd, action = act.Search({ CaseInSensitiveString = "" }) },
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
