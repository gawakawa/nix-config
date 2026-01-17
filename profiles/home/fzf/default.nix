{ pkgs, ... }:
{
  home.packages = [ pkgs.fd ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # fd を使用して高速なファイル検索（.gitignore を尊重）
    defaultCommand = "fd --type f --hidden --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
  };
}
