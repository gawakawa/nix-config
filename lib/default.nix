{
  importSubdirs =
    dir:
    map (n: dir + "/${n}") (
      builtins.filter (n: n != "default.nix") (builtins.attrNames (builtins.readDir dir))
    );

  mkCachixWatchStore =
    pkgs: getToken:
    pkgs.writeShellScript "cachix-watch-store" ''
      set -euo pipefail
      CACHIX_AUTH_TOKEN="$(${getToken})"
      [ -n "$CACHIX_AUTH_TOKEN" ]
      export CACHIX_AUTH_TOKEN
      exec ${pkgs.cachix}/bin/cachix watch-store gawakawa
    '';
}
