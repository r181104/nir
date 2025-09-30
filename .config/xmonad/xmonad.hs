import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.HooksDocks
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig

main :: IO ()
main = xmonad $ ewmh $ docks myConfig

-- WARN: Main Configuration
myConfig =
  def
    { modMask = mod1Mask -- define modkey
    , layoutHook = myLayout -- custom layouts
    , manageHook = myManageHook -- manage specific windows
    , startupHook =
        myStartupHook -- autostart programs
          `additionalKeysP` myKeys -- add keys with ezconfig
-- define keybindings
myKeys :: [(Char, X ())]
myKeys = 
[ ("M-S-<Return", spawn "wezterm")
, ("M-S-b", spawn "firefox")
]

-- manage hook
myManageHook :: ManageHook
myManageHook = composeAll
[ className = ? "Gimp" --> doFloat --float gimp
, isDialog             --> doFloat --float dialog boxes
]
-- custom layouts, adding gaps spacing between windows
myLayout = spacing 8 $ tiled ||| Mirror tiled ||| full ||| threeCol
where
tiled    = Tail 1 (3/100) (1/2) -- tall layout
threeCol = ThreeColMid 1 (3/100) (1/2) -- three column layout

myStartupHook = do
spawn "picom"
spawn "nm-apple"
spawn "feh --bg-scale ~/Wallpapers/CuteCat.png"
spawn "sh -c 'for o in $(xrandr | grep \" connected\" | cut -d\" \" -f1); do xrandr --output $o --mode 1920x1080 --rate 60 2>/dev/null; done'"
}
