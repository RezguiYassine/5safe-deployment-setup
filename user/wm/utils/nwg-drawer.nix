{config, ...}:

{
    home.file.".config/nwg-drawer/drawer.css".text = ''
    window {
        background-color: rgba('' + config.lib.stylix.colors.base00-rgb-r + "," + config.lib.stylix.colors.base00-rgb-g + "," + config.lib.stylix.colors.base00-rgb-b + "," + ''0.55);
        color: #'' + config.lib.stylix.colors.base07 + ''
    }

    /* search entry */
    entry {
        background-color: rgba('' + config.lib.stylix.colors.base01-rgb-r + "," + config.lib.stylix.colors.base01-rgb-g + "," + config.lib.stylix.colors.base01-rgb-b + "," + ''0.45);
    }

    button, image {
        background: none;
        border: none
    }

    button:hover {
        background-color: rgba('' + config.lib.stylix.colors.base02-rgb-r + "," + config.lib.stylix.colors.base02-rgb-g + "," + config.lib.stylix.colors.base02-rgb-b + "," + ''0.45);
    }

    /* in case you wanted to give category buttons a different look */
    #category-button {
        margin: 0 10px 0 10px
    }

    #pinned-box {
        padding-bottom: 5px;
        border-bottom: 1px dotted;
        border-color: #'' + config.lib.stylix.colors.base07 + '';
    }

    #files-box {
        padding: 5px;
        border: 1px dotted gray;
        border-radius: 15px
        border-color: #'' + config.lib.stylix.colors.base07 + '';
    }
  '';
}