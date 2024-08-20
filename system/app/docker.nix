{ pkgs, lib, userSettings, storageDriver ? null, ... }:

assert lib.asserts.assertOneOf "storageDriver" storageDriver [
  null
  "aufs"
  "btrfs"
  "devicemapper"
  "overlay"
  "overlay2"
  "zfs"
];

{

  hardware.nvidia-container-toolkit = {
    enable = true;
    mount-nvidia-executables = true;
    mount-nvidia-docker-1-directories = true;
  };
  virtualisation={
    containers.enable = true;
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      # extraPackages = [ pkgs.zfs ]; # Required if the host is running ZFS
    };
    docker = {
      # package = pkgs.docker_25;
      enable = false;
      enableOnBoot = true;
      # enableNvidia = true;
      storageDriver = storageDriver;
      autoPrune.enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon.settings = {
        default-runtime = "nvidia";
        exec-opts = ["native.cgroupdriver=cgroupfs"];
      };
    };
  };
  
};
  users.users.${userSettings.username}.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    lazydocker
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
  ];
}
