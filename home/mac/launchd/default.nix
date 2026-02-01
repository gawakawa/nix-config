{ pkgs, config, ... }:
let
  myLib = import ../../../lib;
in
{
  home.packages = [ pkgs.cachix ];

  launchd.agents.cachix-watch-store = {
    enable = true;
    config = {
      Label = "org.cachix.watch-store";
      Program = "${myLib.mkCachixWatchStore pkgs}";
      RunAtLoad = true;
      KeepAlive = true;
      EnvironmentVariables = {
        GNUPGHOME = "${config.home.homeDirectory}/.gnupg";
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
      };
    };
  };
}
