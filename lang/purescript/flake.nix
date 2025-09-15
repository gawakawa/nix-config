{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    purescript-overlay = {
      url = "github:thomashoneyman/purescript-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      purescript-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ purescript-overlay.overlays.default ];
        };
      in
      {
        packages = {
          default = pkgs.hello; # your package here
        };

        devShells.default = pkgs.mkShell {
          name = "my-purescript-project";
          inputsFrom = builtins.attrValues self.packages;
          buildInputs = with pkgs; [
            purs
            spago-unstable
            purs-tidy
            purs-backend-es
            purescript-language-server
            nodejs_22
            esbuild
          ];
        };
      }
    );
}
