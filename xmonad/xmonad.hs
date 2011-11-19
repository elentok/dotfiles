import XMonad
import XMonad.Layout.Spacing
import XMonad.Config.Kde
import XMonad.Util.EZConfig

-- required for xmobar
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import System.IO

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/david/.xmonad/xmobarrc.hs"
    xmonad $ kde4Config {
        -- use Win key as the "mod" key
        modMask = mod4Mask

        ,workspaces = ["1:main", "2:dev", "3:gimp", "4:media", "5:help"]

        -- colors
        ,borderWidth = 4 
        {-normalBorderColor = "#dddddd",-}
        ,focusedBorderColor = "#ff0000"
        ,layoutHook = avoidStruts (spacing 5 (layoutHook kde4Config))

        -- xmobar
        ,manageHook = manageDocks <+> manageHook kde4Config
        ,logHook = dynamicLogWithPP xmobarPP
          { ppOutput = hPutStrLn xmproc
          , ppTitle = xmobarColor "blue" "" . shorten 50
          , ppLayout = const "" -- to disable layout info on xmobar
          }

        -- keys
        }`additionalKeys`
        [(( mod4Mask, xK_p), spawn "dmenu_run")
        --,(( mod4Mask, xK_), spawn "krusader")
        ]

myManageHook = composeAll
    [ className =? "Gimp" --> doFloat ]


