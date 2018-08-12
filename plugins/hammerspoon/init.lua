-- HANDLE SCROLLING
local oldmousepos = {}
-- positive multiplier (== natural scrolling) makes mouse work like traditional scrollwheel
local scrollmult = 4 

-- The were all events logged, when using `{"all"}`
mousetap = hs.eventtap.new({0,3,5,14,25,26,27}, function(e)
  oldmousepos = hs.mouse.getAbsolutePosition()
  local mods = hs.eventtap.checkKeyboardModifiers()
  local pressedMouseButton = e:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber'])

  -- If OSX button 4 is pressed, allow scrolling
  local shouldScroll = 3 == pressedMouseButton
  if shouldScroll then
    local dx = e:getProperty(hs.eventtap.event.properties['mouseEventDeltaX'])
    local dy = e:getProperty(hs.eventtap.event.properties['mouseEventDeltaY'])
    local scroll = hs.eventtap.event.newScrollEvent({dx * scrollmult, dy * scrollmult},{},'pixel')
    scroll:post()

    -- put the mouse back
    hs.mouse.setAbsolutePosition(oldmousepos)

    return true, {scroll}
  else
    return false, {}
  end
  print ("Mouse moved!")
  print (dx)
  print (dy)
end)
mousetap:start()
