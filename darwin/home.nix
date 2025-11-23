{
  config,
  lib,
  pkgs,
  nvim,
  system,
  ...
}:
{
  home = {
    enableNixpkgsReleaseCheck = true;
    stateVersion = "25.05";
    packages = with pkgs; [
      curl
      nvim.packages.${system}.default
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
    ../programs/wezterm
    ../programs/starship.nix
  ];
}
