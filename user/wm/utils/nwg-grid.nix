{config, ...}:

{
  home.file.".config/nwg-launchers/nwggrid/terminal".text = "alacritty -e";
  home.file.".config/nwg-launchers/nwggrid/style.css".text = ''
    button, label, image {
        background: none;
        border-style: none;
        box-shadow: none;
        color: #'' + config.lib.stylix.colors.base07 + '';

        font-size: 20px;
    }

    button {
        padding: 5px;
        margin: 5px;
        text-shadow: none;
    }

    button:hover {
        background-color: rgba('' + config.lib.stylix.colors.base07-rgb-r + "," + config.lib.stylix.colors.base07-rgb-g + "," + config.lib.stylix.colors.base07-rgb-b + "," + ''0.15);
    }

    button:focus {
        box-shadow: 0 0 10px;
    }

    button:checked {
        background-color: rgba('' + config.lib.stylix.colors.base07-rgb-r + "," + config.lib.stylix.colors.base07-rgb-g + "," + config.lib.stylix.colors.base07-rgb-b + "," + ''0.15);
    }

    #searchbox {
        background: none;
        border-color: #'' + config.lib.stylix.colors.base07 + '';

        color: #'' + config.lib.stylix.colors.base07 + '';

        margin-top: 20px;
        margin-bottom: 20px;

        font-size: 20px;
    }

    #separator {
        background-color: rgba('' + config.lib.stylix.colors.base00-rgb-r + "," + config.lib.stylix.colors.base00-rgb-g + "," + config.lib.stylix.colors.base00-rgb-b + "," + ''0.55);

        color: #'' + config.lib.stylix.colors.base07 + '';
        margin-left: 500px;
        margin-right: 500px;
        margin-top: 10px;
        margin-bottom: 10px
    }

    #description {
        margin-bottom: 20px
    }
  '';
}