import os
import subprocess
from typing import Any

from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import Click, Drag, DropDown, Group, Key, Match, ScratchPad, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# --- MODIFIERS AND TERMINAL ---
mod = "mod4"  # Super key
mmod = "mod1"  # Alt key
mmodd = "control"  # Ctrl key alias
terminal = "alacritty"
term = guess_terminal()
filemanager = "pcmanfm"
theme = "wset"
browser = "firefox-devedition --no-remote"

# --- LOAD PYWAL COLORS ---
colors = []
cache = os.path.expanduser("~/.cache/wal/colors")
with open(cache, "r") as file:
    for _ in range(16):
        colors.append(file.readline().strip())


# --- LIGHTWEIGHT GPU STATUS WIDGET ---
class GPUStatus(widget.base.InLoopPollText):
    """
    Show which GPU is active: Intel, NVIDIA, or both.
    Lightweight: only checks loaded kernel modules.
    """

    def poll(self):
        intel_loaded = os.path.exists("/sys/module/i915")
        nvidia_loaded = os.path.exists("/sys/module/nvidia")
        if intel_loaded and nvidia_loaded:
            return "GPU: Intel + NVIDIA"
        elif nvidia_loaded:
            return "GPU: NVIDIA"
        elif intel_loaded:
            return "GPU: Intel"
        else:
            return "GPU: unknown"


# --- KEYBINDINGS ---
keys = [
    # Launch applications
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn(browser), desc="Launch browser"),
    Key([mmodd], "space", lazy.spawn(theme), desc="Launch theme changer"),
    Key([mod], "e", lazy.spawn(filemanager), desc="Launch file manager"),
    # Layout navigation
    Key([mod], "j", lazy.screen.prev_group()),
    Key([mod], "k", lazy.screen.next_group()),
    # Window management
    Key([mod, "control"], "w", lazy.window.toggle_maximize()),
    Key([mod], "h", lazy.window.toggle_minimize()),
    Key([mmod, "control"], "l", lazy.spawn("lock")),
    # Media controls
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
    ),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    # System controls
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),
    Key([], "XF86AudioMedia", lazy.spawn("pavucontrol")),
    # Directional focus
    Key([mmod], "h", lazy.layout.left(), desc="Focus left"),
    Key([mmod], "l", lazy.layout.right(), desc="Focus right"),
    Key([mmod], "j", lazy.layout.down(), desc="Focus down"),
    Key([mmod], "k", lazy.layout.up(), desc="Focus up"),
    # Layout navigation and window movement
    Key([mod, "shift"], "space", lazy.layout.next()),
    Key([mod, "control"], "h", lazy.layout.shuffle_left()),
    Key([mod, "control"], "j", lazy.layout.shuffle_down()),
    Key([mod, "control"], "k", lazy.layout.shuffle_up()),
    Key([mod, "control"], "l", lazy.layout.shuffle_right()),
    # Window resizing
    Key([mod, "shift"], "h", lazy.layout.grow_left()),
    Key([mod, "shift"], "j", lazy.layout.grow_down()),
    Key([mod, "shift"], "k", lazy.layout.grow_up()),
    Key([mod, "shift"], "l", lazy.layout.grow_right()),
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod, "control"], "Return", lazy.layout.toggle_split()),
    # System commands
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "t", lazy.window.toggle_floating()),
    Key([mod], "r", lazy.reload_config(), lazy.spawn("notify-send 'Config Reloaded'")),
    Key([mmod, "control"], "q", lazy.shutdown()),
    # FIXED: spawncmd with prompt widget
    Key([mod], "space", lazy.spawncmd(prompt="Run: ", widget="runprompt")),
]

# VT switching for Wayland fallback
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(
                func=lambda: getattr(qtile.core, "name", "") == "wayland"
            ),
            desc=f"Switch to VT{vt}",
        )
    )

# --- GROUPS WITH NERD FONT ICONS ---
groups = [
    Group("1", label=""),
    Group("2", label=""),
    Group("3", label=""),
    Group("4", label=""),
    Group("5", label=""),
    Group("6", label=""),
    Group("7", label=""),
    Group("8", label=""),
    Group("9", label=""),
    Group("0", label=""),
]

# Group keybindings
for i in groups:
    keys.extend(
        [
            Key([mod], i.name, lazy.group[i.name].toscreen()),
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True)),
        ]
    )

groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "term",
                "alacritty",
                width=0.8,
                height=0.8,
                x=0.1,
                y=0.0,
                opacity=0.8,
                on_focus_lost_hide=True,
            ),
            DropDown(
                "volumemixer",
                "env WM_CLASS=pavucontrol pavucontrol",
                width=0.8,
                height=0.6,
                x=0.1,
                y=0.4,
                opacity=0.8,
                on_focus_lost_hide=True,
            ),
        ],
    ),
),

keys.extend(
    [
        Key([mod], "p", lazy.group["scratchpad"].dropdown_toggle("term")),
        Key([mod], "v", lazy.group["scratchpad"].dropdown_toggle("volumemixer")),
    ]
)

# --- LAYOUTS WITH PYWAL COLORS ---
layout_common = {
    "border_focus": colors[5],
    "border_normal": colors[8],
    "border_width": 2,
    "margin": 0,
}

layouts = [layout.Columns(**layout_common), layout.Tile(**layout_common)]

# --- WIDGET DEFAULTS ---
widget_defaults = {
    "font": "MesloLGS Nerd Font Bold",
    "fontsize": 15,
    "padding": 10,
    "foreground": colors[7],
    "background": colors[0],
}
extension_defaults = widget_defaults.copy()


# --- LIGHTWEIGHT BAR CONFIGURATION ---
def create_bar_widgets():
    return [
        widget.CurrentLayoutIcon(scale=0.7, foreground=colors[3], padding=12),
        widget.GroupBox(
            highlight_method="block",
            block_highlight_text_color=colors[7],
            inactive=colors[8],
            active=colors[7],
            this_current_screen_border=colors[5],
            urgent_text=colors[1],
            rounded=True,
            padding=12,
            margin_x=6,
        ),
        widget.Prompt(
            prompt="Run: ",
            name="runprompt",
            foreground=colors[5],
            padding=0,
        ),
        widget.WindowName(max_chars=100, foreground=colors[6], padding=12),
        widget.Systray(icon_size=20, padding=12),
        widget.CheckUpdates(
            distro="NixOS",
            display_format=" {updates}",
            no_update_string=" 0",
            update_interval=1800,
            foreground=colors[2],
            padding=10,
        ),
        widget.CPU(
            format=" {load_percent}%",
            foreground=colors[3],
            padding=10,
            update_interval=1.0,
        ),
        widget.Memory(
            format=" {MemPercent}%",
            foreground=colors[5],
            padding=10,
            update_interval=2.0,
        ),
        widget.Net(
            format=" {down:.2f} MB/s ↑ {up:.2f} MB/s",
            foreground=colors[4],
            use_bits=False,
            prefix="M",
            update_interval=2.0,
        ),
        GPUStatus(foreground=colors[7], padding=12),
        widget.Clock(format=" %H:%M", foreground=colors[6], padding=10),
        widget.Clock(format=" %a %d", foreground=colors[2], padding=10),
        widget.Battery(
            battery="BAT0",
            format="{char} {percent:2.0%}",
            full_char="",
            charge_char="",
            discharge_char="",
            empty_char="",
            low_percentage=0.15,
            low_foreground=colors[1],
            foreground=colors[9],
            padding=10,
            font="MesloLGS Nerd Font",
            fontsize=16,
            show_short_text=False,
            update_interval=10,
        ),
        widget.QuickExit(default_text="", foreground=colors[1], padding=12),
    ]


screens = [
    Screen(
        bottom=bar.Bar(
            create_bar_widgets(),
            36,
            margin=[8, 12, 4, 12],
            background=colors[0],
            opacity=0.8,
        )
    )
]

# --- MOUSE CONFIGURATION ---
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# --- OTHER SETTINGS ---
dgroups_key_binder = None
dgroups_app_rules: list[Any] = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ]
)


# --- AUTOSTART HOOK ---
@hook.subscribe.startup_once
def autostart():
    subprocess.Popen([os.path.expanduser("~/nir/.local/bin/autostart")])
