{
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  pyyaml,
  semver_2_13,
}:

buildPythonPackage {
  pname = "ipstools";
  version = "unstable-2021-04-27";

  src = fetchFromGitHub {
    owner = "pulp-platform";
    repo = "IPApproX";
    rev = "6b0bbc917e6be883bdb5fcc1765da59563b46d2e";
    hash = "sha256-9EjddW+zbP8jPGpySVwgPnEYcp+++Kxp/08puU9l8SE=";
  };

  dependencies = [
    pyyaml
    semver_2_13
  ];

  pythonImportsCheck = [ "ipstools" ];
}
