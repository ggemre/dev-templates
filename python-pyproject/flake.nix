{
  description = "Hello, Python Application.";

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

      # The version of Python to use
      version = "313";
    in
    eachSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        python = pkgs."python${version}";

        nativeBuildInputs = [ ];
        buildInputs = [
          # python.pkgs.numpy
        ];

        pyprojectTOML = builtins.fromTOML (builtins.readFile ./pyproject.toml);
      in
      {
        devShells.default = pkgs.mkShellNoCC {
          inherit nativeBuildInputs buildInputs;
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
          ];
        };

        packages.default = python.pkgs.buildPythonPackage {
          inherit (pyprojectTOML.project) version;
          pname = pyprojectTOML.project.name;
          src = pkgs.lib.cleanSource ./.;
          propagatedBuildInputs = buildInputs;

          pyproject = true;
          build-system = [
            python.pkgs.setuptools
          ];
        };
      }
    );
}
