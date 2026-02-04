{
  pkgs,
  ps-pkgs,
  treefmtPkgs,
}:

let
  telescope = with pkgs; [
    fd
    ripgrep
  ];

  lsp = with pkgs; [
    asm-lsp
    bash-language-server
    clang-tools
    clojure-lsp
    deno
    gopls
    lua-language-server
    prisma-language-server
    ps-pkgs.purescript-language-server
    ruff
    rust-analyzer
    (callPackage ./pkgs/rustowl { })
    terraform-ls
  ];

  formatters =
    (with treefmtPkgs; [
      oxfmt.package
      fourmolu.package
      gofmt.package
      goimports.package
      cabal-fmt.package
      nixfmt.package
      ruff-format.package
      rustfmt.package
      shfmt.package
      terraform.package
    ])
    ++ [ ps-pkgs.purs-tidy ];

  linters = with pkgs; [
    actionlint
    deadnix
    markdownlint-cli2
    oxlint
    selene
    shellcheck
    statix
    stylelint
    textlint
    tflint
  ];
in
pkgs.lib.unique (telescope ++ lsp ++ formatters ++ linters)
