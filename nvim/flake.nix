{
  description = "Neovim configuration with Nix";

  nixConfig = {
    extra-substituters = [ "https://gawakawa.cachix.org" ];
    extra-trusted-public-keys = [
      "gawakawa.cachix.org-1:lpOOgOfyO68izReEj8TMxjnNRlgUsk4lwJ2KAGF5Xso="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    purescript-overlay.url = "github:thomashoneyman/purescript-overlay";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
    vscode-lean4 = {
      url = "github:leanprover/vscode-lean4";
      flake = false;
    };
  };

  outputs =
    inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      inherit systems;

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ (import inputs.rust-overlay) ];
          };

          packages = {
            default =
              let
                plugins = import ./nix/plugins.nix { inherit pkgs; };
                ps-pkgs = inputs.purescript-overlay.packages.${system};
                treefmtPkgs = {
                  inherit (config.treefmt.programs)
                    oxfmt
                    fourmolu
                    gofmt
                    goimports
                    cabal-fmt
                    nixfmt
                    ruff-format
                    rustfmt
                    shfmt
                    terraform
                    ;
                };
                tools = import ./nix/tools.nix { inherit pkgs ps-pkgs treefmtPkgs; };
              in
              pkgs.callPackage ./nix/lib/make-neovim-wrapper.nix {
                inherit plugins tools;
                inherit (inputs) vscode-lean4;
              };

          };
        };
    };
}
