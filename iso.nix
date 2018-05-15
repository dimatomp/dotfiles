# Run with nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix

{ config, lib, pkgs, modulesPath, ... }:
{
   imports = [
     <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
   ];
   time.timeZone = "Europe/Moscow";
   i18n = {
     consoleKeyMap = "us";
     defaultLocale = "en_US.UTF-8";
     supportedLocales = [ "ru_RU.UTF-8/UTF-8" "ru_RU.KOI8-R/KOI8-R" "ru_RU/ISO-8859-5" "en_US.UTF-8/UTF-8" ];
   };
   boot.supportedFilesystems = [ "ntfs-3g" ];

   nixpkgs.config.allowUnfree = true;
   # Unfree attribute is needed for these particular lines:
   boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

   services.tor.enable = true;
   environment.systemPackages = with pkgs; [ git firefox gparted mc ];
   services.xserver = {
     enable = true;
     layout = "us,ru";
     desktopManager.xfce.enable = true;
     xkbOptions = "grp:caps_toggle";
     synaptics.enable = true;
     displayManager.auto = {
       enable = true;
       user = "root";
     };
   };
}
