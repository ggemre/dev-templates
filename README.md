# Templates for Development Environments

This is a Nix flake that exposes numerous starter templates for languages and environments that I may want or need.

To get started with a template, create a directory then initialize the desired flake.

```sh
mkdir zig
cd zig
nix flake init -t github:ggemre/dev-templates#zig
```

Each development environment comes with a Nix flake to streamline building, running, and (sometimes) dependency management.

```sh
nix develop # Enter into a shell with the necessary tooling
nix build # Build the program locally
nix run # Build and run the program
```
