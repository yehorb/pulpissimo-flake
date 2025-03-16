# pulpissimo-flake

Nix derivation for the PULPissimo project.

## Running pulp-training example

- `git clone -b v7.0.0 --depth=1 -- https://github.com/pulp-platform/pulpissimo.git pulp-platform/pulpissimo`
- Update Makefile to use vendored Bender
  - Replace `./bender` with `bender`
  - Remove contents of the `bender:` target
- `make checkout` - will use Bender to download IP cores and generate scripts
  - Resolve conflicts manually, always choosing newer version
- make pulp-sdk
- Running pulp-training examples fails win an error
- Looks like Bender does not really updates all IP cores
- ./update-ips and ./generate-scripts do not solve an error
- Looks like it was a vsim licensing issue
- No, I just forgot to `make build` the `pulpissimo` itself...
  - In pulpissimo directory

    ```bash
    make checkout
    make pulp-sdk
    make build
    ```
- Bender.lock Makefile target created infinite recursion
  - Had to be removed
- Some files are still missing
- ./update-ips and ./generate-scripts did the job, `usnet BENDER` did solve the issue
  - bender is not ready yet
- vsim compilation issue
- Removing ccache from shell environment solved the issue
  - Looks like vsim asks a compiler to use libraries bundled with vsim, and they are a bit outdated
  - ccache does not work with vsim libraries
  - Recompiling current version of ccache with gcc9Stdenv does not work
  - Maybe I can use the older ccache version, but for now it can be removed
