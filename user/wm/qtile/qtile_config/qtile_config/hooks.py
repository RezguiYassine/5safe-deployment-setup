import os
import subprocess

from libqtile import hook

includes = lambda s, subs: s.lower().find(subs) != -1


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.call(home)


@hook.subscribe.client_new
def floating_dialogs(window):
    dialog = window.window.get_wm_type() == "dialog"
    transient = window.window.get_wm_transient_for()
    if dialog or transient:
        window.floating = True


@hook.subscribe.client_new
def idle_dialogues(window):
    if (
        (window.window.get_name() == "Search Dialog")
        or (window.window.get_name() == "Module")
        or (window.window.get_name() == "Goto")
        or (window.window.get_name() == "IDLE Preferences")
    ):
        window.floating = True


@hook.subscribe.client_new
def blueman_float(window):
    name: str = window.window.get_name()
    if name.lower().find("blueman-manager") != -1:
        window.floating = True


@hook.subscribe.client_new
def nwggrid_wrapper_float(window):
    name: str = window.window.get_name
    group: str = window.group.get_name
    if includes(name, "nwggrid"):
        window.floating = True


@hook.subscribe.client_new
def lutris_float(window):
    info = window.window.info()
    name = info["name"]
    wm_class = info["wm_class"]
    if wm_class.lower().includes("lutris"):
        window.floating = True
