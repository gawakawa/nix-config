{ pkgs, config, ... }:
let
  myLib = import ../../../lib;
in
{
  home.packages = [ pkgs.cachix ];

  systemd.user.services.cachix-watch-store = {
    Unit = {
      Description = "Cachix Watch Store";
      After = [
        "network-online.target"
        "gpg-agent.socket"
      ];
      Requires = [ "gpg-agent.socket" ];
    };
    Service = {
      Environment = [ "GNUPGHOME=${config.home.homeDirectory}/.gnupg" ];
      ExecStart = "${myLib.mkCachixWatchStore pkgs}";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
