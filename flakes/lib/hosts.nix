{ inputs }:
let
  localOverlays = import ../../overlays;
in
{
  mkNixos =
    {
      system,
      hostPath,
      username,
      homePath,
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        hostPath
        inputs.home-manager.nixosModules.home-manager
        (_: {
          nixpkgs.overlays = map (o: o { inherit inputs system; }) localOverlays;
        })
        {
          home-manager = {
            backupFileExtension = "backup";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs system;
              inherit (inputs) self nixpkgs;
            };
            users.${username} = import homePath;
          };
        }
      ];
      specialArgs = {
        inherit inputs system;
        inherit (inputs) self nixpkgs;
      };
    };

  mkDarwin =
    {
      system,
      hostPath,
      username,
      homePath,
    }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        inputs.mac-app-util.darwinModules.default
        hostPath
        inputs.home-manager.darwinModules.home-manager
        (_: {
          nixpkgs.overlays = map (o: o { inherit inputs system; }) localOverlays;
        })
        {
          home-manager = {
            backupFileExtension = "backup";
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [
              inputs.mac-app-util.homeManagerModules.default
            ];
            extraSpecialArgs = {
              inherit inputs system;
              inherit (inputs) self nixpkgs;
            };
            users.${username} = import homePath;
          };
        }
      ];
      specialArgs = {
        inherit inputs system;
        inherit (inputs) self nixpkgs;
      };
    };
}
