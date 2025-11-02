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

    # For LSP servers
    clojure-lsp
    deno
    gopls
    haskell-language-server
    prisma-language-server
    nodePackages.purescript-language-server
    rust-analyzer
    ruff
    terraform-ls
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
