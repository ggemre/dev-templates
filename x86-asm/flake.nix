{
  description = "Hello, x86_64 Assembly!";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable?shallow=1";

  outputs = { self, nixpkgs }: let
    systems = [ "x86_64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    packages = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        default = pkgs.stdenv.mkDerivation {
          pname = "hello-asm";
          version = "0.1.0";

          src = ./.;

          buildInputs = [ pkgs.nasm ];

          # Two-step build: assemble, then link
          buildPhase = ''
            nasm -f elf64 main.asm -o main.o
            ld -o main main.o
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp main $out/bin/
          '';
        };
      });

    devShells = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        default = pkgs.mkShell {
          packages = [ pkgs.nasm pkgs.binutils ];
        };
      });
  };
}

