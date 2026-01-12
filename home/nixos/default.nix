{
  pkgs,
  ...
}:
{
  home = {
    enableNixpkgsReleaseCheck = true;
    stateVersion = "25.05";
    packages = with pkgs; [
      curl
    ];

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };
  programs.home-manager.enable = true;

  imports = [ ../../profiles/home ] ++ (import ../../lib).importSubdirs ./.;
}
