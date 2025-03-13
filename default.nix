{
  gcc9Stdenv,
  fetchFromGitHub,
  curl,
  flex,
  bison,
  texinfo,
  ...
}:

let
  # Older versions of pulp-platform projects fail to build under GCC 10/11
  stdenv = gcc9Stdenv;
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
}
