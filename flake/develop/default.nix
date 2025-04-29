{
  mkShell,
  stdenv,

  # dependencies
  bender,
  pulp-riscv-gnu-toolchain,
  pulpissimo-python,

  SDL2,
  cmake,
  doxygen,
  git,
  gmp,
  graphicsmagick,
  libftdi1,
  libjpeg,
  libmpc,
  libsndfile,
  mpfr,
  perl,
  scons,
  sox,
  swig,
  tcl,
  texinfo,
}:

(mkShell.override { inherit stdenv; }) {
  inputsFrom = [ pulp-riscv-gnu-toolchain ];
  packages =
    [
      bender
      pulp-riscv-gnu-toolchain
      (pulpissimo-python.withPackages (
        pythonPackages: with pythonPackages; [
          configparser
          dohq-artifactory
          ipstools
          numpy
          openpyxl
          prettytable
          pyelftools
          pyvcd
          pyyaml
          semver_2_13
          sphinx
          sqlalchemy
          twisted
          xlsxwriter
        ]
      ))
    ]
    ++ [
      git
      texinfo
      gmp
      mpfr
      libmpc
      swig
      libjpeg
      doxygen
      sox
      graphicsmagick
      SDL2
      (perl.withPackages (perlPkgs: [ perlPkgs.Switch ]))
      libftdi1
      cmake
      scons
      libsndfile
      tcl
    ];

  hardeningDisable = [ "all" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];
  env = {
    # required environment variable
    PULP_RISCV_GCC_TOOLCHAIN = pulp-riscv-gnu-toolchain;
    # purely formal check in build script
    # removes the lsb-core dependency
    PULP_ARTIFACTORY_DISTRIB = "Ubuntu_14";
  };

  # $system env var messes with the pulp-sdk build process
  shellHook = ''
    unset system
    export PS1="(pulpissimo) $PS1"
    export PULPISSIMO="$PWD/pulp-platform/pulpissimo"
    export BENDER=1
    export VSIM_FLAGS="-suppress vsim-3839,vsim-3837"
    source $PULPISSIMO/env/pulpissimo.sh
  '';
}
