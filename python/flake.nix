{
  description = "Hello, Python.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable?shallow=1";

  outputs =
    { nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems f;

      # The version of Python to use
      version = "313";
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          python = pkgs."python${version}";
        in
        {
          default = pkgs.mkShellNoCC {
            venvDir = ".venv";

            postShellHook = ''
              	local venvVersion
              	venvVersion="$("$venvDir/bin/python" -c 'import platform; print(platform.python_version())')"

              	[[ "$venvVersion" == "${python.version}" ]] && return

              	cat <<EOF
                  Warning: Python version mismatch: [$venvVersion (venv)] != [${python.version}]
                           Delete '$venvDir' and reload to rebuild for version ${python.version}
                  EOF
            '';

            packages = [
              python.pkgs.venvShellHook
              python.pkgs.python-lsp-server
              python.pkgs.flake8


              # Other necessary packages
              # python.pkgs.numpy
            ];
          };
        }
      );
    };
}
