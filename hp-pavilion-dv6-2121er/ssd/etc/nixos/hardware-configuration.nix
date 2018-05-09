# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  # Define on which hard drive you want to install Grub.
  boot.loader.grub = {
    device = "/dev/sda";
    extraEntries = ''
      menuentry "Windows 8" {
        chainloader (hd0,1)+1
      }
    '';
  };

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "firewire_ohci" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/279315d0-67aa-41bf-bcc6-e0a5ce55f40a";
      fsType = "ext4";
      options = [ "rw" "noatime" "discard" ];
    };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/c5f7eb3d-acc9-41ce-a16b-082087e8f514";
    fsType = "ext4";
    options = [ "rw" "noatime" "discard" ];
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = "ondemand";

  services.xserver.videoDrivers = [ "nouveau" ];
  # services.xserver.videoDrivers = [ "nvidiaLegacy340" ];
  services.xserver.synaptics.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
}
