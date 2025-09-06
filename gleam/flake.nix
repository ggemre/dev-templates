{
  description = "Hello, Gleam.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable?shallow=1";
  inputs.nix-gleam.url = "github:arnarg/nix-gleam?shallow=1";

  outputs =
    { nixpkgs, nix-gleam, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems f;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          # Version of Beam to use
          beamVersion = "28";
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.gleam
              pkgs."beamMinimal${beamVersion}Packages".erlang

              # If you want javascript target
              # pkgs.nodejs_slim
            ];
          };
        }
      );

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              nix-gleam.overlays.default
            ];
          };
        in
        {
          default = pkgs.buildGleamApplication {
            erlangPackage = pkgs.erlang;
            rebar3Package = pkgs.rebar3;
            nativeBuildInputs = [];
            localPackages = [];
            src = ./.;
          };
        }
      );
    };
}
