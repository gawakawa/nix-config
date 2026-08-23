{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        shellHook = config.pre-commit.shellHook;
        packages = config.pre-commit.settings.enabledPackages;
      };
    };
}
