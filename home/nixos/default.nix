{ ... }:
{
  home = {
    enableNixpkgsReleaseCheck = true;
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;

  imports = [ ../../profiles/home ] ++ (import ../../lib).importSubdirs ./.;
}
