{
  pkgs,
  self,
  ...
}:
{
  imports = [
    ../../profiles/hosts/packages.nix
  ];

  fonts = {
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code

      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.noto
    ];
  };

  # Determinate Nix requires nix.enable = false
  nix.enable = false;

  programs.zsh.enable = true;

  users.users.iota = {
    name = "iota";
    home = "/Users/iota";
  };

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 4;
    primaryUser = "iota";
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    taps = [ ];
    brews = [
      "gnu-time"
      "mas"
    ];
    casks = [
      "amethyst"
      "claude"
    ];
    masApps = {
      "LINE" = 539883307;
      "Goodnotes 6" = 1444383602;
      "Kindle" = 302584613;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };

  # Darwin-specific packages
  environment.systemPackages = with pkgs; [
    qemu
  ];
}
