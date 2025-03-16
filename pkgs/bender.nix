{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "bender";
  version = "unstable-2025-01-31";

  src = fetchFromGitHub {
    owner = "pulp-platform";
    repo = pname;
    rev = "975264f4054d02c368ed1f5a974b55f665d6f82f";
    hash = "sha256-wa3vM7EmFV29Fdp3Od/L/HaekFHjZapRdfkVKbRf+WE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4x9vnKCJ2M9Sp/wPIbXv+IJQoSF2YIAsUqoSmH0pwA4=";

  meta = {
    description = "A dependency management tool for hardware design projects";
    homepage = "https://github.com/pulp-platform/bender";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
}
