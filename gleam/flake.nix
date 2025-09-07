{
  description = "Hello, Gleam.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable?shallow=1";
  inputs.nix-gleam.url = "github:arnarg/nix-gleam?shallow=1";

  outputs =
    { nixpkgs, nix-gleam, ... }:
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
          overlays = [
            nix-gleam.overlays.default
          ];
        };

        nativeBuildInputs = [
          pkgs.gleam
          pkgs.erlang
          # pkgs.nodejs_slim
        ];
        buildInputs = [ ];
      in
      {
        devShells.default = pkgs.mkShellNoCC {
          inherit nativeBuildInputs buildInputs;
        };

        packages.default = pkgs.buildGleamApplication {
          inherit buildInputs;
          src = pkgs.lib.cleanSource ./.;
        };
      }
    );
}
