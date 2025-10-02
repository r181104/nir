import os
import subprocess
from types import FunctionType

from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# --- MODIFIERS AND TERMINAL ---
mod = "mod4"  # Super key
mmod = "mod1"  # Alt key
mmodd = "control"  # Ctrl key alias
terminal = "nvidia-run wezterm"
term = guess_terminal()
filemanager = "thunar"
theme = "wset"
browser = "nvidia-run firefox --no-remote"

# --- LOAD PYWAL COLORS ---
colors = []
cache = os.path.expanduser("~/.cache/wal/colors")
with open(cache, "r") as file:
    for _ in range(16):
        colors.append(file.readline().strip())

# --- GPU STATUS WIDGET ---
class GPUStatus(widget.base.InLoopPollText):
    """
    Show which GPU is active: Intel, NVIDIA, or both.
    Checks kernel modules and NVIDIA usage via nvidia-smi.
    """
    def __init__(self, update_interval=5, **config):
        super().__init__(**config)
        self.update_interval = update_interval

    def poll(self):
        intel_loaded = os.path.exists("/sys/module/i915")
        nvidia_loaded = os.path.exists("/proc/driver/nvidia") or os.path.exists("/sys/module/nvidia")
        nvidia_active = False

        # check if any process is using NVIDIA GPU
        try:
            output = subprocess.check_output(
                ["nvidia-smi", "--query-compute-apps=pid", "--format=csv,noheader"],
                text=True
            )
            if output.strip():
                nvidia_active = True
        except Exception:
            pass

        if intel_loaded and nvidia_active:
            return "GPU: Intel + NVIDIA active"
        elif nvidia_active:
            return "GPU: NVIDIA active"
        elif intel_loaded:
            return "GPU: Intel active"
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
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),

    # System controls
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),
    Key([], "XF86AudioMedia", lazy.spawn("pavucontrol")),

    # Layout navigation and window movement
    Key([mod, "shift"], "space", lazy.layout.next()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),

    # Window resizing
    Key([mod, "control"], "h", lazy.layout.grow_left()),
    Key([mod, "control"], "j", lazy.layout.grow_down()),
    Key([mod, "control"], "k", lazy.layout.grow_up()),
    Key([mod, "control"], "l", lazy.layout.grow_right()),
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod, "control"], "Return", lazy.layout.toggle_split()),

    # System commands
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "t", lazy.window.toggle_floating()),
    Key([mod], "r", lazy.reload_config(), lazy.spawn("notify-send 'Config Reloaded'")),
    Key([mmod, "control"], "q", lazy.shutdown()),
    Key([mod], "space", lazy.spawncmd()),
]

# VT switching for Wayland fallback
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: getattr(qtile.core, "name", "") == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

# --- GROUPS WITH NERD FONT ICONS ---
groups = [
    Group("1", label=""),  # Terminal
    Group("2", label=""),  # Browser
    Group("3", label=""),  # Code
    Group("4", label=""),  # Tools
    Group("5", label=""),  # Files
    Group("6", label=""),  # Media
    Group("7", label=""),  # Chat
    Group("8", label=""),  # Containers
    Group("9", label=""),  # Docs
    Group("0", label=""),  # Settings
]

# Group keybindings
for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True)),
    ])

# --- LAYOUTS WITH PYWAL COLORS ---
layout_common = {
    "border_focus": colors[5],
    "border_normal": colors[8],
    "border_width": 2,
    "margin": 0,
}

layouts = [
    layout.Columns(**layout_common),
    layout.Tile(**layout_common),
]

# --- WIDGET DEFAULTS ---
widget_defaults = {
    "font": "MesloLGS Nerd Font Bold",
    "fontsize": 15,
    "padding": 10,
    "foreground": colors[7],
    "background": colors[0],
}
extension_defaults = widget_defaults.copy()

# --- BAR CONFIGURATION ---
def create_bar_widgets():
    return [
        widget.CurrentLayoutIcon(scale=0.7, foreground=colors[3], padding=12),
        widget.Spacer(length=12),
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
        widget.Spacer(length=12),
        widget.Prompt(padding=12),
        widget.Spacer(),
        widget.WindowName(max_chars=100, foreground=colors[6], padding=12),
        widget.Spacer(),
        widget.Systray(icon_size=20, padding=12),
        widget.Spacer(length=12),
        widget.CheckUpdates(
            distro="NixOS",
            display_format=" {updates}",
            no_update_string=" 0",
            update_interval=1800,
            foreground=colors[2],
            padding=10,
        ),
        widget.Spacer(length=12),
        widget.CPU(format=" {load_percent}%", foreground=colors[3], padding=10),
        widget.Spacer(length=12),
        widget.Memory(format=" {MemPercent}%", foreground=colors[5], padding=10),
        widget.Spacer(length=12),
        widget.Net(
            format=" {down:.2f} MB/s  ↑ {up:.2f} MB/s",
            foreground=colors[4],
            use_bits=False,
            prefix="M",
            padding=10,
            parse=lambda x: 0.00 if x < 0.05 else round(x, 2),
        ),
        widget.Spacer(length=12),
        GPUStatus(foreground=colors[7], padding=12),  # <- Fixed GPU widget
        widget.Spacer(length=12),
        widget.Clock(format=" %H:%M", foreground=colors[6], padding=10),
        widget.Spacer(length=12),
        widget.Clock(format=" %a %d", foreground=colors[2], padding=10),
        widget.Spacer(length=12),
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
        widget.Spacer(length=12),
        widget.QuickExit(default_text="", foreground=colors[1], padding=12),
        widget.Spacer(length=12),
    ]

screens = [
    Screen(
        bottom=bar.Bar(
            create_bar_widgets(),
            36,
            margin=[8, 12, 4, 12],
            background=colors[0],
            opacity=0.8,
        ),
    ),
]

# --- MOUSE CONFIGURATION ---
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# --- OTHER SETTINGS ---
dgroups_key_binder = None
dgroups_app_rules: list[FunctionType] = []  # type-annotated for mypy
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
