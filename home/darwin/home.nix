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
    ../../profiles/home/zsh
    ../../profiles/home/direnv
    ../../profiles/home/git
    ../../profiles/home/gpg
    ../../profiles/home/wezterm
    ../../profiles/home/starship
    ../../profiles/home/claude
  ];
}
