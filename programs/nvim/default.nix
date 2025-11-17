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

    # For formatters (conform.nvim)
    nixfmt
    rustfmt
    nodePackages.purs-tidy
    # ruff (already included for LSP)
    biome
    gotools # provides goimports
    go # provides gofmt
    golines
    fourmolu
    haskellPackages.cabal-fmt
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
