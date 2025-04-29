{
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  # dependencies
  bc,
  bison,
  curl,
  flex,
  gmp,
  gperf,
  isl,
  libmpc,
  libtool,
  mpfr,
  patchutils,
  texinfo,
}:

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
  patches = [
    (fetchpatch {
      url = "https://github.com/pulp-platform/pulp-riscv-gcc/commit/a084ea3722d5213059d068d6c4db5b815afddafe.patch";
      hash = "sha256-qVkSldLYlz1pekwcmUlaVS4Bu8Amx8vWvsAOZYdiVL4=";
      name = "fix-isl-0_20.patch";
    })
  ];
  patchFlags = [
    "-p1"
    "--directory"
    "riscv-gcc"
  ];
  nativeBuildInputs = [
    bc
    bison
    curl
    flex
    gmp
    gperf
    isl
    libmpc
    libtool
    mpfr
    patchutils
    texinfo
  ];
  configureFlags = [
    "--with-arch=rv32imc"
    "--with-cmodel=medlow"
    "--enable-multilib"
  ];
  # the codebase is not ready for hardening at all
  hardeningDisable = [ "all" ];
}
