{ config, ... }:
{
  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/projects/github.com/gawakawa/nix-config";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 30d --keep 3";
    };
  };
}
