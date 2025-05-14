local wezterm = require("wezterm")
local h = require("helpers")
local action = wezterm.action

---@param key string
---@param the_action string
local function mapLeader(key, the_action) return { key = key, mods = "LEADER", action = the_action } end

---@param key string
---@param the_action string
local function mapLeaderCmd(key, the_action)
  return { key = key, mods = "LEADER|" .. h.ctrl_or_cmd, action = the_action }
end

---@param key string
---@param the_action string
local function mapCmd(key, the_action)
  return { key = key, mods = h.ctrl_or_cmd, action = the_action }
end

local function mapCmdToCtrl(config)
  -- Removed "e" on purpose since Cmd+E is the leader key
  -- Removed "v" on purpose since Cmd+V pastes
  -- Removed "hjkl" since they are used to switch panes
  local keys = "abcdfgimnopqrstuwxyz[]\\^_0;"
  for i = 1, #keys do
    local key = string.sub(keys, i, i)
    table.insert(
      config.keys,
      { key = key, mods = "CMD", action = action.SendKey({ key = key, mods = "CTRL" }) }
    )
  end
end

local function setupCopyMode(config)
  config.key_tables.copy_mode = wezterm.gui.default_key_tables().copy_mode
  h.extend_array(config.key_tables.copy_mode, {
    {
      key = "q",
      mods = "NONE",
      action = action.Multiple({
        action({ CopyMode = "Close" }),
        action.ScrollToBottom,
      }),
    },
    { key = "/", action = action.Search({ CaseInSensitiveString = "" }) },
    { key = "n", action = action.CopyMode("NextMatch") },
    { key = "N", mods = "SHIFT", action = action.CopyMode("PriorMatch") },
    { key = "u", action = action.CopyMode({ MoveByPage = -0.5 }) },
    { key = "d", action = action.CopyMode({ MoveByPage = 0.5 }) },
    mapCmd("u", action.CopyMode({ MoveByPage = -0.5 })),
    mapCmd("d", action.CopyMode({ MoveByPage = 0.5 })),
  })
end

local function setupSearchMode(config)
  config.key_tables.search_mode = wezterm.gui.default_key_tables().search_mode
  h.extend_array(config.key_tables.search_mode, {
    { key = "Enter", action = action.ActivateCopyMode },
    { key = "d", mods = h.ctrl_or_cmd, action = action.CopyMode("ClearPattern") },
  })
end

local function setupKeys(config)
  config.key_tables = {}
  config.leader = { key = "e", mods = h.ctrl_or_cmd }
  config.keys = {
    -- Pane actions
    mapLeader("s", action.SplitPane({ direction = "Down" })),
    mapLeader("v", action.SplitPane({ direction = "Right" })),
    mapLeader("x", action.CloseCurrentPane({ confirm = true })),

    -- Tab actions
    mapCmd(",", action.ActivateTabRelative(-1)),
    mapCmd(".", action.ActivateTabRelative(1)),
    mapLeaderCmd(",", action.MoveTabRelative(-1)),
    mapLeaderCmd(".", action.MoveTabRelative(1)),
    mapLeader("c", action.SpawnTab("DefaultDomain")),
    mapLeader("m", action.ActivateCopyMode),
    mapLeader("1", action.ActivateTab(0)),
    mapLeader("2", action.ActivateTab(1)),
    mapLeader("3", action.ActivateTab(2)),
    mapLeader("4", action.ActivateTab(3)),
    mapLeader("5", action.ActivateTab(4)),
    mapLeaderCmd("e", action.ActivateLastTab),

    -- Misc
    mapLeader("l", action.ShowDebugOverlay),
    mapLeader("r", action.ShowLauncher),
    {
      key = "?",
      mods = "LEADER",
      action = wezterm.action_callback(function(win, pane)
        print("==============================")
        print("Variables:")
        print(pane:get_user_vars())
        win:perform_action(action.ShowDebugOverlay, pane)
      end),
    },

    mapLeaderCmd(
      "d",
      action.Multiple({
        action.ActivateCopyMode,
        action.ClearSelection,
        action.CopyMode("ClearSelectionMode"),
      })
    ),
    mapLeader("d", action.Multiple({ action.ActivateCopyMode, action.CopyMode("ClearPattern") })),
    mapLeaderCmd("u", action.Multiple({ action.ScrollByPage(-0.5), action.ActivateCopyMode })),
    mapLeader("q", action.QuickSelect),
    mapCmd("/", action.Search("CurrentSelectionOrEmptyString")), -- { CaseInSensitiveString = "" })),
    mapLeader("/", action.Search({ CaseInSensitiveString = "" })),
    mapLeader("p", action.ActivateCommandPalette),
    mapLeader("r", action.ReloadConfiguration),
  }

  h.extend_array(config.keys, require("scrollback"))

  if h.is_macos() then mapCmdToCtrl(config) end

  setupCopyMode(config)
  setupSearchMode(config)
end

return setupKeys
