{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Minimal extra packages for initial testing
  extraPackages = with pkgs; [
    # Basic tools
    ripgrep # for telescope (added later)
    fd # for telescope (added later)
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
