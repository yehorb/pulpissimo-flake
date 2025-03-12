{ pkgs, ... }:

# Older versions of pulp-platform projects fail to build under GCC 10/11
pkgs.gcc9Stdenv.mkDerivation {
  name = "pulp-riscv-gnu-toolchain";
  src = pkgs.fetchFromGitHub {
    owner = "pulp-platform";
    repo = "pulp-riscv-gnu-toolchain";
    tag = "v1.0.16";
    hash = "sha256-RSnzVGBH/zm2cHhkaDdg1aZKiClbx/iwM8olKsaw/Eo=";
    fetchSubmodules = true;
  };
}
