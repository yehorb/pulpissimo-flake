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
  externalInputs = {
    gmp = fetchurl rec {
      pname = "gmp";
      version = "6.1.0";
      url = "ftp://gcc.gnu.org/pub/gcc/infrastructure/${pname}-${version}.tar.bz2";
      hash = "sha256-SYRJqZTv66UniFwQQFmTQnmV0/hrh2jYzfjZ3Xxrc+g=";
    };
    mpfr = fetchurl rec {
      pname = "mpfr";
      version = "3.1.4";
      url = "ftp://gcc.gnu.org/pub/gcc/infrastructure/${pname}-${version}.tar.bz2";
      hash = "sha256-0xA6gM2tJAftWB82GMS+0E4MktHPdxpl6tZizDl/d3U=";
    };
    mpc = fetchurl rec {
      pname = "mpc";
      version = "1.0.3";
      url = "ftp://gcc.gnu.org/pub/gcc/infrastructure/${pname}-${version}.tar.gz";
      hash = "sha256-YX3sxuoJiJ+wjt4zCRegCxaAm424jCnDG/u0nL+I7MM=";
    };
    isl = fetchurl rec {
      pname = "isl";
      version = "0.16.1";
      url = "ftp://gcc.gnu.org/pub/gcc/infrastructure/${pname}-${version}.tar.bz2";
      hash = "sha256-QSU4u2XHmayY4X6M/NrLslelc2Ks+q/yVLD8rpcBJtI=";
    };
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
  # copy each externalInput derivation into sourceRoot using the url base name
  postUnpack = builtins.concatStrings builtins.map (
    input: "cp ${input} $sourceRoot/riscv-gcc/${builtins.baseNameOf input}"
  ) (builtins.attrValues externalInputs);
}
