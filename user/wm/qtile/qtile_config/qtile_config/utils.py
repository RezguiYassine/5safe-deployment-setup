from libqtile.config import Key, Group
from config import mod, alt, shift
from libqtile.lazy import lazy


def switch_group(group: Group):
    return Key(
        [mod],
        group.name,
        lazy.group[group.name].toscreen(),
        desc=f"Switch to group {group.name}",
    )


def move_window_and_switch_to_group(group: Group):
    return Key(
        [alt],
        group.name,
        lazy.window.togroup(group.name, switch_group=True),
        desc=f"Switch to & move focused window to group {group.name}",
    )


def move_window_to_group(group: Group):
    return Key(
        [mod, shift],
        group.name,
        lazy.window.togroup(group.name),
        desc="move focused window to group {}".format(group.name),
    )
