{
  description = "Unified Nix configuration for NixOS and Darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
  {
    # NixOS configuration (x86_64-linux)
    # Build using: $ sudo nixos-rebuild switch --flake ".#nixos" --impure
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./configuration.nix 
        # home-manager
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "backup";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit (inputs) self nixpkgs; };
            users.iota = import ./linux/home.nix;
          };
        }
      ];
      
      specialArgs = { inherit (inputs) self nixpkgs; system = "x86_64-linux"; };
    };

    # Darwin configuration (aarch64-darwin)
    # Build using: $ darwin-rebuild build --flake ".#mac" --impure
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ 
        ./configuration.nix 
        # home-manager
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            backupFileExtension = "backup";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit (inputs) self nixpkgs; };
            users.iota = import ./darwin/home.nix;
          };
        }
      ];
      
      specialArgs = { inherit (inputs) self nixpkgs; system = "aarch64-darwin"; };
    };

    # Expose the package sets, including overlays, for convenience.
    nixosPackages = self.nixosConfigurations."nixos".pkgs;
    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}