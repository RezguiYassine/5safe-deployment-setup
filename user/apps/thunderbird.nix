{ pkgs, ... }:
{
  programs.thunderbird = {
    # Enable the Thunderbird mail client
    enable = true;

    # Optionally specify which Thunderbird package you want.
    # By default, this is `pkgs.thunderbird`. For instance, you could use the -bin variant:
    # package = pkgs.thunderbird-bin;

    # (Optional) Specify Thunderbird’s Group Policies as JSON.
    # For example, to declare a simple policy:
    policies = {
      # Example: Force a particular homepage on new tabs.
      "Homepage" = {
        "StartPage" = "https://www.nixos.org"
        # "Override" = true
      };

      # Example: Use ExtensionSettings to install or manage extensions.
      # "ExtensionSettings" = {
      #   "*@mozilla.org" = {
      #     "allowed_types" = [ "extension" "theme" "dictionary" ];
      #     "updates_enabled" = true;
      #     "install_sources" = [ "https://addons.mozilla.org/" ];
      #   };
      # };
    };

    # (Optional) Set Thunderbird preferences from `about:config`.
    preferences = {
      # Example: Disable auto-updates
      "app.update.auto" = false;

      # Example: Configure how cookies are handled
      # 0 = Accept all
      # 1 = Only from originating site
      "network.cookie.cookieBehavior" = 1;

      # ... add more preferences as needed
    };

    # (Optional) Control how the above preferences appear:
    #  - "locked":   Preferences appear as default and cannot be changed
    #  - "default":  Preferences appear as default (user can override)
    #  - "user":     Preferences appear as changed by the user
    #  - "clear":    Resets to factory defaults on each startup
    preferencesStatus = "default";
  };
}
