{
  description = "Hello, x86_64 Assembly with External Libraries!";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable?shallow=1";

  outputs =
    { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];

      eachSystem =
        with nixpkgs.lib;
        f: foldAttrs mergeAttrs { } (map (s: mapAttrs (_: v: { ${s} = v; }) (f s)) systems);

      pname = "hello-asm-extern";
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
          inherit pname nativeBuildInputs;
          version = "0.0.0";

          src = pkgs.lib.cleanSource ./.;

          buildPhase = ''
            nasm -f elf64 main.asm -o main.o
            gcc main.o -o ${pname}
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp ${pname} $out/bin/
          '';
        };
      }
    );
}
