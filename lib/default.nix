{
  importSubdirs =
    dir:
    map (n: dir + "/${n}") (
      builtins.filter (n: n != "default.nix") (builtins.attrNames (builtins.readDir dir))
    );

  mkCachixWatchStore =
    pkgs:
    pkgs.writeShellScript "cachix-watch-store" ''
      export CACHIX_AUTH_TOKEN="$(${pkgs.pass}/bin/pass show cachix/auth-token)"
      exec ${pkgs.cachix}/bin/cachix watch-store gawakawa
    '';
}
