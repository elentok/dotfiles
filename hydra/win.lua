-- based on https://github.com/szymonkaliski/Dotfiles/blob/master/Dotfiles/hydra.lua

-- window extension
ext.win = {}

-- window margin
local margin = 0

-- ugly fix for problem with window height when it's as big as screen
function ext.win.fix(win)
  local frame = win:frame()
  local screen = win:screen():frame_without_dock_or_menu()

  if (frame.h > (screen.h - margin * (2 - 1 / 4))) then
    frame.h = screen.h - margin * 10
    win:setframe(frame)
  end
end

-- pushes window in direction and nudges to edge, fixes terminal positioning
function ext.win.push(win, direction)
  local screen = win:screen():frame_without_dock_or_menu()
  local frame = win:frame()

  ext.win.fix(win)

  frame = ext.frame.push(screen, direction)
  frame = ext.frame.nudge(frame, screen, direction)

  win:setframe(frame)
end

-- nudges window in direction
function ext.win.nudge(win, direction)
  local screen = win:screen():frame_without_dock_or_menu()
  local frame = win:frame()

  frame = ext.frame.nudge(frame, screen, direction)

  win:setframe(frame)
end

-- centers window
function ext.win.center(win)
  local screen = win:screen():frame_without_dock_or_menu()
  local frame = win:frame()

  frame = ext.frame.center(screen, frame)

  win:setframe(frame)
end

-- fullscreen window with margin
function ext.win.full(win)
  local screen = win:screen():frame_without_dock_or_menu()

  frame = {
    x = margin + screen.x,
    y = margin + screen.y,
    w = screen.w - margin * 2,
    h = screen.h - margin * (2 - 1 / 4)
  }

  ext.win.fix(win)
  win:setframe(frame)
end

-- set window size and center
function ext.win.size(win, size)
  local screen = win:screen():frame_without_dock_or_menu()
  local frame = win:frame()

  frame.w = size.w
  frame.h = size.h

  frame = ext.frame.fit(screen, frame)
  frame = ext.frame.center(screen, frame)

  win:setframe(frame)
end

-- set window size and center
function ext.win.size_percentage(win, percentages)
  local screen = win:screen():frame_without_dock_or_menu()
  local frame = win:frame()

  frame = ext.frame.fit_percentage(screen, percentages)
  frame = ext.frame.center(screen, frame)

  win:setframe(frame)
end

-- save and restore window positions
local positions = {}

function ext.win.pos(win, option)
  local id = win:application():bundleid()
  local frame = win:frame()

  if option == "save" then
    notify.show("Hydra", "position for " .. id .. " saved", "", "")
    positions[id] = frame
  end

  if option == "load" and positions[id] then
    notify.show("Hydra", "position for " .. id .. " restored", "", "")
    win:setframe(positions[id])
  end
end

-- cycle application windows
-- simplified and stolen from: https://github.com/nifoc/dotfiles/blob/master/hydra/cycle.lua
function ext.win.cycle(win)
  local windows = win:application():visiblewindows()
  windows = fnutils.filter(windows, function(win) return win:isstandard() end)

  if #windows >= 2 then
    table.sort(windows, function(a, b) return a:id() < b:id() end)
    local activewindowindex = fnutils.indexof(windows, win)

    if activewindowindex then
      activewindowindex = activewindowindex + 1
      if activewindowindex > #windows then activewindowindex = 1 end

      windows[activewindowindex]:focus()
    end
  end
end

-- apply function to a window with optional params
function dowin(fn, param)
  return function()
    fn(window.focusedwindow(), param)
  end
end
