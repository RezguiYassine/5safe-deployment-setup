from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
import os
import subprocess
from libqtile import hook
import operator

from qtile_config.keys import keys, mouse, groups
from qtile_config.layouts import layouts, floating_layout
from qtile_config.hooks import *
from colors import colors

# Define default widget settings
widget_defaults = dict(
    font="FontAwesome, Noto Sans",
    fontsize=16,
    padding=5,
    background=colors["background"],
    foreground=colors["foreground"],
)


def init_widgets_list():
    widgets_list = [
        widget.TextBox(
            text="  ",  # NixOS logo or a suitable icon
            mouse_callbacks={"Button1": lazy.spawn("nwggrid-wrapper")},
            foreground=colors["cyan"],
            padding=8,
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
        ),
        widget.GroupBox(
            font="FontAwesome",
            fontsize=20,
            margin_y=3,
            margin_x=0,
            padding_y=5,
            padding_x=3,
            borderwidth=3,
            active=colors["bright_white"],
            inactive=colors["bright_black"],
            rounded=False,
            highlight_method="block",
            this_current_screen_border=colors["blue"],
            this_screen_border=colors["bright_black"],
            other_current_screen_border=colors["magenta"],
            other_screen_border=colors["bright_black"],
            hide_unused=True,
            urgent_alert_method="block",
            urgent_border=colors["red"],
            disable_drag=True,
            mouse_callbacks={
                "Button3": lazy.spawn("rofi -show drun"),
            },
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
        ),
        widget.Prompt(
            prompt="Run: ",
            background=colors["background"],
            foreground=colors["foreground"],
            padding=10,
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
        ),
        # System Stats Group
        widget.CPU(
            format="󰍛 {load_percent}%",
            foreground=colors["blue"],
            update_interval=2.0,
            mouse_callbacks={"Button1": lazy.spawn("gnome-system-monitor")},
        ),
        widget.Memory(
            format="  {MemPercent}%",
            measure_mem="G",
            foreground=colors["magenta"],
            update_interval=2.0,
            mouse_callbacks={"Button1": lazy.spawn("gnome-system-monitor")},
        ),
        widget.ThermalSensor(
            foreground=colors["red"],
            threshold=90,
            fmt=" {}",  # Replaces "Temp" with a temperature icon
            update_interval=2,
            mouse_callbacks={"Button1": lazy.spawn("gnome-system-monitor")},
        ),
        widget.Net(
            interface="wlan0",  # Adjust to your network interface
            format="{down} ↓↑ {up}",
            foreground=colors["green"],
            update_interval=1.0,
            mouse_callbacks={"Button1": lazy.spawn("nm-connection-editor")},
        ),
        widget.Battery(
            format="{char} {percent:2.0%}",
            charge_char="󰂄",
            discharge_char="󰁺",
            full_char="󰁹",
            unknown_char="󰂑",
            empty_char="󰂃",
            show_short_text=False,
            foreground=colors["green"],
            update_interval=60,
            mouse_callbacks={"Button1": lazy.spawn("gnome-power-statistics")},
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
        ),
        # Center Widgets
        widget.WindowName(
            foreground=colors["bright_white"],
            fontsize=14,
        ),
        # widget.TaskList(
        #     highlight_method="block",
        #     icon_size=17,
        #     max_title_width=150,
        #     rounded=False,
        #     padding=5,
        #     margin=3,
        #     background=colors["background"],
        #     foreground=colors["foreground"],
        #     border=colors["blue"],
        #     urgent_border=colors["red"],
        #     mouse_callbacks={
        #         "Button1": lazy.group.next_window(),
        #         "Button3": lazy.window.kill(),
        #     },
        # ),
        # Right Side Widgets
        widget.CurrentLayoutIcon(
            scale=0.7,
            foreground=colors["white"],
            padding=5,
        ),
        widget.KeyboardLayout(
            configured_keyboards=["eu", "ar", "ru", "tr"],
            display_map={"eu": "EU", "ar": "AR", "ru": "RU", "tr": "TR"},
            foreground=colors["bright_white"],
            mouse_callbacks={
                "Button1": lazy.widget["keyboardlayout"].next_keyboard(),
            },
        ),
        widget.Clock(
            format="   %H:%M:%S",  # Replaces the old clock icon with a more minimal clock icon
            foreground=colors["blue"],
            update_interval=1.0,
            mouse_callbacks={"Button1": lazy.spawn("gnome-calendar")},
        ),
        widget.Clock(
            format="  %a %d-%m-%Y",
            foreground=colors["blue"],
            update_interval=60.0,
            mouse_callbacks={"Button1": lazy.spawn("gnome-calendar")},
        ),
        # widget.OpenWeather(
        #     location='landshut',
        #     format='{location_city}: {temp}°{units_temperature} {weather_details}',
        #     api_key='your_api_key_here',
        #     foreground=colors["cyan"],
        #     update_interval=600,
        #     mouse_callbacks={'Button1': lazy.spawn("firefox https://www.weather.com")},
        # ),
        widget.Systray(
            icon_size=20,
            padding=3,
        ),
        widget.QuickExit(
            default_text=" ",
            countdown_format="{}",
            foreground=colors["red"],
            padding=6,
        ),
    ]
    return widgets_list


# Configure the screen
screens = [
    Screen(
        bottom=bar.Bar(
            widgets=init_widgets_list(),
            size=30,
            margin=[3, 7, 7, 7],  # N E S W
            background=colors["background"],
            opacity=0.94,
        ),
    ),
]


extension_defaults = widget_defaults.copy()

# Drag floating layouts.
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
