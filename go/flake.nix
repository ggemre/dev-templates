{
  description = "Hello, Go.";

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

        nativeBuildInputs = [
          pkgs.go
        ];
        buildInputs = [ ];
      in
      {
        devShells.default = pkgs.mkShell {
          inherit nativeBuildInputs buildInputs;
          packages = [
            pkgs.gopls
          ];
        };

        packages.default = pkgs.buildGoModule {
          pname = "hello-go";
          version = "0.0.0";
          src = pkgs.lib.cleanSource ./.;

          # Change to an empty string to calculate the correct hash, when needed.
          vendorHash = null;

          inherit buildInputs;
        };
      }
    );
}
