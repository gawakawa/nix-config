{
  inputs,
  system,
  ...
}:
let
  mcpPkgs = import inputs.mcp-servers-nix.inputs.nixpkgs { inherit system; };
in
{
  programs.mcp.enable = true;
  programs.mcp.servers.nixos = {
    command = "${mcpPkgs.mcp-nixos}/bin/mcp-nixos";
    args = [ ];
  };
}
