_: {
  perSystem =
    { pkgs, ... }:
    {
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
        actionlint.enable = true;
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
    };
}
