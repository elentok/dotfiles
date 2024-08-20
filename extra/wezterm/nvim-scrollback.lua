local wezterm = require("wezterm")
local io = require("io")
local os = require("os")

wezterm.on("trigger-nvim-with-scrollback", function(window, pane)
  -- Retrieve the current viewport's text.
  -- Pass an optional number of lines (eg: 2000) to retrieve
  -- that number of lines starting from the bottom of the viewport
  local scrollback = pane:get_lines_as_text(4000)

  -- Create a temporary file to pass to vim
  local name = os.tmpname()
  local f = io.open(name, "w+")
  if f == nil then
    return
  end
  f:write(scrollback)
  f:flush()
  f:close()

  -- Open a new window running vim and tell it to open the file
  window:perform_action(
    wezterm.action({
      SpawnCommandInNewTab = {
        args = { os.getenv("HOME") .. "/.dotfiles/core/scripts/dotf-nvim-pager", name },
      },
    }),
    pane
  )

  -- wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous
  -- wrt. running this script and are not awaitable, so we just pick
  -- a number.
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

return {
  key = "h",
  mods = "LEADER",
  action = wezterm.action({ EmitEvent = "trigger-nvim-with-scrollback" }),
}
