{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "bender";
  version = "0.28-unstable-2025-04-17";

  src = fetchFromGitHub {
    owner = "pulp-platform";
    repo = pname;
    rev = "f2721a9ff6be49c49c3c73920cdaf053194ea0c0";
    hash = "sha256-0jSBEicECK3YI2AFlSy+ALQ5SO0/B8hfqeQByvrlYYw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-m8PuwSA7+Zk1i4hy4eco9V1R02/XGpC6RwJxySoqgo8=";

  meta = {
    description = "A dependency management tool for hardware design projects";
    homepage = "https://github.com/pulp-platform/bender";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "bender";
  };
}
