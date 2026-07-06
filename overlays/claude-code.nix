# nixpkgs-master から claude-code を取得するオーバーレイ
# inputs は flakes/lib/hosts.nix から渡される
{ inputs, system }:
final: _:
let
  pkgsMaster = import inputs.nixpkgs-master {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  inherit (pkgsMaster) claude-code;

  # Some Claude Code plugins (e.g. ponytail) shell out to `node` in their
  # hooks. Wrap it separately so plain `claude-code` (used as a system
  # package) doesn't gain a global `node` dependency.
  claude-code-with-node = final.symlinkJoin {
    name = "claude-code-with-node";
    paths = [ final.claude-code ];
    nativeBuildInputs = [ final.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude --prefix PATH : ${final.lib.makeBinPath [ final.nodejs ]}
    '';
  };
}
