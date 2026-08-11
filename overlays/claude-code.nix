# nixpkgs-master から claude-code を取得するオーバーレイ
# inputs は flakes/lib/hosts.nix から渡される
{ inputs, system }:
_: _:
let
  pkgsMaster = import inputs.nixpkgs-master {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  inherit (pkgsMaster) claude-code;
}
