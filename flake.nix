{
  description = "Templates for numerous development flakes.";
  outputs = _: {
    templates = {
      gleam = {
        path = ./gleam;
        description = "Gleam development environment.";
      };
      python = {
        path = ./python/simple;
        description = "Python development environment.";
      };
      python-app = {
        path = ./python/app;
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
    };
  };
}
