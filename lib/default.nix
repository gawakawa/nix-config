{
  importSubdirs =
    dir:
    map (n: dir + "/${n}") (
      builtins.filter (n: n != "default.nix") (builtins.attrNames (builtins.readDir dir))
    );

  mkCachixWatchStore =
    pkgs: getToken:
    pkgs.writeShellScript "cachix-watch-store" ''
      export CACHIX_AUTH_TOKEN="$(${getToken})"
      exec ${pkgs.cachix}/bin/cachix watch-store gawakawa
    '';
}
