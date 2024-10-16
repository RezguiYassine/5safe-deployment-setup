from libqtile.lazy import lazy
from libqtile.config import Key, Group, Drag, Click
from config import mod, terminal, shift, alt, control, backspace
import utils as U
from groups import workspaces
from functools import reduce
import operator

switch_windows = [
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], backspace, lazy.layout.next(), desc="Move window focus to other window"),
]

shuffle_windows = [
    Key([mod, shift], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key(
        [mod, shift],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, shift], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, shift], "k", lazy.layout.shuffle_up(), desc="Move window up"),
]

grow_window = [
    Key([mod, control], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, control], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, control], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, control], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
]

workspaces_keys = reduce(
    operator.add,
    map(
        lambda group: [U.switch_group(group), U.move_window_to_group(group)], workspaces
    ),
)

launch_programs = [
    Key([mod], "t", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "grave", lazy.spawn("firefox"), desc="Launch firefox"),
    Key([mod], "o", lazy.spawn("obsidian"), desc="Launch obsidian"),
    Key([mod], 39, lazy.spawn("xfce4-appfinder"), desc="Launch xfce's app-finder"),
]

layouts_control = [
    Key(
        [mod, shift],
        "s",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "space",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
]


control_keys = [
    Key([mod, shift], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, control], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, control], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]
# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
virtual_terminals_wayland = [
    Key(
        [control, alt],
        f"f{vt}",
        lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
        desc=f"Switch to VT{vt}",
    )
    for vt in range(1, 8)
]

keys = [
    *switch_windows,
    *shuffle_windows,
    *grow_window,
    *workspaces_keys,
    *launch_programs,
    *layouts_control,
    *control_keys,
    *virtual_terminals_wayland,
]

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
