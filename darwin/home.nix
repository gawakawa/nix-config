{
  config,
  lib,
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
  };
  programs.home-manager.enable = true;

  imports = [
    ../programs/zsh.nix
    ../programs/direnv.nix
    ../programs/git.nix
    ../programs/wezterm.nix
    ../programs/neovim.nix
    ../programs/starship.nix
  ];
}
