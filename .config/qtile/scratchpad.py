from libqtile import hook
from libqtile.config import ScratchPad, DropDown


def overlay_scratchpad_setup(groups, qtile, colors):
    shortcut_text = """Shortcuts:
Mod+Return: Terminal
Mod+b: Browser
Mod+Shift+h/j/k/l: Move Windows
Mod+Ctrl+w: Maximize
Mod+h: Minimize
Mod+Tab: Next Layout
Mod+q: Close Window
Mod+f: Fullscreen
Mod+t: Floating
Mod+r: Reload Qtile
Mod+Space: Run Command"""

    overlay_group_name = "overlay"

    if overlay_group_name not in [g.name for g in groups]:
        groups.append(
            ScratchPad(
                overlay_group_name,
                [
                    DropDown(
                        "shortcuts",
                        "echo '{}'".format(shortcut_text.replace("\n", "; ")),
                        width=0.3,
                        height=0.6,
                        x=0.65,
                        y=0.2,
                        opacity=0.9,
                        on_focus_lost_hide=True,
                        # optional styling
                        # background=colors[0],
                        # foreground=colors[7],
                    )
                ],
            )
        )

    overlay_visible = False

    def show_overlay():
        nonlocal overlay_visible
        if not overlay_visible:
            qtile.groups_map[overlay_group_name].dropdown_map["shortcuts"].toggle()
            overlay_visible = True

    def hide_overlay():
        nonlocal overlay_visible
        if overlay_visible:
            qtile.groups_map[overlay_group_name].dropdown_map["shortcuts"].toggle()
            overlay_visible = False

    def update_overlay(*args, **kwargs):
        group = qtile.current_group
        if len(group.windows) == 0:
            show_overlay()
        else:
            hide_overlay()

    hook.subscribe.setgroup(update_overlay)
    hook.subscribe.client_managed(update_overlay)
    hook.subscribe.client_killed(update_overlay)
