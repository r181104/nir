#!/bin/sh

# === NVIDIA PRIME / hybrid graphics (if present) ===
if xrandr --listproviders 2>/dev/null | grep -q "NVIDIA"; then
  xrandr --setprovideroutputsource modesetting NVIDIA-0
fi

# === Keyboard & Mouse ===
xset r rate 200 50
xset -b
xset s off -dpms

# === Numlock & gestures ===
command -v numlockx >/dev/null 2>&1 && numlockx &
command -v libinput-gestures >/dev/null 2>&1 &&
  pgrep -x libinput-gestures >/dev/null || libinput-gestures &

# === Touchpad & TrackPoint settings ===
if xinput list "Elan Touchpad" >/dev/null 2>&1; then
  xinput --set-prop "Elan Touchpad" "libinput Tapping Enabled" 1
  xinput --set-prop "Elan Touchpad" "libinput Natural Scrolling Enabled" 0
  xinput --set-prop "Elan Touchpad" "libinput Disable While Typing Enabled" 1
  xinput --set-prop "Elan Touchpad" "libinput Accel Speed" 0.3
fi

if xinput list "Elan TrackPoint" >/dev/null 2>&1; then
  xinput --set-prop "Elan TrackPoint" "libinput Accel Speed" 0.0
fi

# === Monitor setup ===
for output in eDP1 eDP2 eDP3 eDP4 eDP-1 eDP-2 eDP-3 eDP-4; do
  xrandr --output "$output" --mode 1920x1080 --rate 60.00 2>/dev/null
done

# === Start background apps only if not already running ===
pgrep -x dunst >/dev/null || dunst &
pgrep -x picom >/dev/null || picom &
pgrep -x dwmblocks >/dev/null || dwmblocks &

# === Wallpaper ===
[ -f ~/.fehbg ] && ~/.fehbg &
