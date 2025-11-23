{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Core utilities
    bat
    fd
    jq
    pass
    tree
    unzip

    # Version control
    git
    gh
    gitmoji-cli

    # Development tools
    direnv
    starship
    treefmt

    # Terminal tools
    httpie
    neofetch
    rlwrap
    codex
    claude-code

    # Applications
    discord
    slack
    google-chrome
  ];
}
