{
  config,
  lib,
  pkgs,
  system,
  ...
}:
{
  nix.enable = false;

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

  imports = [
    ../programs/zsh.nix
    ../programs/direnv.nix
    ../programs/git.nix
    ../programs/gpg.nix
    ../programs/wezterm
    ../programs/starship.nix
  ];
}
