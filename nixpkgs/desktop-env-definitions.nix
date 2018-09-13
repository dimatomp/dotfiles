let
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
  packageOverrides = rec {
    skb = stdenv.mkDerivation rec {
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
    bspwm09 = bspwm.overrideAttrs (oldAttrs: rec {
      name = "bspwm-${version}";
      version = "0.9";

      src = fetchFromGitHub {
        owner  = "baskerville";
        repo   = "bspwm";
        rev    = version;
        sha256 = "0vsggbx9lh27ndfiayca94fx67jpzdnaz58ghm9qknlgx9fd2d5l";
      };

      patches = [ ./delete_socketfile_on_start.patch ];
    });
    sl504 = sl.overrideAttrs (oldAttrs: rec {
      name = "sl-${version}";
      version = "5.04";

      src = fetchFromGitHub {
        owner = "beefcurtains";
        repo = "sl";
        rev = "a0338aa58afa3be6365d141713df646cc9890dda";
        sha256 = "1fppc6gxsk29jrw8x0pcwj516dlnyj1pcrzb568glwm9jq4lrd9j";
      };

      installPhase = ''
        ${oldAttrs.installPhase}
        cp sl-h $out/bin
      '';
    });
    dbus-nm-status = with python36Packages; buildPythonApplication rec {
      pname ="dbus-nm-status";
      name = "${pname}-${version}";
      version = "0.1";

      src = fetchFromGitHub {
        owner = "dimatomp";
        repo = "DBusNMStatus";
        rev = "8d456aceab807265321dbf6eec322baac71afb56";
        sha256 = "0w3rp7wv76jkqdn5wbv4cq174f5xap9gjfvaam1h4yk0pxssrkmw";
      };

      propagatedBuildInputs = [ dbus-python pygobject3 ];

      meta = with stdenv.lib; {
        description = "A script that prints SSID and signal strength of current Wi-Fi connection in readable format";
        homepage = http://github.com/dimatomp/DBusNMStatus;
      };
    };

    bspwmEnv = buildEnv { 
      name = "bspwm-deps-env"; 
      paths = [ haskellPackages.tompebar xtitle bar-xft trayer dmenu skb sakura acpi dbus-nm-status bc feh numlockx sselp bspwm09 sxhkd ];
      ignoreCollisions = true;
    };
  }
  haskellPackageOverrides = self: super: {
    tompebar = self.callPackage addTompebar {};
  };
}
