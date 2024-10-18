{-# LANGUAGE OverloadedStrings #-}

-- IMPORTS

-- import qualified DBus as D
-- import qualified DBus.Client as D

-- setup color variables
import Colors.Stylix
import Control.Monad as C
-- import qualified Data.Map.Strict as M

import Data.Bool (Bool)
import Data.List
import qualified Data.Map as M
import Data.Maybe (fromJust)
import Data.Monoid
import Graphics.X11 (xK_grave)
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import System.IO
import XMonad
import XMonad (className, doFloat, title)
import XMonad.Actions.Navigation2D
import XMonad.Actions.SpawnOn
import XMonad.Actions.TiledWindowDragging
import XMonad.Actions.UpdatePointer (updatePointer)
import XMonad.Actions.Warp
import XMonad.Actions.WindowNavigation
import XMonad.Actions.WithAll
import XMonad.Config.Xfce
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh)
import qualified XMonad.Hooks.EwmhDesktops as EWMHD
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.RefocusLast
import XMonad.Hooks.ServerMode
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.Decoration (Decoration, DefaultShrinker, ModifiedLayout)
import qualified XMonad.Layout.Decoration as XMonad.Layout.LayoutModifier
import XMonad.Layout.DraggingVisualizer
import XMonad.Layout.Dwindle
import XMonad.Layout.DwmStyle (Theme (decoHeight))
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.LayoutHints
import XMonad.Layout.LimitWindows
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.NoBorders (noBorders, smartBorders, withBorder)
import XMonad.Layout.Renamed (Rename (Replace), renamed)
import qualified XMonad.Layout.Simplest as Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.Spacing (Spacing (smartBorder), spacingRaw)
import XMonad.Layout.SubLayouts (subLayout)
import XMonad.Layout.Tabbed
import XMonad.Layout.Tabbed (addTabs)
import XMonad.Layout.ThreeColumns (ThreeCol (..))
import XMonad.Layout.WindowNavigation (windowNavigation)
import XMonad.ManageHook
import qualified XMonad.StackSet as W
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

-- NOTE:
-- Chromium won't respect Xmonad's border width, until this is done:
-- https://wiki.archlinux.org/index.php/xmonad#Chrome/Chromium_not_displaying_defined_window_border_color

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor, myFocusedBorderColor :: String
myNormalBorderColor = colorBg
myFocusedBorderColor = colorFocus

-- Default apps
myTerminal, myBrowser :: String
myTerminal = "$TERM"
myBrowser = "$BROWSER"

myEditor = "$EDITOR"

mySpawnEditor = "$SPAWNEDITOR"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth :: Dimension
myBorderWidth = 3

-- Modmask
myModMask :: KeyMask
myModMask = mod4Mask

myWorkspaces :: [String]
myWorkspaces =
  [ "<fn=1>\xeb01 ²</fn>", -- globe icon for browsing
    "<fn=1>\xf15c¹</fn>", -- document icon for writing
    "<fn=1>\xf121³</fn>", -- dev icon for programming
    "<fn=1>\xf1fc⁵</fn>", -- paint icon for art
    "<fn=1>\xf0bdc ⁶</fn>", -- video icon for recording/editing
    "<fn=1>\xf0d6⁷</fn>", -- money icon for finances
    "<fn=1>\xf19d⁸</fn>", -- cap icon for teaching
    "<fn=1>\xf11b⁹</fn>", -- gamepad icon for gaming
    "<fn=1>\xf0cb9 ⁴</fn>" -- music file icon for composition
  ]

myWorkspaceIndices = M.fromList $ zip myWorkspaces [1 ..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+" ++ show i ++ ">" ++ ws ++ "</action>"
  where
    i = fromJust $ M.lookup ws myWorkspaceIndices

-- Scratchpads
myScratchPads :: [NamedScratchpad]
myScratchPads =
  [ mkScratchpad "terminal" (myTerminal ++ " --title scratchpad") (title =? "scratchpad") (0.9, 0.9, 0.95, 0.95),
    mkScratchpad "ranger" "kitty --title ranger-scratchpad -e ranger" (title =? "ranger-scratchpad") (0.9, 0.9, 0.95, 0.95),
    mkScratchpad "thunar" "thunar" (className =? "Thunar") (0.9, 0.9, 0.95, 0.95),
    mkScratchpad "btm" (myTerminal ++ " -o font.size=12 --title btm-scratchpad -e btm") (title =? "btm-scratchpad") (0.5, 0.4, 0.75, 0.70),
    mkScratchpad "pavucontrol" "pavucontrol" (className =? "Pavucontrol") (0.5, 0.3, 0.9, 0.65)
  ]
  where
    mkScratchpad :: String -> String -> Query Bool -> (Rational, Rational, Rational, Rational) -> NamedScratchpad
    mkScratchpad name spawnCmd findCmd (h, w, t, l) = NS name spawnCmd findCmd (manageFloat h w t l)

    manageFloat :: Rational -> Rational -> Rational -> Rational -> ManageHook
    manageFloat h w t l = customFloating $ W.RationalRect (l - w) (t - h) w h

myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
    [ -- insert keybinds with array values of ((keybind, action))

      -- launch a terminal
      ((modm, xK_Return), spawn $ XMonad.terminal conf),
      -- launch browser
      ((modm, xK_grave), spawn myBrowser),
      -- take screenshots
      ((0, xK_Print), spawn "flameshot gui"), -- snip screenshot and save
      ((controlMask, xK_Print), spawn "flameshot gui --clipboard"), -- snip screenshot to clipboard
      ((shiftMask, xK_Print), spawn "flameshot screen"), -- screen capture current monitor and save
      ((controlMask .|. shiftMask, xK_Print), spawn "flameshot screen -c"), -- screen capture current monitor to clipboard

      -- launch game manager in gaming workspace
      ((modm, xK_g), spawn "xdotool key Super+9 && gamehub"),
      -- control brightness from kbd
      ((0, xF86XK_MonBrightnessUp), spawn "brightnessctl set +15"),
      ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 15-"),
      -- control kbd brightness from kbd
      ((0, xF86XK_KbdBrightnessUp), spawn "brightnessctl --device='asus::kbd_backlight' set +1 & xset r rate 350 100"),
      ((0, xF86XK_KbdBrightnessDown), spawn "brightnessctl --device='asus::kbd_backlight' set 1- & xset r rate 350 100"),
      ((shiftMask, xF86XK_MonBrightnessUp), spawn "brightnessctl --device='asus::kbd_backlight' set +1 & xset r rate 350 100"),
      ((shiftMask, xF86XK_MonBrightnessDown), spawn "brightnessctl --device='asus::kbd_backlight' set 1- & xset r rate 350 100"),
      -- control volume from kbd
      ((0, xF86XK_AudioLowerVolume), spawn "pamixer -d 10"),
      ((0, xF86XK_AudioRaiseVolume), spawn "pamixer -i 10"),
      ((0, xF86XK_AudioMute), spawn "pamixer -t"),
      -- control music from kbd
      -- ((0, xF86XK_AudioPlay), spawn "cmus-remote -u"),
      -- ((0, xF86XK_AudioStop), spawn "cmus-remote -s"),
      -- ((0, xF86XK_AudioNext), spawn "cmus-remote -n && ~/.local/bin/cmus-current-song-notify.sh"),
      -- ((0, xF86XK_AudioPrev), spawn "cmus-remote -r && ~/.local/bin/cmus-current-song-notify.sh"),

      -- launch rofi
      -- ((modm, xK_semicolon), spawn "rofi -show drun -show-icons"),
      ((modm, xK_semicolon), spawn "xfce4-appfinder"),
      -- ((modm, xK_p), spawn "keepmenu"),
      ((modm, xK_o), spawn "obsidian"),
      ((modm, xK_i), spawn "networkmanager_dmenu"),
      -- close focused window
      ((modm, xK_q), kill),
      -- close all windows on current workspace
      ((modm .|. shiftMask, xK_c), killAll),
      -- exit xmonad
      ((modm .|. shiftMask, xK_q), spawn "killall xmonad-x86_64-linux"),
      -- Lock with dm-tool
      ((modm, xK_Escape), spawn "dm-tool switch-to-greeter"),
      -- Lock with dm-tool and suspend
      ((modm .|. shiftMask, xK_s), spawn "dm-tool switch-to-greeter & systemctl suspend"),
      ((modm .|. shiftMask, xK_Escape), spawn "dm-tool switch-to-greeter & systemctl suspend"),
      -- Rotate through the available layout algorithms
      ((modm, xK_space), sendMessage NextLayout),
      --  Reset the layouts on the current workspace to default
      ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
      -- Resize viewed windows to the correct size
      ((modm, xK_s), C.sequence_ [spawn "killall xmobar; autorandr -c; xmonad --restart;", refresh]),
      -- Move focus to window below
      ((modm, xK_j), C.sequence_ [windowGo D True, switchLayer, warpToWindow 0.5 0.5]),
      -- Move focus to window above
      ((modm, xK_k), C.sequence_ [windowGo U True, switchLayer, warpToWindow 0.5 0.5]),
      -- Move focus to window left
      ((modm, xK_h), C.sequence_ [windowGo L True, switchLayer, warpToWindow 0.5 0.5]),
      -- Move focus to window right
      ((modm, xK_l), C.sequence_ [windowGo R True, switchLayer, warpToWindow 0.5 0.5]),
      -- Move focus to screen below
      ((modm, xK_Down), C.sequence_ [screenGo D True, warpToCurrentScreen 0.5 0.5]),
      -- Move focus to screen up
      ((modm, xK_Up), C.sequence_ [screenGo U True, warpToCurrentScreen 0.5 0.5]),
      -- Move focus to screen left
      ((modm, xK_Left), C.sequence_ [screenGo L True, warpToCurrentScreen 0.5 0.5]),
      -- Move focus to screen right
      ((modm, xK_Right), C.sequence_ [screenGo R True, warpToCurrentScreen 0.5 0.5]),
      -- Swap with window below
      ((modm .|. shiftMask, xK_j), C.sequence_ [windowSwap D True, windowGo U True, switchLayer]),
      -- Swap with window above
      ((modm .|. shiftMask, xK_k), C.sequence_ [windowSwap U True, windowGo D True, switchLayer]),
      -- Swap with window left
      ((modm .|. shiftMask, xK_h), C.sequence_ [windowSwap L True, windowGo R True, switchLayer]),
      -- Swap with window right
      ((modm .|. shiftMask, xK_l), C.sequence_ [windowSwap R True, windowGo L True, switchLayer]),
      -- Shrink the master area
      ((modm .|. controlMask, xK_h), sendMessage Shrink),
      -- Expand the master area
      ((modm .|. controlMask, xK_l), sendMessage Expand),
      -- Swap the focused window and the master window
      ((modm, xK_m), windows W.swapMaster),
      -- Toggle tiling/floating status of window
      ((modm, xK_t), withFocused toggleFloat),
      -- Increment the number of windows in the master area
      ((modm, xK_comma), sendMessage (IncMasterN 1)),
      -- Deincrement the number of windows in the master area
      ((modm, xK_period), sendMessage (IncMasterN (-1))),
      -- scratchpad keybindings
      ((modm, xK_f), namedScratchpadAction myScratchPads "ranger"),
      ((modm, xK_z), namedScratchpadAction myScratchPads "terminal"),
      ((modm, xK_b), namedScratchpadAction myScratchPads "btm"),
      ((modm, xK_y), namedScratchpadAction myScratchPads "pavucontrol")
    ]
      ++
      -- mod-[1..9], Switch to workspace N
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      -- mod-shift-[1..9], Move client to workspace N

      [ ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]
  where
    -- toggle float/tiling status of current window
    toggleFloat :: Window -> X ()
    toggleFloat w = windows $ \s ->
      if M.member w (W.floating s)
        then W.sink w s
        else W.float w (W.RationalRect (1 / 8) (1 / 8) (3 / 4) (3 / 4)) s

    -- warp cursor to (x, y) coordinate of current screen
    warpToCurrentScreen :: Rational -> Rational -> X ()
    warpToCurrentScreen x y = do
      sid <- withWindowSet (return . W.screen . W.current)
      warpToScreen sid x y

    -- TODO goto and warp (coords x, y) to window in DIRECTION, or goto and warp (coords x, y) to screen in DIRECTION if no window is available
    windowOrScreenGoAndWarp direction x y =
      windowGo direction True

-- Mouse bindings: default actions bound to mouse events
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList mouseControls
  where
    mouseControls = [((modm, button1), drag), ((modm, button3), resize)]
    drag w = focus w >> mouseMoveWindow w >> windows W.shiftMaster
    resize w = focus w >> mouseResizeWindow w >> windows W.shiftMaster

------------------------------
-- Hooks
------------------------------

-- Window rules:
myManageHook =
  composeAll
    [ className =? "confirm" --> doFloat,
      className =? "file_progress" --> doFloat,
      className =? "dialog" --> doFloat,
      className =? "download" --> doFloat,
      className =? "error" --> doFloat,
      title =? "Application Finder" --> doFloat,
      title =? "Whisker Menu" --> doFloat,
      className =? "wrapper-2.0" --> doFloat,
      className =? "Wrapper-2.0" --> doFloat,
      className =? "xfce4-popup-whiskermenu" --> doFloat,
      className =? "Xfce4-popup-whiskermenu" --> doFloat,
      title =? "Myuzi" --> customFloating (W.RationalRect 0.05 0.05 0.9 0.9),
      title =? "octave-scratchpad" --> customFloating (W.RationalRect 0.1 0.1 0.8 0.8),
      title =? "scratchpad" --> customFloating (W.RationalRect 0.1 0.1 0.8 0.8),
      className =? "gtkcord4" --> customFloating (W.RationalRect 0.1 0.1 0.8 0.8),
      title =? "ranger-scratchpad" --> customFloating (W.RationalRect 0.05 0.05 0.9 0.9),
      title =? "btm-scratchpad" --> customFloating (W.RationalRect 0.1 0.1 0.8 0.8),
      className =? "Geary" --> customFloating (W.RationalRect 0.05 0.05 0.9 0.9),
      title =? "scratch_cfw" --> customFloating (W.RationalRect 0.58 0.04 0.42 0.7),
      className =? "Pavucontrol" --> customFloating (W.RationalRect 0.05 0.04 0.5 0.35),
      className =? "Syncthing GTK" --> customFloating (W.RationalRect 0.53 0.50 0.46 0.45),
      className =? "Proton Mail Bridge" --> customFloating (W.RationalRect 0.59 0.66 0.40 0.30),
      className =? "Zenity" --> customFloating (W.RationalRect 0.45 0.4 0.1 0.2),
      resource =? "desktop_window" --> doIgnore,
      -- this gimp snippet is from Kathryn Anderson (https://xmonad.haskell.narkive.com/bV34Aiw3/layout-for-gimp-how-to)
      (className =? "Gimp" <&&> fmap ("color-selector" `isSuffixOf`) role) --> doFloat,
      (className =? "Gimp" <&&> fmap ("layer-new" `isSuffixOf`) role) --> doFloat,
      (className =? "Gimp" <&&> fmap ("-dialog" `isSuffixOf`) role) --> doFloat,
      (className =? "Gimp" <&&> fmap ("-tool" `isSuffixOf`) role) --> doFloat,
      (className =? "firefox" <&&> resource =? "Dialog") --> doFloat, -- Float Firefox Dialog
      title =? "Mozilla Firefox" --> doShift (myWorkspaces !! 1),
      title =? "Firefox" --> doShift (myWorkspaces !! 1),
      title =? "firefox" --> doShift (myWorkspaces !! 1),
      className =? "Brave-browser" --> doShift (myWorkspaces !! 1),
      -- end snippet
      resource =? "kdesktop" --> doIgnore,
      manageDocks
    ]
  where
    role = stringProperty "WM_WINDOW_ROLE"

myStartupHook = do
  spawnOnce ("~/.config/xmonad/startup.sh '" ++ colorBg ++ "' '" ++ colorFg ++ "' '" ++ colorFocus ++ "' '" ++ colorSecondary ++ "'")

-- Apply fullscreen manage and event hooks
myFullscreenManageHook = fullscreenManageHook

myFullscreenEventHook = fullscreenEventHook

-- Server mode event hook
myEventHook = serverModeEventHook

---------------------------------------
--- Layouts
---------------------------------------

myTabTheme =
  def
    { fontName = myFont,
      activeColor = colorFocus, -- Use the focused color (red)
      inactiveColor = colorSecondary, -- Use the secondary color (cyan)
      activeBorderColor = colorFocus, -- Active border matches focus color
      inactiveBorderColor = colorBg, -- Inactive border matches background
      activeTextColor = colorBg, -- Active text matches background (contrast)
      inactiveTextColor = colorFg -- Inactive text matches foreground (contrast)
    }

-- Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.

mySpacing :: Bool -> Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing doBorder i = spacingRaw applyBordersWhen2WindowsOrMore screenBorders True windowBorders enableWindowBorders
  where
    applyBordersWhen2WindowsOrMore = doBorder
    screenBorders = (Border 0 i i i)
    windowBorders = (Border i i i i)
    enableWindowBorders = True
    enableScreenBorders = False

mySpacing1 = mySpacing True

mySpacing2 = mySpacing True

myThreeCol =
  renamed [Replace "threeCol"] $
    limitWindows 7 $
      smartBorders $
        windowNavigation $
          addTabs shrinkText myTabTheme $
            subLayout [] (smartBorders Simplest.Simplest) $
              ThreeCol 1 (3 / 100) (1 / 2)

myTabbed :: ModifiedLayout (Decoration TabbedDecoration DefaultShrinker) Simplest.Simplest Window
myTabbed =
  -- FIXME: This doesn't work reliably.
  tabbed shrinkText $ def {decoHeight = 11, activeColor = colorFocus, fontName = "xft:Consolas:size=14"} $ noBorders

pointerFollowsFocus =
  let centerOfWindow = ((0.5, 0.5), (0, 0))
   in uncurry updatePointer centerOfWindow

borderSpacingBetweenWindows = withBorder 5 . mySpacing1 10

main :: IO ()
main = xmonad $ docks $ ewmh cfg
  where
    cfg =
      def
        { modMask = myModMask,
          terminal = myTerminal,
          workspaces = myWorkspaces,
          keys = myKeys,
          focusFollowsMouse = myFocusFollowsMouse,
          clickJustFocuses = myClickJustFocuses,
          borderWidth = myBorderWidth,
          normalBorderColor = myNormalBorderColor,
          focusedBorderColor = myFocusedBorderColor,
          persistent = true,
          startupHook = myStartupHook,
          manageHook = myManageHook <+> manageDocks <+> myFullscreenManageHook <+> namedScratchpadManageHook myScratchPads,
          handleEventHook = myEventHook <+> myFullscreenEventHook <+> fadeWindowsEventHook,
          layoutHook =
            borderSpacingBetweenWindows $
              avoidStruts $
                myThreeCol ||| myTabbed ||| layoutHook def,
          logHook = (refocusLastLogHook >> nsHideOnFocusLoss myScratchPads)
        }
