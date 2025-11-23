{
  description = "Unified Nix configuration for NixOS and Darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        {
          treefmt = {
            programs.nixfmt.enable = true;
            programs.stylua.enable = true;
          };
        };

      flake = {
        # NixOS configuration (x86_64-linux)
        # Build using: $ sudo nixos-rebuild switch --flake ".#nixos" --impure
        nixosConfigurations."nixos" = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./linux/configuration.nix
            # home-manager
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                backupFileExtension = "backup";
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit (inputs) self nixpkgs;
                  system = "x86_64-linux";
                };
                users.iota = import ./linux/home.nix;
              };
            }
          ];

          specialArgs = {
            inherit inputs;
            self = inputs.self;
            nixpkgs = inputs.nixpkgs;
            system = "x86_64-linux";
          };
        };

        # Darwin configuration (aarch64-darwin)
        # Build using: $ darwin-rebuild build --flake ".#mac" --impure
        darwinConfigurations."mac" = inputs.nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/configuration.nix
            # home-manager
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager = {
                backupFileExtension = "backup";
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit (inputs) self nixpkgs;
                  system = "aarch64-darwin";
                };
                users.iota = import ./darwin/home.nix;
              };
            }
          ];

          specialArgs = {
            inherit inputs;
            self = inputs.self;
            nixpkgs = inputs.nixpkgs;
            system = "aarch64-darwin";
          };
        };

        # Expose the package sets, including overlays, for convenience.
        nixosPackages = inputs.self.nixosConfigurations."nixos".pkgs;
        darwinPackages = inputs.self.darwinConfigurations."mac".pkgs;
      };
    };

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
