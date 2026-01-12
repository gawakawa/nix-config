{
  pkgs,
  ...
}:
{
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
    ../../profiles/home/zsh.nix
    ../../profiles/home/direnv.nix
    ../../profiles/home/git.nix
    ../../profiles/home/gpg.nix
    ../../profiles/home/wezterm
    ../../profiles/home/starship.nix
    ../../profiles/home/hyprland.nix
    ../../profiles/home/waybar.nix
    ../../profiles/home/claude
  ];
}
