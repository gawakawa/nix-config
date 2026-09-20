{ pkgs, osConfig, ... }:
let
  myLib = import ../../../lib;
in
{
  home.packages = [ pkgs.cachix ];

  systemd.user.services.cachix-watch-store = {
    Unit.Description = "Cachix Watch Store";
    Service = {
      ExecStart = "${myLib.mkCachixWatchStore pkgs "${pkgs.coreutils}/bin/cat ${osConfig.sops.secrets.cachix-auth-token.path}"}";
      # sops-nix updates /run/secrets/cachix-auth-token on rotate but does not
      # restart systemd --user services (restartUnits only covers system
      # units) — restart this manually after rotating the token.
      Restart = "on-failure";
      RestartSec = 10;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
