{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Core utilities
    bat
    eza
    fd
    jq
    ripgrep
    pass
    tree
    unzip

    # Version control
    git
    gh
    gitmoji-cli

    # Development tools
    comma
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
