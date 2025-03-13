{
  gcc9Stdenv,
  fetchFromGitHub,
  curl,
  flex,
  bison,
  texinfo,
  fetchurl,
  ...
}:

let
  # Older versions of pulp-platform projects fail to build under GCC 10/11
  stdenv = gcc9Stdenv;
  gmp = fetchurl rec {
    pname = "gmp";
    version = "6.1.0";
    url = "ftp://gcc.gnu.org/pub/gcc/infrastructure/${pname}-${version}.tar.bz2";
    hash = "sha256-SYRJqZTv66UniFwQQFmTQnmV0/hrh2jYzfjZ3Xxrc+g=";
  };
in
stdenv.mkDerivation rec {
  pname = "pulp-riscv-gnu-toolchain";
  version = "1.0.16";
  src = fetchFromGitHub {
    owner = "pulp-platform";
    repo = "pulp-riscv-gnu-toolchain";
    tag = "v${version}";
    hash = "sha256-RSnzVGBH/zm2cHhkaDdg1aZKiClbx/iwM8olKsaw/Eo=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    curl
    flex
    bison
    texinfo
  ];
  env = {
    DISTDIR = "$out/distfiles";
  };
  preConfigure = ''
    mkdir -p $DISTDIR
    cp ${gmp} $DISTDIR
  '';
}
