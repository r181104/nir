import Control.Monad.IO.Class
import qualified Data.Map as M
import Data.Monoid
import Graphics.X11.Xlib
import System.Exit
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.Navigation2D
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.XUtils

myTerminal = "wezterm"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth = 3

myModMask = mod4Mask

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myNormalBorderColor = "#dddddd"

myFocusedBorderColor = "#ff0000"

toggleFull :: X ()
toggleFull =
  withFocused $ \w -> do
    floats <- gets (W.floating . windowset)
    if w `M.member` floats
      then do
            -- Sink the window
        windows (W.sink w)
            -- Restore border
        withDisplay $ \d -> liftIO $ setWindowBorderWidth d w myBorderWidth
      else do
            -- Float full screen
        windows $ W.float w (W.RationalRect 0 0 1 1)
            -- Remove border
        withDisplay $ \d -> liftIO $ setWindowBorderWidth d w 0

-- Key bindings
myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList
    $ [ ((modm, xK_Return), spawn $ XMonad.terminal conf)
      , ((mod1Mask, xK_Return), spawn "alacritty")
      , ( (modm, xK_space)
        , spawn
            "bemenu-run --fn 'MesloLGS Nerd Font 20' -l 8 -i --nb '#1d1f21cc' --nf '#c5c8c6' --sb '#81a2becc' --sf '#sffffff'")
      , ((modm .|. shiftMask, xK_p), spawn "gmrun")
      , ((modm, xK_b), spawn "firefox --no-remote")
      , ((modm, xK_q), kill)
      , ((modm .|. shiftMask, xK_l), sendMessage NextLayout)
      , ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
      , ((modm, xK_n), refresh)
      , ((modm, xK_Tab), windows W.focusDown)
      , ((modm, xK_m), windows W.focusMaster)
      , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)
      , ((modm .|. shiftMask, xK_j), windows W.swapDown)
      , ((modm .|. shiftMask, xK_k), windows W.swapUp)
      , ((modm, xK_h), sendMessage Shrink)
      , ((modm, xK_l), sendMessage Expand)
      , ((modm, xK_t), withFocused $ windows . W.sink)
      , ((modm, xK_comma), sendMessage (IncMasterN 1))
      , ((modm, xK_period), sendMessage (IncMasterN (-1)))
      , ((modm .|. shiftMask, xK_q), io (exitWith ExitSuccess))
      , ( (modm .|. shiftMask, xK_r)
        , spawn
            "xmonad --recompile; xmonad --restart; dunstify 'XMONAD RELOADED'")
      , ( (modm .|. shiftMask, xK_slash)
        , spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
      -- Directional navigation with Alt
      , ((mod1Mask, xK_l), windowGo R True)
      , ((mod1Mask, xK_h), windowGo L True)
      , ((mod1Mask, xK_k), windowGo U True)
      , ((mod1Mask, xK_j), windowGo D True)
      -- Workspace cycling
      , ((modm, xK_j), prevWS)
      , ((modm, xK_k), nextWS)
      , ((modm, xK_f), toggleFull) -- toggle between full screen and tiling
      ]
        ++ [ ((m .|. modm, k), windows $ f i)
           | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
           , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
           ]

myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList
    [ ( (modm, button1)
      , (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    , ( (modm, button3)
      , (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))
    ]

myLayout = tiled ||| Mirror tiled ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1 / 2
    delta = 3 / 100

myManageHook =
  composeAll
    [ className =? "MPlayer" --> doFloat
    , className =? "Gimp" --> doFloat
    , resource =? "desktop_window" --> doIgnore
    , resource =? "kdesktop" --> doIgnore
    ]

myEventHook = mempty

myLogHook = return ()

myStartupHook = do
  spawnOnce "xset r rate 200 50"
  spawnOnce "xset -b"
  spawnOnce "xset s off -dpms"
  spawnOnce "autostart"

main = do
  xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc"
  xmonad $ docks defaults

defaults =
  def
    { terminal = myTerminal
    , focusFollowsMouse = myFocusFollowsMouse
    , clickJustFocuses = myClickJustFocuses
    , borderWidth = myBorderWidth
    , modMask = myModMask
    , workspaces = myWorkspaces
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , keys = myKeys
    , mouseBindings = myMouseBindings
    , layoutHook = myLayout
    , manageHook = myManageHook
    , handleEventHook = myEventHook
    , logHook = myLogHook
    , startupHook = myStartupHook
    }

help :: String
help = "..."
