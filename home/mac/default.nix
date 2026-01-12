{
  pkgs,
  ...
}:
{
  nix.enable = false;

  home = {
    enableNixpkgsReleaseCheck = true;
    stateVersion = "25.05";
    packages = with pkgs; [
      curl
    ];

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };
  programs.home-manager.enable = true;

  imports = [
    ../../profiles/home
  ]
  ++ map (n: ./${n}) (
    builtins.filter (n: n != "default.nix") (builtins.attrNames (builtins.readDir ./.))
  );
}
