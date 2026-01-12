{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # GUI Applications
    discord
    slack
    google-chrome
  ];
}
