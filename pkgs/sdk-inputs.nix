{
  pkgs,
  python311,
  pulp-riscv-gnu-toolchain,
  pulpissimo,
}:

with pkgs;
[
  git
  # the last version of Python that has the `imp` module
  (python311.withPackages (
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
  ))
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
]
