local wezterm = require("wezterm")
local io = require("io")
local os = require("os")
local run = require("run")

---@return string|nil the temporary filename
local function write_scrollback(pane)
  -- Retrieve the current viewport's text.
  -- Pass an optional number of lines (eg: 2000) to retrieve
  -- that number of lines starting from the bottom of the viewport
  local scrollback = pane:get_lines_as_text(4000)

  -- Create a temporary file to pass to vim
  local filename = os.tmpname()
  local f = io.open(filename, "w+")
  if f == nil then return nil end
  f:write(scrollback)
  f:flush()
  f:close()

  return filename
end

---@parma filename string
local function wait_and_remove(filename)
  -- wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous
  -- wrt. running this script and are not awaitable, so we just pick
  -- a number.
  wezterm.sleep_ms(1000)
  os.remove(filename)
end

wezterm.on("open-url-from-scrollback", function(window, pane)
  local filename = write_scrollback(pane)
  if filename == nil then return end
  run.in_new_window(window, pane, { "dotf-wezterm-links", "open", filename })
  wait_and_remove(filename)
end)

wezterm.on("copy-url-from-scrollback", function(window, pane)
  local filename = write_scrollback(pane)
  if filename == nil then return end
  run.in_new_window(window, pane, { "dotf-wezterm-links", "copy", filename })
  wait_and_remove(filename)
end)

wezterm.on("trigger-nvim-with-scrollback", function(window, pane)
  local filename = write_scrollback(pane)
  if filename == nil then return end

  run.in_new_window(window, pane, { "dotf-nvim-pager", filename })

  wait_and_remove(filename)
end)

return {
  {
    key = "h",
    mods = "LEADER",
    action = wezterm.action({ EmitEvent = "trigger-nvim-with-scrollback" }),
  },
  {
    key = "o",
    mods = "LEADER",
    action = wezterm.action({ EmitEvent = "open-url-from-scrollback" }),
  },
  {
    key = "y",
    mods = "LEADER",
    action = wezterm.action({ EmitEvent = "copy-url-from-scrollback" }),
  },
}
