-- based on https://github.com/szymonkaliski/Dotfiles/blob/master/Dotfiles/hydra.lua
-- extension for frame
ext.frame = {}

-- window margin
local margin = 0

-- delta to move/resize by
local delta = 50

-- returns frame pushed to screen edge
function ext.frame.push(screen, direction)
  local frames = {
    [ "up" ] = function()
      return {
        x = margin + screen.x,
        y = margin + screen.y,
        w = screen.w - margin * 2,
        h = screen.h / 2 - margin
      }
    end,

    [ "down" ] = function()
      return {
        x = margin + screen.x,
        y = margin * 3 / 4 + screen.h / 2 + screen.y,
        w = screen.w - margin * 2,
        h = screen.h / 2 - margin * (2 - 1 / 4)
      }
    end,

    [ "left" ] = function()
      return {
        x = margin + screen.x,
        y = margin + screen.y,
        w = screen.w / 2 - margin * (2 - 1 / 4),
        h = screen.h - margin * (2 - 1 / 4)
      }
    end,

    [ "right" ] = function()
      return {
        x = margin / 2 + screen.w / 2 + screen.x,
        y = margin + screen.y,
        w = screen.w / 2 - margin * (2 - 1 / 4),
        h = screen.h - margin * (2 - 1 / 4)
      }
    end
  }

  return frames[direction]()
end

-- returns frame moved by margin
function ext.frame.nudge(frame, screen, direction, offset)

  offset = offset == null and delta or offset

  local modifyframe = {
    [ "up" ] = function(frame)
      frame.y = math.max(screen.y + margin, frame.y - offset)
      return frame
    end,

    [ "down" ] = function(frame)
      frame.y = math.min(screen.y + screen.h - frame.h - margin * 3 / 4, frame.y + offset)
      return frame
    end,

    [ "left" ] = function(frame)
      frame.x = math.max(screen.x + margin, frame.x - offset)
      return frame
    end,

    [ "right" ] = function(frame)
      frame.x = math.min(screen.x + screen.w - frame.w - margin, frame.x + offset)
      return frame
    end
  }

  return modifyframe[direction](frame)
end


-- returns frame fited inside screen
function ext.frame.fit(screen, frame)
  frame.w = math.min(frame.w, screen.w - margin * 2)
  frame.h = math.min(frame.h, screen.h - margin * (2 - 1 / 4))

  return frame
end

-- returns frame fited inside screen
function ext.frame.fit_percentage(screen, percentages)
  frame.w = screen.w * percentages.w / 100
  frame.h = screen.h * percentages.h / 100

  return frame
end

-- returns frame centered inside screen
function ext.frame.center(screen, frame)
  frame.x = screen.w / 2 - frame.w / 2 + screen.x
  frame.y = screen.h / 2 - frame.h / 2 + screen.y

  return frame
end
