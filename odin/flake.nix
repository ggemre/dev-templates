{
  description = "Hello, Odin.";

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

      pname = "hello-odin";
    in
    eachSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        nativeBuildInputs = [
          pkgs.odin
        ];
        buildInputs = [ ];
      in
      {
        devShells.default = pkgs.mkShell {
          inherit nativeBuildInputs buildInputs;
          packages = [
            pkgs.ols
          ];
        };

        packages.default = pkgs.stdenv.mkDerivation {
          inherit pname;
          version = "0.0.0";
          src = pkgs.lib.cleanSource ./.;

          buildPhase = ''
            odin build src -out:${pname}
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp ${pname} $out/bin
          '';

          inherit nativeBuildInputs buildInputs;
        };
      }
    );
}
