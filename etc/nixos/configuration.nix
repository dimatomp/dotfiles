# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  addSkb = {stdenv, fetchFromGitHub, xlibs}:
    stdenv.mkDerivation rec {
      name = "skb";
    
      src = fetchFromGitHub {
        owner = "polachok";
        repo = "skb";
        rev = "38aec5ccac505e2e95af50f1552e6b80715dfff6";
        sha256 = "1lwwvsgwh05q33k1s2brh1da9gznrfhazb2k72jhxkvdwi4c99sw";
      }; 
      buildInputs = [ xlibs.libX11 ];
      CFLAGS = "-w";
    
      prePatch = ''sed -i "s@/usr@$out@" config.mk'';
      patches = [ ./skb-cflags.patch ];
    };
  addTompebar = {stdenv, mkDerivation, fetchFromGitHub, base, directory, network, process}:
    mkDerivation {
      pname = "tompebar";
      version = "0.1.0.0";
      src = fetchFromGitHub {
        owner = "dimatomp";
        repo = "tompebar";
        rev = "f940042aa4ffbd1e8b666d4669ebb648fd166a18";
        sha256 = "1c71iygnssib82fpyajgx7sfk70hqiivxvykbddmbwikr7fdk7kp";
      };
      isLibrary = false;
      isExecutable = true;
      executableHaskellDepends = [ base directory network process ];
      description = "An enhancement for the bspwm desktop environment. Divides the desktop list into workspaces for better multitasking.";
      license = stdenv.lib.licenses.free;
    };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.supportedFilesystems = [ "ntfs-3g" ];

  nixpkgs.config.allowUnfree = true;

  # Select internationalisation properties.
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "ru_RU.UTF-8/UTF-8" "ru_RU.KOI8-R/KOI8-R" "ru_RU/ISO-8859-5" "en_US.UTF-8/UTF-8" ];
    inputMethod.enabled = "uim";
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  nixpkgs.config.haskellPackageOverrides = self: super: {
    tompebar = self.callPackage addTompebar {};
  };

  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    skb = callPackage addSkb {};
  };
 
  nixpkgs.config.firefox = {
    #enableGoogleTalkPlugin = true;
    #enableAdobeFlash = true;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget which git htop cifs_utils vim_configurable
    haskellPackages.tompebar xtitle bar-xft trayer dmenu skb sakura acpi python35 python36Packages.dbus-python python36Packages.pygobject3
    pavucontrol networkmanagerapplet firefox-esr filelight
  ];

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      google-fonts
      dejavu_fonts
    ];
  };

  # List services that you want to enable:
  services.openssh.enable = true;
  services.xserver = {
    enable = true;
    layout = "us,ru";
    windowManager = {
      bspwm.enable = true;
      default = "bspwm";
    };
    xkbOptions = "grp:caps_toggle";
    displayManager.auto = {
      enable = true;
      user = "dimatomp";
    };
  };
  networking.networkmanager.enable = true;

  services.logind.extraConfig = ''
    RuntimeDirectorySize=2G
  '';

  programs.zsh.enable = true;

  users.extraUsers.dimatomp = {
    isNormalUser = true;
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  environment.shellAliases = {
    dh = "df -h";
    ll = "ls -lah";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
  nix.buildCores = 0;

}
