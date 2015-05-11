-- OpenInTerminal.applescript
-- ForkLift
--  Created by ONO


tell application "iTerm"
	activate
  try
    set _term to current terminal
  on error
    set _term to (make new terminal)
  end try

  tell _term
    launch session "Default Session"
    tell current session
      write text "cd _forklift_path_placeholder_"
    end tell
  end tell
end tell
