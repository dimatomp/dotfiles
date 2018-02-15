{ stdenv, buildFHSUserEnv, lib, zlib, gnome3, gtk2-x11, gnome2, glib, libgnome_keyring, xlibs, writeTextFile }:
let
  version = "5.3r3.0-b1051";
  debHash = "nmc7drpj9xr8slq0mp443ahf4midvyqa";
  pulsePackage = stdenv.mkDerivation {
    inherit version;
    name = "ps-pulse-bin-${version}";
    src = "/nix/store/${debHash}-ps-pulse-linux-${version}-ubuntu-debian-64-bit-installer.deb";
    sourceRoot = ".";
    unpackCmd = "ar p "$src" data.tar.gz | tar xz";
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      cp -r usr $out
    '';
  };
  fhsEnv = buildFHSUserEnv {
    name = "ps-pulse-fhs-env-${pulsePackage.version}";
    targetPackages = [ pulsePackage zlib stdenv.cc.cc.lib gnome3.webkitgtk gtk2-x11 gnome2.libsoup glib libgnome_keyring xlibs.libX11 glib ];
  }
in fhsEnv;
  
