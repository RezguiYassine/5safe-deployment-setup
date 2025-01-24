from libqtile import bar, widget
from libqtile.lazy import lazy


def init_widgets_list(colors):
    left_side_widgets = [
        widget.TextBox(
            text="  ",
            foreground=colors["cyan"],  # Adjusted to match Waybar
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
            active=colors["bright_white"],  # Active windows color
            inactive=colors["bright_black"],  # Inactive windows color
            rounded=False,
            highlight_method="block",
            this_current_screen_border=colors["blue"],  # Current screen's window
            this_screen_border=colors["bright_black"],  # Inactive screen window
            other_current_screen_border=colors["magenta"],  # Other screen
            other_screen_border=colors["bright_black"],  # Other inactive screen
            hide_unused=True,
            urgent_alert_method="block",
            urgent_border=colors["red"],  # Urgent window border
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
            background=colors["background"],  # Background color
            foreground=colors["foreground"],  # Foreground color
            padding=10,
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
        ),
        widget.CPU(
            format="󰍛 {load_percent}%",
            foreground=colors["blue"],  # CPU widget color
            update_interval=2.0,
            mouse_callbacks={"Button1": lazy.spawn("gnome-system-monitor")},
        ),
        widget.Memory(
            format="{MemPercent}%",
            measure_mem="G",
            foreground=colors["magenta"],  # Memory widget color
            update_interval=2.0,
            mouse_callbacks={"Button1": lazy.spawn("gnome-system-monitor")},
        ),
        widget.ThermalSensor(
            foreground=colors["red"],  # Temperature sensor color
            threshold=90,
            fmt=" {}",
            update_interval=2,
            mouse_callbacks={"Button1": lazy.spawn("gnome-system-monitor")},
        ),
        widget.Net(
            interface="wlan0",
            format="{down} ↓↑ {up}",
            foreground=colors["green"],  # Network widget color
            update_interval=1.0,
            mouse_callbacks={"Button1": lazy.spawn("nm-connection-editor")},
        ),
        widget.Battery(
            format="{char} {percent:2.0%}",
            charge_char="󰂄",  # Battery charging icon
            discharge_char="󰁺",  # Battery discharging icon
            full_char="󰁹",  # Battery full icon
            unknown_char="󰂑",  # Unknown status
            empty_char="󰂃",  # Battery empty icon
            show_short_text=False,
            foreground=colors["green"],  # Battery widget color
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
            foreground=colors["bright_blue"],  # Active window name color
            fontsize=14,
            max_chars=40,
        ),
        widget.TaskList(
            highlight_method="block",
            icon_size=17,
            max_title_width=150,
            rounded=False,
            padding=5,
            margin=3,
            background=colors["background"],  # Background for the tasklist
            foreground=colors["foreground"],  # Foreground text color
            border=colors["blue"],  # Tasklist border color
            urgent_border=colors["red"],  # Urgent window border
            mouse_callbacks={
                "Button1": lazy.group.next_window(),
                "Button3": lazy.window.kill(),
            },
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
        ),
    ]

    right_side_widgets = [
        widget.CurrentLayoutIcon(
            scale=0.7,
            foreground=colors["white"],  # Layout icon color
            padding=5,
        ),
        widget.KeyboardLayout(
            configured_keyboards=["eu", "ar", "ru", "tr"],
            display_map={"eu": "EU", "ar": "AR", "ru": "RU", "tr": "TR"},
            foreground=colors["bright_white"],  # Keyboard layout color
            mouse_callbacks={
                "Button1": lazy.widget["keyboardlayout"].next_keyboard(),
            },
        ),
        widget.Clock(
            format=" %H:%M:%S",
            foreground=colors["blue"],  # Clock color
            update_interval=1.0,
            mouse_callbacks={"Button1": lazy.spawn("gnome-calendar")},
        ),
        widget.Clock(
            format=" %a %d-%m-%Y",
            foreground=colors["blue"],  # Date color
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
            foreground=colors["red"],  # Exit button color
            padding=6,
        ),
    ]

    widgets_list = left_side_widgets + center_widgets + right_side_widgets
    return widgets_list
