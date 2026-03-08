{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Core utilities
    bat
    curl
    eza
    fd
    jq
    ripgrep
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
    fastfetch
    rlwrap
    codex
    claude-code
  ];
}
