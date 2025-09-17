{
  description = "Hello, Zig.";

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
          pkgs.zig
        ];
        buildInputs = [ ];
      in
      {
        devShells.default = pkgs.mkShell {
          inherit nativeBuildInputs buildInputs;
          packages = [
            pkgs.zls
            # pkgs.zon2nix
          ];
        };

        packages.default = pkgs.stdenv.mkDerivation {
          # Keep consistent with build.zig
          pname = "hello-zig";
          version = "0.0.0";
          src = pkgs.lib.cleanSource ./.;

          # For zig dependencies. (Make sure to generate deps.nix with zon2nix).
          # postPatch = ''
          #   ln -s ${pkgs.callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
          # '';

          nativeBuildInputs = nativeBuildInputs ++ [
            pkgs.zig.hook
          ];
          inherit buildInputs;
        };
      }
    );
}
