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
    ../../profiles/hm/zsh.nix
    ../../profiles/hm/direnv.nix
    ../../profiles/hm/git.nix
    ../../profiles/hm/gpg.nix
    ../../profiles/hm/wezterm
    ../../profiles/hm/starship.nix
    ../../profiles/hm/hyprland.nix
    ../../profiles/hm/waybar.nix
    ../../profiles/hm/claude
  ];
}
