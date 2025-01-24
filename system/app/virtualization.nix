{ userSettings, config, pkgs, ... }:

{
  # environment.systemPackages = with pkgs; [ virt-manager distrobox virtualbox];
  virtualisation.libvirtd = {
    allowedBridges = [
      "nm-bridge"
      "virbr0"
    ];
    enable = true;
    qemu.runAsRoot = false;
  };
  virtualisation.waydroid.enable = true;
  # virtualisation.vmware.host.enable = true;
  users.extraGroups.vboxusers.members = [ userSettings.username ];
  virtualisation.virtualbox = {
    host.enable = true;
    guest.enable = true;
    guest.dragAndDrop = true;
  };

}
