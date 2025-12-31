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

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks-nix.flakeModule
      ];

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        let
          mcpConfig = inputs.mcp-servers-nix.lib.mkConfig pkgs {
            programs.nixos.enable = true;
          };
        in
        {
          packages.mcp-config = mcpConfig;

          pre-commit.settings.hooks = {
            treefmt.enable = true;
            statix = {
              enable = true;
              settings.ignore = [ "linux/hardware-configuration.nix" ];
            };
            deadnix = {
              enable = true;
              settings.exclude = [ "linux/hardware-configuration.nix" ];
            };
            selene.enable = true;
          };

          devShells.default = pkgs.mkShell {
            shellHook = ''
              ${config.pre-commit.shellHook}
              cat ${mcpConfig} > .mcp.json
              echo "Generated .mcp.json"
            '';
            packages = config.pre-commit.settings.enabledPackages;
          };

          treefmt = {
            programs.nixfmt = {
              enable = true;
              includes = [ "*.nix" ];
            };
            programs.stylua = {
              enable = true;
              includes = [ "*.lua" ];
            };
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
            inherit (inputs) self nixpkgs;
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
            inherit (inputs) self nixpkgs;
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
