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
