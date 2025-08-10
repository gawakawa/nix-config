{ config, pkgs, lib, ... }: 
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
    
    # Darwin特有の設定
    extraConfig = if isDarwin then ''
      " nvim設定ディレクトリを指定
      let g:nvim_config_dir = "${config.home.homeDirectory}/.config/nix-darwin/nvim"
      
      " runtimepathを設定
      let &runtimepath.=','.g:nvim_config_dir
      
      " init.luaをsource
      lua require("config.lazy")
    '' else "";
  };
  
  # Linux特有の設定ファイルコピー
  home.file = if isLinux then {
    ".config/nvim" = {
      source = ../nvim;
      recursive = true;
    };
    
    # Exclude lazy-lock.json from being managed
    ".config/nvim/lazy-lock.json".enable = false;
  } else {};
  
  # Darwin特有のシンボリックリンク作成
  home.activation = if isDarwin then {
    linkNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -d ${config.home.homeDirectory}/.config/nvim ]; then
        $DRY_RUN_CMD rm -rf ${config.home.homeDirectory}/.config/nvim
      fi
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.config
      $DRY_RUN_CMD ln -sf ${config.home.homeDirectory}/.config/nix-darwin/nvim ${config.home.homeDirectory}/.config/nvim
    '';
  } else {};
}