{ pkgs, ... }:
{
  home.packages = [ pkgs.fd ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Use fd for fast file search (respects .gitignore)
    defaultCommand = "fd --type f --hidden --exclude .git";
    fileWidget.command = "fd --type f --hidden --exclude .git";
    changeDirWidget.command = "fd --type d --hidden --exclude .git";
  };
}
