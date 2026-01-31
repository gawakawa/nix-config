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

    mac-app-util.url = "github:hraban/mac-app-util";
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
          system,
          lib,
          ...
        }:
        let
          mcpConfig =
            inputs.mcp-servers-nix.lib.mkConfig
              (import inputs.mcp-servers-nix.inputs.nixpkgs {
                inherit system;
              })
              {
                programs.nixos.enable = true;
                settings.servers.chrome-devtools = {
                  command = "${pkgs.lib.getExe' pkgs.nodejs_24 "npx"}";
                  args = [
                    "-y"
                    "chrome-devtools-mcp@latest"
                    "--executablePath"
                    "${pkgs.lib.getExe pkgs.google-chrome}"
                  ];
                  env = {
                    PATH = "${pkgs.nodejs_24}/bin:${pkgs.bash}/bin";
                  };
                };
              };
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "google-chrome" ];
          };

          packages.mcp-config = mcpConfig;

          pre-commit.settings.hooks = {
            treefmt.enable = true;
            statix = {
              enable = true;
              settings.ignore = [ "hosts/nixos/hardware-configuration.nix" ];
            };
            deadnix = {
              enable = true;
              settings.exclude = [ "hosts/nixos/hardware-configuration.nix" ];
            };
            selene.enable = true;
            shellcheck = {
              enable = true;
              excludes = [ "\\.envrc$" ];
            };
            workflow-timeout = {
              enable = true;
              name = "Check GitHub Workflows timeout-minutes";
              package = pkgs.check-jsonschema;
              entry = "${pkgs.check-jsonschema}/bin/check-jsonschema --builtin-schema github-workflows-require-timeout";
              files = "^\\.github/workflows/.*\\.ya?ml$";
            };
          };

          devShells.default = pkgs.mkShell {
            shellHook = ''
              ${config.pre-commit.shellHook}
              cat ${mcpConfig} > .mcp.json
              echo "Generated .mcp.json"
            '';
            packages = config.pre-commit.settings.enabledPackages;
          };

          treefmt.programs = {
            nixfmt = {
              enable = true;
              includes = [ "*.nix" ];
            };
            stylua = {
              enable = true;
              includes = [ "*.lua" ];
            };
            shfmt = {
              enable = true;
              includes = [ "*.sh" ];
            };
          };
        };

      flake = {
        # NixOS configuration (x86_64-linux)
        # Build using: $ sudo nixos-rebuild switch --flake ".#nixos" --impure
        nixosConfigurations."nixos" = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                backupFileExtension = "backup";
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                  inherit (inputs) self nixpkgs;
                  system = "x86_64-linux";
                };
                users.iota = import ./home/nixos;
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
            inputs.mac-app-util.darwinModules.default
            ./hosts/mac
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager = {
                backupFileExtension = "backup";
                useGlobalPkgs = true;
                useUserPackages = true;
                sharedModules = [
                  inputs.mac-app-util.homeManagerModules.default
                ];
                extraSpecialArgs = {
                  inherit inputs;
                  inherit (inputs) self nixpkgs;
                  system = "aarch64-darwin";
                };
                users.iota = import ./home/mac;
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
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://gawakawa.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "gawakawa.cachix.org-1:NVSPP7gCC7cr4U7eWhK3MlDGmbU5YkdHqW6+r7oz17c="
    ];
  };
}
