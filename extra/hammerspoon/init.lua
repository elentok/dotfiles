local function run(cmd) hs.task.new("/opt/homebrew/bin/fish", nil, { "-lc", cmd }):start() end

local function openApp(path) run('open "' .. path .. '"') end

local appDirs = { "/Applications", os.getenv("HOME") .. "/Applications" }

-- Returns the full path of "<name>.app" in /Applications or ~/Applications, or nil.
local function findApp(name)
  for _, dir in ipairs(appDirs) do
    local path = dir .. "/" .. name .. ".app"
    if hs.fs.attributes(path) then return path end
  end
  return nil
end

-- Binds the key only if the app is installed.
local function bindApp(mods, key, name)
  local path = findApp(name)
  if path then hs.hotkey.bind(mods, key, function() openApp(path) end) end
end

local function toggleGhosttyQuickTerminal()
  hs.osascript.applescript(
    'tell application "Ghostty" to perform action "toggle_quick_terminal" on focused terminal of selected tab of front window'
  )
end

hs.hotkey.bind(
  { "cmd" },
  "space",
  function() run("kitten quick-access-terminal --instance-group quick") end
  -- function()
  --   if hs.application.get("Ghostty") then
  --     toggleGhosttyQuickTerminal()
  --   else
  --     openApp("/Applications/Ghostty.app")
  --     hs.timer.doAfter(1, toggleGhosttyQuickTerminal)
  --   end
  -- end
)

bindApp({ "cmd" }, "2", "Google Chrome")

bindApp({ "cmd" }, "3", "kitty")

bindApp({ "cmd" }, "4", "Slack")

bindApp({ "cmd" }, "5", "Prisma Access Browser")

bindApp({ "cmd" }, "8", "Prisma Access Browser")

bindApp({ "cmd" }, "9", "Spotify")

hs.hotkey.bind({ "cmd", "ctrl", "alt" }, "r", function()
  hs.reload()
  hs.notify
    .new({
      title = "Hammerspoon",
      informativeText = "reloaded config",
    })
    :send()
end)

hs.hotkey.bind({ "cmd", "alt" }, "p", function() run("spot") end)

hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "i", function() run("spot") end)
