{
  pkgs,
}:

let
  # the last version of Python that has the `imp` module
  python = (
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
        sphinx
      ]
    )
  );
in
with pkgs;
[
  git
  python
  texinfo
  gmp
  mpfr
  libmpc
  swig3
  libjpeg
  doxygen
  sox
  graphicsmagick
  SDL2
  (perl540.withPackages (perlPkgs: [ perlPkgs.Switch ]))
  libftdi1
  cmake
  ((scons.override { python3Packages = python.pkgs; }).overrideAttrs { setupHook = null; })
  libsndfile
]
