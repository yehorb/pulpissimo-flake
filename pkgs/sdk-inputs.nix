{
  pkgs,
  semver2-path,
}:

let
  # the last version of Python that has the `imp` module
  python = pkgs.python311.withPackages (
    pythonPkgs:
    let
      semver2 = (pythonPkgs.callPackage semver2-path { }).overridePythonAttrs {
        doCheck = false;
      };
    in
    (with pythonPkgs; [
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
    ])
    ++ [ semver2 ]
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
