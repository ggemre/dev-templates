{
  description = "Templates for numerous development flakes.";
  outputs = _: {
    templates = {
      gleam = {
        path = ./gleam;
        description = "Gleam development environment.";
      };
      python = {
        path = ./python;
        description = "Python development environment.";
      };
      python-pyproject= {
        path = ./python-pyproject;
        description = "Python PyProject development environment.";
      };
      zig = {
        path = ./zig;
        description = "Zig development environment.";
      };
      x86-asm = {
        path = ./x86-asm;
        description = "x86 assembly development environment.";
      };
      x86-asm-libc = {
        path = ./x86-asm-libc;
        description = "x86 assembly with external c libraries environment.";
      };
    };
  };
}
