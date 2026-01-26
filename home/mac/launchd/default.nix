{ pkgs, ... }:
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
    };
  };
}
