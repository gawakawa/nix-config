{ pkgs, osConfig, ... }:
let
  myLib = import ../../../lib;
in
{
  home.packages = [ pkgs.cachix ];

  systemd.user.services.cachix-watch-store = {
    # Retry indefinitely (push depends on network being up).
    Unit = {
      Description = "Cachix Watch Store";
      StartLimitIntervalSec = 0;
    };
    Service = {
      # sops-nix doesn't restart --user units on token rotate; restart manually.
      ExecStart = "${myLib.mkCachixWatchStore pkgs "< ${osConfig.sops.secrets.cachix-auth-token.path}"}";
      Restart = "on-failure";
      RestartSec = 10;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
