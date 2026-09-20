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
      Program = "${myLib.mkCachixWatchStore pkgs "${pkgs.pass}/bin/pass show cachix/auth-token"}";
      RunAtLoad = true;
      KeepAlive = true;
      EnvironmentVariables = {
        GNUPGHOME = "${config.home.homeDirectory}/.gnupg";
        PASSWORD_STORE_DIR = config.programs.password-store.settings.PASSWORD_STORE_DIR;
      };
    };
  };
}
