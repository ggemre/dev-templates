{
  description = "Hello, x86_64 Assembly!";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable?shallow=1";

  outputs =
    { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
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
          pkgs.nasm
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          inherit nativeBuildInputs;
        };

        packages.default = pkgs.stdenv.mkDerivation {
          inherit nativeBuildInputs;

          pname = "hello-asm";
          version = "0.0.0";

          src = pkgs.lib.cleanSource ./.;

          buildPhase = ''
            nasm -f elf64 main.asm -o main.o
            ld -o main main.o
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp main $out/bin/
          '';
        };
      }
    );
}
