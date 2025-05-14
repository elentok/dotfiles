local wezterm = require("wezterm")
local h = require("helpers")
local act = wezterm.action
local nvimScrollbackKey = require("nvim-scrollback")

local function mapCmdToCtrl(config)
  -- Removed "b" on purpose since Cmd+E is the leader key
  -- Removed "v" on purpose since Cmd+V pastes
  -- Removed "hjkl" since they are used to switch panes
  local keys = "acdfgimnopqrstuwxyz[]\\^_0;"
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
    {
      key = "q",
      mods = "NONE",
      action = act.Multiple({
        act({ CopyMode = "Close" }),
        act.ScrollToBottom,
      }),
    },
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
  config.leader = { key = "e", mods = h.ctrl_or_cmd }
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
    { key = ",", mods = "LEADER|" .. h.ctrl_or_cmd, action = act.MoveTabRelative(-1) },
    { key = ".", mods = "LEADER|" .. h.ctrl_or_cmd, action = act.MoveTabRelative(1) },
    { key = "c", mods = "LEADER", action = act.SpawnTab("DefaultDomain") },
    { key = "m", mods = "LEADER", action = act.ActivateCopyMode },

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

    { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
    { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
    { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
    { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
    { key = "5", mods = "LEADER", action = act.ActivateTab(4) },

    {
      key = "e",
      mods = "LEADER|" .. h.ctrl_or_cmd,
      action = act.ActivateLastTab,
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
        -- act.ClearSelection,
        -- act.CopyMode("ClearPattern"),
        -- act.CopyMode("ClearSelectionMode"),
        -- act.Search("CurrentSelectionOrEmptyString"),
        -- act.ActivateCopyMode,
        -- act.CopyMode({ MoveByPage = -0.5 }),
        act.ScrollByPage(-0.5),
        act.ActivateCopyMode,
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

  if h.is_macos() then mapCmdToCtrl(config) end

  setupCopyMode(config)
  setupSearchMode(config)
end

return setupKeys
