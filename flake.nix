{
  description = "Templates for numerous development flakes.";
  outputs = _: {
    templates = {
      python = {
        path = ./python;
        description = "Python development environment.";
      };
      zig = {
        path = ./zig;
        description = "Zig development environment.";
      };
    };
  };
}
