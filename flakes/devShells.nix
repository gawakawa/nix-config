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
              command = "${lib.getExe' pkgs.nodejs_24 "npx"}";
              args = [
                "-y"
                "chrome-devtools-mcp@latest"
                "--executablePath"
                "${lib.getExe pkgs.google-chrome}"
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
