from libqtile import layout
from libqtile.config import Drag, Group, Key, Match, Screen, ScratchPad

layouts = [
    layout.MonadTall(),
    layout.TreeTab(),
    layout.Max(),
    layout.Zoomy(),
    layout.Stack(num_stacks=2),
]


floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        Match(title="Application Finder"),
        Match(title="Whisker Menu"),
        Match(wm_instance_class="xfce4-popup-whiskermenu"),
        Match(wm_instance_class="xfce4-terminal"),
        Match(title="Myuzi"),
        Match(title="scratchpad"),
        Match(wm_class="gtkcord4"),
        Match(wm_class="Geary"),
        Match(wm_class="Pavucontrol"),
        Match(wm_class="Syncthing GTK"),
        Match(wm_class="Proton Mail Bridge"),
        Match(wm_class="Zenity"),
        *layout.Floating.default_float_rules,
        Match(wm_class="confirm"),
        Match(wm_class="dialog"),
        Match(wm_class="download"),
        Match(wm_class="error"),
        Match(wm_class="file_progress"),
        Match(wm_class="notification"),
        Match(wm_class="notify"),
        Match(wm_class="popup_menu"),
        Match(wm_class="splash"),
        Match(wm_class="toolbar"),
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
