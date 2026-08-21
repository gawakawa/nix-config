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

  # vscode-uri percent-encodes `=` but neovim leaves it literal, so diagnostics
  # never match on gwq worktree paths. postInstall is skipped upstream (no runHook).
  purescript-language-server = ps-pkgs.purescript-language-server.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      substituteInPlace $out/node_modules/purescript-language-server/purescript-language-server.js \
        --replace-fail \
          'code2 === 126 || allowSlash && code2 === 47' \
          'code2 === 126 || code2 === 61 || allowSlash && code2 === 47'
    '';
  });

  lsp = with pkgs; [
    asm-lsp
    bash-language-server
    clang-tools
    clojure-lsp
    deno
    gopls
    lua-language-server
    ocamlPackages.ocaml-lsp
    prisma-language-server
    purescript-language-server
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
    ++ [
      ps-pkgs.purs-tidy
      pkgs.ocamlPackages.ocamlformat
    ];

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
