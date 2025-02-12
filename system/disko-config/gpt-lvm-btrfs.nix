{...}:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
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
    };
    /**
    Storage pool type: lvmthin
    LVM normally allocates blocks when you create a volume. 
    LVM thin pools instead allocates blocks when they are written.
    This behaviour is called thin-provisioning, because volumes can be much larger than physically available space.
    You can use the normal LVM command-line tools to manage and create LVM thin pools
    source: https://pve.proxmox.com/wiki/Storage:_LVM_Thin
     */
    lvm_vg = {
      mainpool = {
        type = "lvm_vg";
        lvs = {
          thinpool = {
            size = "1000G";
            lvm_type = "thin-pool";
          };
          root = {
            size = "100%";
            lvm_type = "thinlv";
            pool = "thinpool";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "/rootfs" = {
                    mountpoint = "/";
                  };
                  # Subvolume name is the same as the mountpoint
                  "/home" = {
                    mountOptions = [
                      "compress=zstd:3"
                      "autodefrag"
                      "noatime"
                      "space_cache=v2"
                      ];
                    mountpoint = "/home";
                  };
                  # Sub(sub)volume doesn't need a mountpoint as its parent is mounted
                  "/home/user" = { };
                  # Parent is not mounted so the mountpoint must be set
                  "/nix" = {
                    mountOptions = [
                      "autodefrag"       
                      "compress=zstd:3" # Compression for the Nix store subvolume.
                      "space_cache=v2" # Improved space management.
                      "noatime" # Prevents unnecessary write operations.
                      ];
                    mountpoint = "/nix";
                  };
                  # Subvolume for the swapfile
                     "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "16G";
                    };
                };

                mountpoint = "/partition-root";
                swap = {
                  swapfile = {
                    size = "16G";
                  };
                };
              };
          };
        };
      };
    };
  };
}