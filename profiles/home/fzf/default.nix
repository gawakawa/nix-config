{ pkgs, ... }:
{
  home.packages = [ pkgs.fd ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Use fd for fast file search (respects .gitignore)
    defaultCommand = "fd --type f --hidden --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
  };
}
