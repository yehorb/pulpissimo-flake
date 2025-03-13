{
  description = "PULPissimo is the microcontroller architecture of the more recent PULP chips";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          # Older versions of pulp-platform projects fail to build under GCC 10/11
          replaceStdenv = ({ pkgs }: pkgs.gcc9Stdenv);
        };
      };
    in
    {
      packages.${system}.default = pkgs.callPackage ./default.nix { };
    };
}
