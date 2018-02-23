let 
  pythonPackageOverrides = {fetchurl}: self: super: with super; rec {
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
  };
in {
  packageOverrides = pkgs: with pkgs; rec {
    python3Setup = python35.withPackages (ps: with ps; [ numpy scipy ]);
    python2Setup = python2.buildEnv.override {
      extraLibs = with python2.pkgs; [ numpy (matplotlib.override {enableGtk2 = true;}) scipy ];
      ignoreCollisions = true;
    };
      #let python = python2.override { packageOverrides = callPackage pythonPackageOverrides {}; };
      #in python.buildEnv.override {
      #  extraLibs = with python.pkgs; [ notebook pandas matplotlib scikitlearn ipykernel pymorphy2 mmh3 protobuf3_2 ];
      #  ignoreCollisions = true;
      #};
    texliveSetup = texlive.combine {
      inherit (texlive) scheme-basic collection-langcyrillic collection-langgerman collection-fontsrecommended metafont listings caption adjustbox xkeyval upquote collectbox ucs fancyvrb booktabs ulem extsizes csquotes tabu varwidth floatrow algorithms algorithmicx enumitem setspace biber biblatex iftex lastpage totcount longfigure chngcntr titlesec paratype logreq xstring biblatex-gost was pgf ms filecontents;
    };
    haskellSetup = ghc; #haskellPackages.ghcWithPackages (p: with p; [ ]);
    #pulse-secure = callPackage ./pulse-secure.nix {};
    soxMp3 = sox.override { enableLame = true; };
    wine64 = with import <nixos_unstable> {}; winePackages.unstable.override { wineBuild = "wine64"; };
    wine32 = with import <nixos_unstable> {}; winePackages.unstable;
  };
  allowUnfree = true;
}
