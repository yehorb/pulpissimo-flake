{
  description = "PULPissimo is the microcontroller architecture of the more recent PULP chips";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-semver_2_13.url = "github:nixos/nixpkgs?ref=92a955754d197a5161ab4c3ce5193b4c4eb1edcc";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-semver_2_13,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { };
        overlays = [ self.overlays.default ];
      };
      pulp-riscv-gnu-toolchain = pkgs.callPackage ./flake/legacyPackages/pulp-riscv-gnu-toolchain.nix {
        # Older versions of pulp-platform projects fail to build under GCC 10/11
        stdenv = pkgs.gcc9Stdenv;
      };
      bender = pkgs.callPackage ./flake/legacyPackages/bender.nix { };
      pulpissimo-python = pkgs.callPackage ./flake/legacyPackages/pulpissimo-python.nix {
        ipstools = ./flake/legacyPackages/python-modules/ipstools.nix;
        semver_2_13 = "${nixpkgs-semver_2_13.outPath}/pkgs/development/python-modules/semver";
      };
    in
    {
      packages.${system} = {
        inherit pulp-riscv-gnu-toolchain bender pulpissimo-python;
        inherit (pulpissimo-python.pkgs) ipstools semver;
        default = pulp-riscv-gnu-toolchain;
      };

      devShells.${system}.default = pkgs.callPackage ./flake/develop/default.nix {
        stdenv = pkgs.gcc9Stdenv;
      };

      overlays.default = final: prev: {
        inherit (self.packages.${system}) pulp-riscv-gnu-toolchain bender pulpissimo-python;
        scons = prev.scons.override { python3Packages = pulpissimo-python.pkgs; };
      };
    };
}
