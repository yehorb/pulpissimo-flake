{
  pkgs,
  fetchFromGitHub,

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
      ipstools = pythonPkgs.buildPythonPackage {
        pname = "ipstools";
        version = "unstable-2021-04-27";

        src = fetchFromGitHub {
          owner = "pulp-platform";
          repo = "IPApproX";
          rev = "6b0bbc917e6be883bdb5fcc1765da59563b46d2e";
          hash = "sha256-9EjddW+zbP8jPGpySVwgPnEYcp+++Kxp/08puU9l8SE=";
        };

        dependencies = [
          semver2
          pythonPkgs.pyyaml
        ];

        pythonImportsCheck = [ "ipstools" ];
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
    ++ [
      semver2
      ipstools
    ]
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
