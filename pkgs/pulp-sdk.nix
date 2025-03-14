{
  stdenv,
  pkgs,
  fetchFromGitHub,
  pulp-riscv-gnu-toolchain,
  pulpissimo,
  ...
}:

let
  python = (
    # the last version of Python that has the `imp` module
    pkgs.python311.withPackages (
      pythonPkgs: with pythonPkgs; [
        dohq-artifactory
        twisted
        prettytable
        sqlalchemy
        pyelftools
        openpyxl
        xlsxwriter
        pyyaml
        numpy
        configparser
        pyvcd
      ]
    )
  );
  sdk-modules = pkgs.callPackage ./sdk-modules.nix { };
in
stdenv.mkDerivation rec {
  pname = "pulp-sdk";
  version = "2019.12.06";
  src = fetchFromGitHub {
    owner = "pulp-platform";
    repo = "pulp-sdk";
    tag = "${version}";
    hash = "sha256-VGwIejkBovTfvl4L75l9b+ao7Wjb+Mq9XxGRd1tggho=";
    fetchSubmodules = true;
  };
  buildInputs =
    with pkgs;
    [
      # Makefile tries to init submodules unconditionally, and fails if git is not found
      # this step is not needed, as we fetched submodules already
      # dummy git executable is enough to pass this build step
      (writeShellScriptBin "git" "")
      python
      texinfo
      gmp
      mpfr
      libmpc
      swig3
      libjpeg
      doxygen
      sphinx
      sox
      graphicsmagick
      SDL2
      (perl540.withPackages (perlPkgs: [ perlPkgs.Switch ]))
      libftdi1
      cmake
      (scons.overrideAttrs { setupHook = null; })
      libsndfile
    ]
    ++ [
      pulp-riscv-gnu-toolchain
      pulpissimo
    ];
  hardeningDisable = [ "all" ];

  preBuild = ''
    mkdir -p ./tools && cp -r ${sdk-modules."tools/runner"} ./tools/runner && chmod -R 775 ./tools/runner

    find . -type f -exec sed -i 's|^#!/usr/bin/env python3\(\.6\)\?$|#!${python}/bin/python|' {} +

    source configs/pulpissimo.sh
    source configs/platform-rtl.sh

    echo "====="
    echo "PULP_RISCV_GCC_TOOLCHAIN=$PULP_RISCV_GCC_TOOLCHAIN"
    echo "PULP_CURRENT_CONFIG=$PULP_CURRENT_CONFIG"
    echo "PULP_CURRENT_CONFIG_ARGS=$PULP_CURRENT_CONFIG_ARGS"
    echo "VSIM_PATH=$VSIM_PATH"
    echo "====="
  '';
  buildFlags = [
    "all"
    "env"
  ];

  PULP_RISCV_GCC_TOOLCHAIN = pulp-riscv-gnu-toolchain;
  VSIM_PATH = "${pulpissimo}/sim";
  # purely formal check in build script
  # removes the lsb-core dependency
  PULP_ARTIFACTORY_DISTRIB = "Ubuntu_14";
}
