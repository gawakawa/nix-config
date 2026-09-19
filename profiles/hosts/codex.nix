{
  inputs,
  system,
  pkgs,
  ...
}:
let
  mcpPkgs = import inputs.mcp-servers-nix.inputs.nixpkgs { inherit system; };
  tomlFormat = pkgs.formats.toml { };
in
{
  environment.etc."codex/config.toml".source = tomlFormat.generate "codex-config.toml" {
    model_reasoning_effort = "high";
    plan_mode_reasoning_effort = "xhigh";
    approval_policy = "on-request";
    approvals_reviewer = "auto_review";
    sandbox_mode = "workspace-write";
    mcp_servers.nixos = {
      command = "${mcpPkgs.mcp-nixos}/bin/mcp-nixos";
      args = [ ];
    };
  };
}
