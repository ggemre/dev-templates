{
  description = "Hello, Rust.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      eachSystem =
        with nixpkgs.lib;
        f: foldAttrs mergeAttrs { } (map (s: mapAttrs (_: v: { ${s} = v; }) (f s)) systems);
    in
    eachSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        cargoToml = (builtins.fromTOML (builtins.readFile ./Cargo.toml));
        pname = cargoToml.package.name;
        version = cargoToml.package.version;
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.cargo
          ];

          shellHook = ''
            export CARGO_HOME="$PWD/.cargo"

            if [ ! -f "Cargo.lock" ]; then
              echo "Generating lockfile"
              cargo generate-lockfile
            fi
          '';
        };

        packages.default = pkgs.rustPlatform.buildRustPackage {
          inherit pname version;

          src = pkgs.lib.cleanSource ./.;
          cargoLock.lockFile = ./Cargo.lock;

          nativeBuildInputs = [];
          buildInputs = [];
        };
      }
    );
}
