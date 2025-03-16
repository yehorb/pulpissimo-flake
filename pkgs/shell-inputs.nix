{
  # pulpissimo python environment
  python,

  # dependencies
  git,
  texinfo,
  gmp,
  mpfr,
  libmpc,
  swig3,
  libjpeg,
  doxygen,
  sox,
  graphicsmagick,
  SDL2,
  perl,
  libftdi1,
  cmake,
  scons,
  libsndfile,
}:

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
  (perl.withPackages (perlPkgs: [ perlPkgs.Switch ]))
  libftdi1
  cmake
  ((scons.override { python3Packages = python.pkgs; }).overrideAttrs { setupHook = null; })
  libsndfile
]
