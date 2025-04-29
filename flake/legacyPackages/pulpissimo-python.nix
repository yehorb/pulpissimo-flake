{
  # The last version of Python that has the `imp` module
  python311,

  ipstools,
  semver_2_13,
}:

let
  pulpissimo-python = python311.override {
    self = pulpissimo-python;
    packageOverrides = final: prev: {
      ipstools = final.callPackage ipstools { };
      semver_2_13 = (final.callPackage semver_2_13 { }).overridePythonAttrs { doCheck = false; };
    };
  };
in
pulpissimo-python
