local function run(cmd) hs.task.new("/opt/homebrew/bin/fish", nil, { "-lc", cmd }):start() end

local function openApp(path) run('open "' .. path .. '"') end

hs.hotkey.bind(
  { "cmd" },
  "space",
  function() run("kitten quick-access-terminal --instance-group quick") end
)

hs.hotkey.bind({ "cmd" }, "2", function() openApp("/Applications/Google Chrome.app") end)

hs.hotkey.bind({ "cmd" }, "3", function() openApp("/Applications/kitty.app") end)

hs.hotkey.bind({ "cmd" }, "4", function() openApp("/Applications/Slack.app") end)

hs.hotkey.bind({ "cmd" }, "5", function() openApp("/Applications/Prisma Access Browser.app") end)

hs.hotkey.bind({ "cmd" }, "8", function() openApp("/Applications/Prisma Access Browser.app") end)

hs.hotkey.bind({ "cmd" }, "9", function() openApp("/Applications/Spotify.app") end)

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
