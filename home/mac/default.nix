{
  pkgs,
  ...
}:
{
  nix.enable = false;

  home = {
    enableNixpkgsReleaseCheck = true;
    stateVersion = "25.05";
    packages = with pkgs; [
      curl

      # GUI Applications
      discord
      slack
      google-chrome
    ];

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };
  programs.home-manager.enable = true;

  imports = [ ../../profiles/home ] ++ (import ../../lib).importSubdirs ./.;
}
