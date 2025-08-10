{
  config,
  pkgs,
  lib,
  ...
}:
let
  isLinux = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
  isDarwin = pkgs.stdenv.hostPlatform.system == "aarch64-darwin";
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

  };

  # Linux特有の設定ファイルコピー
  home.file =
    if isLinux then
      {
        ".config/nvim" = {
          source = ../nvim;
          recursive = true;
        };

        # Exclude lazy-lock.json from being managed
        ".config/nvim/lazy-lock.json".enable = false;
      }
    else if isDarwin then
      {
        # Darwin特有のシンボリックリンク作成
        ".config/nvim" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-config/nvim";
        };
      }
    else
      { };
}
