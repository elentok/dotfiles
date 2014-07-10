-- define the hyper key
local hyper = {"cmd", "ctrl"}
local hypershift = {"cmd", "ctrl", "shift"}

hotkey.bind(hyper, "R", repl.open)
hotkey.bind(hyper, 'D', opendictionary)

--hotkey.bind(hyper, "L", movewindow_righthalf)
--hotkey.bind(hyper, "H", movewindow_lefthalf)

hotkey.bind(hyper, "F1", hydra.reload)


hotkey.bind(hyper, 'h', function() window.focusedwindow():focuswindow_west() end)
hotkey.bind(hyper, 'l', function() window.focusedwindow():focuswindow_east() end)
hotkey.bind(hyper, 'k', function() window.focusedwindow():focuswindow_north() end)
hotkey.bind(hyper, 'j', function() window.focusedwindow():focuswindow_south() end)

hotkey.bind(hypershift, 'j', dowin(ext.win.push, "down"))
hotkey.bind(hypershift, 'k', dowin(ext.win.push, "up"))
hotkey.bind(hypershift, 'h', dowin(ext.win.push, "left"))
hotkey.bind(hypershift, 'l', dowin(ext.win.push, "right"))

hotkey.bind(hypershift, 'down', dowin(ext.win.nudge, "down"))
hotkey.bind(hypershift, 'up', dowin(ext.win.nudge, "up"))
hotkey.bind(hypershift, 'left', dowin(ext.win.nudge, "left"))
hotkey.bind(hypershift, 'right', dowin(ext.win.nudge, "right"))

hotkey.bind(hypershift, 'm', dowin(ext.win.full))
