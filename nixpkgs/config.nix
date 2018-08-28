let 
  pythonPackageOverrides = {fetchurl, stdenv}: self: super: with super; rec {
    dawg_python = buildPythonPackage rec {
      name = "DAWG-Python-${version}";
      version = "0.7.2";
      src = fetchurl {
        url = "mirror://pypi/D/DAWG_Python/${name}.tar.gz";
        sha256 = "089lbrcqz025scl1ri9hza803cbsd98xbkq5y81cl716ws334pja";
      };
    };

    pymorphy2_dicts = buildPythonPackage rec {
      name = "pymorphy2-dicts-${version}";
      version = "2.4.393442.3710985";
      src = fetchurl {
        url = "mirror://pypi/p/pymorphy2_dicts/${name}.tar.gz";
        sha256 = "0jlyqxx808qvaq5gldd0cri0ziskgydgh1rgjhf9r4ghnl168z5y";
      };
    };

    pymorphy2 = buildPythonPackage rec {
      name = "pymorphy2-${version}";
      version = "0.8";
      src = fetchurl {
        url = "mirror://pypi/p/pymorphy2/${name}.tar.gz";
        sha256 = "13yvmjddwjygc5kfs9wqya6zzjvmz4v140alzaia6y3gbqgw54ih";
      };
      propagatedBuildInputs = [ pymorphy2_dicts dawg_python docopt ];
    };

    mmh3 = buildPythonPackage rec {
      name = "mmh3-${version}";
      version = "2.3.1";
      src = fetchurl {
        url = "mirror://pypi/m/mmh3/${name}.tar.gz";
        sha256 = "0a795lk2gqj5ar0diwpd0gsgycv83pwlr0a91fki2ch9giaw7bgc";
      };
    };

    pytorch = buildPythonPackage rec {
      pname = "pytorch";
      version = "0.4.0";
      name = "${pname}-${version}";
      disabled = !isPy36;

      format = "wheel";
      src = fetchurl {
        url = "http://download.pytorch.org/whl/cpu/torch-0.4.0-cp36-cp36m-linux_x86_64.whl";
        sha256 = "01xi8ib9cfn75kvr847n3sz7qp0l1vnzcpvs8a0qljrr9avxcqd5";
      };
      propagatedBuildInputs = [ numpy ];
      fixupPhase = ''
        for i in $out/lib/${python.libPrefix}/site-packages/torch/*.so; do 
          patchelf --add-needed ${stdenv.cc.cc.lib}/lib/libstdc++.so.6 $i
        done
      '';
    };
  };
  cloudCross = {qtbase, qmake, curl, stdenv, fetchFromGitHub}: 
    stdenv.mkDerivation rec {
      name = "cloudcross-${version}";
      version = "1.4.2";
      src = fetchFromGitHub {
        owner = "MasterSoft24";
        repo = "CloudCross";
        rev = "v${version}";
        sha256 = "1ady2qiii8yygqg0j4mabfjk09idhav20q3w52vqqiqlhjl6q8il";
      };
      nativeBuildInputs = [ qmake ];
      buildInputs = [ qtbase curl ];
      installPhase = ''
        mkdir -p $out/bin $out/man/man1
        cp ccross-app/ccross ccross-curl-executor/ccross-curl $out/bin
        cp ccross-app/doc/ccross $out/man/man1/ccross.1
      '';
    };
in {
  packageOverrides = pkgs: with pkgs; rec {
    python3 = pkgs.python3.override { packageOverrides = callPackage pythonPackageOverrides {}; };
    python3Setup = python3.withPackages (ps: with ps; [ matplotlib pytorch ]); # notebook pandas scikitlearn ipykernel 
    python2 = pkgs.python2.override { packageOverrides = callPackage pythonPackageOverrides {}; };
    python2Setup = python2.buildEnv.override {
      extraLibs = with python2.pkgs; [ numpy (matplotlib.override {enableGtk2 = true;}) scipy ];
      ignoreCollisions = true;
    };
    texliveSetup = texlive.combine {
      inherit (texlive) scheme-basic collection-langcyrillic collection-langgerman collection-fontsrecommended metafont listings caption adjustbox xkeyval upquote collectbox ucs fancyvrb booktabs ulem extsizes csquotes tabu varwidth floatrow algorithms algorithmicx enumitem setspace biber biblatex iftex lastpage totcount longfigure chngcntr titlesec paratype logreq xstring biblatex-gost was pgf ms filecontents;
    };
    haskellSetup = ghc; #haskellPackages.ghcWithPackages (p: with p; [ ]);
    #pulse-secure = callPackage ./pulse-secure.nix {};
    soxMp3 = sox.override { enableLame = true; };
    ocamlEnv = buildFHSUserEnv {
      name = "ocaml-env";
      targetPkgs = pkgs: with pkgs; [ ocaml-ng.ocamlPackages_4_06.ocaml opam gnum4 gnumake curl patch unzip git gcc_multi gdb vim_configurable ];
    };
    cloudcross = libsForQt56.callPackage cloudCross {};
  };

  allowUnfree = true;
}
