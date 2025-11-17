{
  config,
  pkgs,
  lib,
  self,
  ...
}:
let
  extraPackages = with pkgs; [
    # For telescope
    ripgrep
    fd

    # For LSP servers
    asm-lsp
    clang-tools
    clojure-lsp
    deno
    gopls
    haskell-language-server
    prisma-language-server
    nodePackages.purescript-language-server
    rust-analyzer
    ruff
    terraform-ls

    # treefmt-nix wrapper for fast formatting
    self.packages.${pkgs.system}.treefmt-wrapper
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
