{
  fetchFromGitHub,
  pulp-riscv-gnu-toolchain,
  pulpissimo,
}:

rec {
  pname = "pulp-sdk";
  version = "2019.12.06";
  src = fetchFromGitHub {
    owner = "pulp-platform";
    repo = "pulp-sdk";
    tag = "${version}";
    hash = "sha256-VGwIejkBovTfvl4L75l9b+ao7Wjb+Mq9XxGRd1tggho=";
    fetchSubmodules = true;
  };
  PULP_RISCV_GCC_TOOLCHAIN = pulp-riscv-gnu-toolchain;
  VSIM_PATH = "${pulpissimo}/sim";
  # purely formal check in build script
  # removes the lsb-core dependency
  PULP_ARTIFACTORY_DISTRIB = "Ubuntu_14";
}
