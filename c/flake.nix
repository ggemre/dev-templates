{
  description = "Hello, C.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable?shallow=1";

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

        nativeBuildInputs = [];
        buildInputs = [];
      in
      {
        devShells.default = pkgs.mkShell {
          inherit nativeBuildInputs buildInputs;
          packages = [
            pkgs.libclang
          ];
        };

        packages.default = pkgs.stdenv.mkDerivation {
          # Keep consistent with Makefile
          pname = "hello-c";
          version = "0.0.0";
          src = pkgs.lib.cleanSource ./.;

          inherit buildInputs;
        };
      }
    );
}
