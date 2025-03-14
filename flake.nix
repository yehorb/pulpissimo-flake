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
        overlays = [ self.overlays.default ];
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
          ];
        };
        # Older versions of pulp-platform projects fail to build under GCC 10/11
        pulp-riscv-gnu-toolchain = pkgs.callPackage ./pkgs/pulp-riscv-gnu-toolchain.nix {
          stdenv = pkgs.gcc9CcacheStdenv;
        };
      };

      devShells.${system}.default = (pkgs.mkShell.override { stdenv = pkgs.gcc9CcacheStdenv; }) {
        inputsFrom = [ self.packages.${system}.default ];
      };

      overlays.default = final: prev: {
        ccacheWrapper = prev.ccacheWrapper.override {
          extraConfig = ''
            export CCACHE_COMPRESS=1
            export CCACHE_DIR="/nix/var/cache/ccache"
            export CCACHE_UMASK=007
            if [ ! -d "$CCACHE_DIR" ]; then
              echo "====="
              echo "Directory '$CCACHE_DIR' does not exist"
              echo "Please create it with:"
              echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
              echo "  sudo chown root:nixbld '$CCACHE_DIR'"
              echo "====="
              exit 1
            fi
            if [ ! -w "$CCACHE_DIR" ]; then
              echo "====="
              echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
              echo "Please verify its access permissions"
              echo "====="
              exit 1
            fi
          '';
        };
        gcc9CcacheStdenv = final.ccacheStdenv.override { stdenv = prev.gcc9Stdenv; };
      };
    };
}
