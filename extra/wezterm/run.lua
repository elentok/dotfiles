local wezterm = require("wezterm")

local run_script = wezterm.home_dir .. "/.dotfiles/core/scripts/dotf-wezterm-run"

---@args string[]
local function in_new_window(window, pane, args)
  local cmd = { run_script }
  require("helpers").extend_array(cmd, args)

  window:perform_action(
    wezterm.action({
      SpawnCommandInNewWindow = {
        args = cmd,
      },
    }),
    pane
  )
end

return {
  in_new_window = in_new_window,
}
