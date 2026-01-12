{
  importSubdirs =
    dir:
    map (n: dir + "/${n}") (
      builtins.filter (n: n != "default.nix") (builtins.attrNames (builtins.readDir dir))
    );
}
