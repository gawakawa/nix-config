{ config, lib, pkgs,  ... }:
let
  isLinux = builtins.currentSystem == "x86_64-linux";
  isDarwin = builtins.currentSystem == "aarch64-darwin";
in
{
  home = {
    enableNixpkgsReleaseCheck = true;
    stateVersion = "24.11";
    packages = with pkgs; 
      # 共通パッケージ
      [
        curl
      ] ++
      # Darwin特有のパッケージ
      (if isDarwin then [
        vscode
        idris2
      ] else []);
  };
  programs.home-manager.enable = true;

  imports = [
    ./programs/zsh.nix
    ./programs/direnv.nix
    ./programs/git.nix
    ./programs/wezterm.nix
    ./programs/neovim.nix
    ./programs/starship.nix
  ];
}