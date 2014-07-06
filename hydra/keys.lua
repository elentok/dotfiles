-- define the hyper key
local hyper = {"cmd", "ctrl"}

hotkey.bind(hyper, "R", repl.open)
hotkey.bind(hyper, 'D', opendictionary)

--hotkey.bind(hyper, "L", movewindow_righthalf)
--hotkey.bind(hyper, "H", movewindow_lefthalf)

hotkey.bind(hyper, "F1", hydra.reload)


--hotkey.bind(hyper, 'h', function() window.focusedwindow():focuswindow_west() end)
--hotkey.bind(hyper, 'l', function() window.focusedwindow():focuswindow_east() end)
--hotkey.bind(hyper, 'k', function() window.focusedwindow():focuswindow_north() end)
--hotkey.bind(hyper, 'j', function() window.focusedwindow():focuswindow_south() end)
--

hotkey.bind(hyper, 'm', ext.grid.maximize_window)


hotkey.bind(hyper, '=', function() ext.grid.adjustwidth( 1) end)
hotkey.bind(hyper, '-', function() ext.grid.adjustwidth(-1) end)

hotkey.bind(hyper, 'u', ext.grid.resizewindow_taller)
hotkey.bind(hyper, 'o', ext.grid.resizewindow_wider)
hotkey.bind(hyper, 'i', ext.grid.resizewindow_thinner)

hotkey.bind(hyper, 'j', ext.grid.pushwindow_down)
hotkey.bind(hyper, 'k', ext.grid.pushwindow_up)
hotkey.bind(hyper, 'h', ext.grid.pushwindow_left)
hotkey.bind(hyper, 'l', ext.grid.pushwindow_right)
