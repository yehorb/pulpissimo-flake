{
  fetchFromGitHub,
  pkgs,
  ...
}:

let
  # Older versions of pulp-platform projects fail to build under GCC 10/11
  stdenv = pkgs.gcc9CcacheStdenv;
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
  nativeBuildInputs = with pkgs; [
    curl
    libmpc
    mpfr
    gmp
    bison
    flex
    texinfo
    gperf
    libtool
    patchutils
    bc
    isl # riscv-gcc dependency
  ];
  hardeningDisable = [ "all" ];
}
