{
  inputs,
  ...
}:
{
  perSystem =
    {
      config,
      pkgs,
      system,
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
          };
    in
    {

      packages.mcp-config = mcpConfig;

      devShells.default = pkgs.mkShell {
        shellHook = ''
          ${config.pre-commit.shellHook}
          cat ${mcpConfig} > .mcp.json
          echo "Generated .mcp.json"
        '';
        packages = config.pre-commit.settings.enabledPackages;
      };
    };
}
