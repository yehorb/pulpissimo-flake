{
  description = "PULPissimo is the microcontroller architecture of the more recent PULP chips";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
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
      python = pkgs.callPackage ./pkgs/python.nix {
        # the last version of Python that has the `imp` module
        python = pkgs.python311;
        semver2-pkg = "${nixpkgs-semver2.outPath}/pkgs/development/python-modules/semver";
      };
    in
    {
      packages.${system} = {
        inherit pulp-riscv-gnu-toolchain python;
        default = pulp-riscv-gnu-toolchain;
      };

      devShells.${system}.default = (pkgs.mkShell.override { stdenv = pkgs.gcc9CcacheStdenv; }) {
        inputsFrom = [ self.packages.${system}.default ];

        buildInputs = pkgs.callPackage ./pkgs/shell-inputs.nix { inherit python; };
        hardeningDisable = [ "all" ];

        NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];

        packages = with pkgs; [ direnv ];

        env = {
          # required environment variable
          PULP_RISCV_GCC_TOOLCHAIN = pulp-riscv-gnu-toolchain;
          # purely formal check in build script
          # removes the lsb-core dependency
          PULP_ARTIFACTORY_DISTRIB = "Ubuntu_14";
        };

        # $system env var messes with the pulp-sdk build process
        shellHook = ''
          eval "$(direnv hook bash)"
          unset system
          export PS1="(pulpissimo) $PS1"
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
