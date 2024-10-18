
from libqtile import bar, widget
from libqtile.lazy import lazy

def init_widgets_list(colors):
    left_side_widgets = [
        widget.TextBox(
            text="  ", 
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
            fmt=" {}",
            update_interval=2,
            mouse_callbacks={"Button1": lazy.spawn("gnome-system-monitor")},
        ),
        widget.Net(
            interface="wlan0",
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
    ]
    center_widgets = [
        widget.WindowName(
            foreground=colors["bright_white"],
            fontsize=14,
        ),
        widget.TaskList(
            highlight_method="block",
            icon_size=17,
            max_title_width=150,
            rounded=False,
            padding=5,
            margin=3,
            background=colors["background"],
            foreground=colors["foreground"],
            border=colors["blue"],
            urgent_border=colors["red"],
            mouse_callbacks={
                "Button1": lazy.group.next_window(),
                "Button3": lazy.window.kill(),
            },
        ),
    ]
    right_side_widgets = [
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
            format="   %H:%M:%S",
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
    widgets_list = left_side_widgets + center_widgets + right_side_widgets
    return widgets_list
