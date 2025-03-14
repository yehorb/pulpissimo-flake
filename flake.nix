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
      pulp-riscv-gnu-toolchain = pkgs.callPackage ./pkgs/pulp-riscv-gnu-toolchain.nix {
        # Older versions of pulp-platform projects fail to build under GCC 10/11
        stdenv = pkgs.gcc9CcacheStdenv;
      };
      pulpissimo = pkgs.callPackage ./pkgs/pulpissimo.nix { };
      pulp-sdk = pkgs.callPackage ./pkgs/pulp-sdk.nix { };
    in
    {
      packages.${system} = {
        inherit pulp-riscv-gnu-toolchain;
        default = pulp-riscv-gnu-toolchain;
      };

      devShells.${system}.default = (pkgs.mkShell.override { stdenv = pkgs.gcc9CcacheStdenv; }) {
        inputsFrom = [ self.packages.${system}.default ];

        buildInputs = pkgs.callPackage ./pkgs/sdk-inputs.nix { };
        hardeningDisable = [ "all" ];

        NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];

        # required environment variables
        PULP_RISCV_GCC_TOOLCHAIN = pulp-riscv-gnu-toolchain;
        VSIM_PATH = "$PULPISSIMO/sim";

        PULPISSIMO = pulpissimo.src;
        PULP_SDK = pulp-sdk.src;
        PULP_SDK_HOME = "$PULP_SDK/pkg/sdk/dev";

        # purely formal check in build script
        # removes the lsb-core dependency
        PULP_ARTIFACTORY_DISTRIB = "Ubuntu_14";

        # $system env var messes with the pulp-sdk build process
        shellHook = ''
          unset system

          source $PULP_SDK/configs/pulpissimo.sh
          source $PULP_SDK/configs/platform-rtl.sh

          export PS1="(pulp) $PS1"
        '';
      };

      overlays = {
        ccache = import ./overlays/ccache.nix;
        default = final: prev: {
          gcc9CcacheStdenv = final.ccacheStdenv.override { stdenv = prev.gcc9Stdenv; };
        };
      };
    };
}
