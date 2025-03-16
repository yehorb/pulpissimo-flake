{
  fetchFromGitHub,

  # python version to use
  python,

  # path to the semver-2.13.0 package (from older nixpkgs)
  semver2-pkg,
}:

python.withPackages (
  pythonPkgs:
  let
    semver2 = (pythonPkgs.callPackage semver2-pkg { }).overridePythonAttrs {
      doCheck = false;
    };
    ipstools = pythonPkgs.buildPythonPackage {
      pname = "ipstools";
      version = "unstable-2021-04-27";

      src = fetchFromGitHub {
        owner = "pulp-platform";
        repo = "IPApproX";
        rev = "6b0bbc917e6be883bdb5fcc1765da59563b46d2e";
        hash = "sha256-9EjddW+zbP8jPGpySVwgPnEYcp+++Kxp/08puU9l8SE=";
      };

      dependencies = [
        semver2
        pythonPkgs.pyyaml
      ];

      pythonImportsCheck = [ "ipstools" ];
    };
  in
  (with pythonPkgs; [
    dohq-artifactory
    twisted
    prettytable
    sqlalchemy
    pyelftools
    openpyxl
    xlsxwriter
    pyyaml
    numpy
    configparser
    pyvcd
    sphinx
  ])
  ++ [
    semver2
    ipstools
  ]
)
