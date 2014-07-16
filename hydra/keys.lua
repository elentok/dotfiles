-- define the modifiers
local cmdctrl = {"cmd", "ctrl"}
local hyper = {"cmd", "ctrl", "alt"}

hotkey.bind(cmdctrl, "R", repl.open)
hotkey.bind(cmdctrl, 'D', opendictionary)

--hotkey.bind(cmdctrl, "L", movewindow_righthalf)
--hotkey.bind(cmdctrl, "H", movewindow_lefthalf)

hotkey.bind(cmdctrl, "F1", hydra.reload)


hotkey.bind(cmdctrl, 'h', function() window.focusedwindow():focuswindow_west() end)
hotkey.bind(cmdctrl, 'l', function() window.focusedwindow():focuswindow_east() end)
hotkey.bind(cmdctrl, 'k', function() window.focusedwindow():focuswindow_north() end)
hotkey.bind(cmdctrl, 'j', function() window.focusedwindow():focuswindow_south() end)

hotkey.bind(hyper, 'j', dowin(ext.win.push, "down"))
hotkey.bind(hyper, 'k', dowin(ext.win.push, "up"))
hotkey.bind(hyper, 'h', dowin(ext.win.push, "left"))
hotkey.bind(hyper, 'l', dowin(ext.win.push, "right"))

hotkey.bind(hyper, '0', dowin(ext.win.size_percentage, { w = 95, h = 95 }))
hotkey.bind(hyper, '9', dowin(ext.win.size_percentage, { w = 90, h = 90 }))
hotkey.bind(hyper, '8', dowin(ext.win.size_percentage, { w = 80, h = 80 }))
hotkey.bind(hyper, '7', dowin(ext.win.size_percentage, { w = 70, h = 70 }))

hotkey.bind(hyper, 'down', dowin(ext.win.nudge, "down"))
hotkey.bind(hyper, 'up', dowin(ext.win.nudge, "up"))
hotkey.bind(hyper, 'left', dowin(ext.win.nudge, "left"))
hotkey.bind(hyper, 'right', dowin(ext.win.nudge, "right"))

hotkey.bind(hyper, 'm', dowin(ext.win.full))
