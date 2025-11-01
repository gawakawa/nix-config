{
  config,
  pkgs,
  lib,
  ...
}:

let
  extraPackages = with pkgs; [
    # For telescope
    ripgrep
    fd

    # For conform.nvim
    go
    golines
    gotools
    haskellPackages.fourmolu
    terraform
  ];

  neovimWrapper = pkgs.callPackage ./wrapper.nix {
    inherit extraPackages;
  };

in
{
  home.packages = [ neovimWrapper ];

  # Set up aliases
  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };
}
