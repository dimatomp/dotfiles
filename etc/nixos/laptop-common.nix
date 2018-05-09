{config, lib, pkgs, ...}:

{
  imports = [ ];

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = "load-module module-switch-on-connect";
  };

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="deadline"
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="cfq"
  '';

  hardware.opengl.driSupport32Bit = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.logind.lidSwitch = "ignore";
  services.tor.enable = true;
  nix.maxJobs = lib.mkDefault 4;
  networking.hostName = "tompe_laptop"; # Define your hostname.
}
