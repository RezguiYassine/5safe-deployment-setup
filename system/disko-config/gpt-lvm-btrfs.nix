{...}: {
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          primary = {
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "mainpool";
            };
          };
        };
      };
    };
    /**
    Storage pool type: lvmthin
    LVM normally allocates blocks when you create a volume.
    LVM thin pools instead allocates blocks when they are written.
    This behaviour is called thin-provisioning, because volumes can be much larger than physically available space.
    You can use the normal LVM command-line tools to manage and create LVM thin pools
    source: https://pve.proxmox.com/wiki/Storage:_LVM_Thin
    */
    lvm_vg.mainpool = {
      type = "lvm_vg";
      lvs = {
        thinpool = {
          size = "1000G";
          lvm_type = "thin-pool";
          extraArgs = [ "--chunksize" "64K" ];
        };
        root = {
          size = "600G";
          lvm_type = "thinlv";
          pool = "thinpool";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            mountpoint = "/media/btrfsroots/root";  # Temporary mount
            subvolumes = {
              "@" = { mountpoint = "/"; };
              "@home" = {
                mountOptions = [
                  "compress=zstd:3"
                  "noatime"
                  "autodefrag"
                  "space_cache"
                  ];
                mountpoint = "/home";
              };
              "@nix" = {
                mountOptions = [
                  "compress=zstd:3"
                  "noatime"
                  "autodefrag"
                  "space_cache"
                  ];
                mountpoint = "/nix";
              };
              "@swap" = {
                mountOptions = [ "nodatacow" ];  # Required
                mountpoint = "/.swapvol";
                swap.swapfile.size = "16G";
              };
            };
          };
        };
      };
    };
  };
}
