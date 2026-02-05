{ inputs, withSystem, ... }:
let
  Hosts = import ./lib/hosts.nix { inherit inputs; };
in
{
  flake = {
    # NixOS configuration (x86_64-linux)
    # Build using: $ sudo nixos-rebuild switch --flake ".#nixos" --impure
    nixosConfigurations.nixos = withSystem "x86_64-linux" (
      _:
      Hosts.mkNixos {
        system = "x86_64-linux";
        hostPath = ../hosts/nixos;
        username = "iota";
        homePath = ../home/nixos;
      }
    );

    # Darwin configuration (aarch64-darwin)
    # Build using: $ darwin-rebuild build --flake ".#mac" --impure
    darwinConfigurations.mac = withSystem "aarch64-darwin" (
      _:
      Hosts.mkDarwin {
        system = "aarch64-darwin";
        hostPath = ../hosts/mac;
        username = "iota";
        homePath = ../home/mac;
      }
    );

    # Expose the package sets, including overlays, for convenience.
    nixosPackages = inputs.self.nixosConfigurations.nixos.pkgs;
    darwinPackages = inputs.self.darwinConfigurations.mac.pkgs;
  };
}
