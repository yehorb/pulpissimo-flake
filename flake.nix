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
        overlays = [
          self.overlays.ccache
          self.overlays.default
        ];
        config = { };
      };
    in
    {
      packages.${system} = rec {
        default = pkgs.symlinkJoin {
          pname = "pulpissimo";
          version = "7.0.0";
          paths = [
            pulp-riscv-gnu-toolchain
            pulpissimo
          ];
        };
        # Older versions of pulp-platform projects fail to build under GCC 10/11
        pulp-riscv-gnu-toolchain = pkgs.callPackage ./pkgs/pulp-riscv-gnu-toolchain.nix {
          stdenv = pkgs.gcc9CcacheStdenv;
        };
        pulpissimo = pkgs.callPackage ./pkgs/pulpissimo.nix { };
      };

      devShells.${system}.default = (pkgs.mkShell.override { stdenv = pkgs.gcc9CcacheStdenv; }) {
        inputsFrom = [ self.packages.${system}.default ];
      };

      overlays = {
        ccache = import ./overlays/ccache.nix;
        default = final: prev: {
          gcc9CcacheStdenv = final.ccacheStdenv.override { stdenv = prev.gcc9Stdenv; };
        };
      };
    };
}
