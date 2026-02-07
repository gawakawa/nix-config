{
  pkgs,
  lib,
  self,
  ...
}:
{
  imports = [
    ../../profiles/hosts/packages.nix
  ];

  ids.gids.nixbld = 350;

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

  nix = {
    enable = true;
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      experimental-features = "nix-command flakes";
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://gawakawa.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "gawakawa.cachix.org-1:NVSPP7gCC7cr4U7eWhK3MlDGmbU5YkdHqW6+r7oz17c="
      ];
      trusted-users = [
        "iota"
        "_github-runner"
      ];
    };
    gc = {
      automatic = true;
      interval = {
        Day = 1;
      };
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      interval = {
        Day = 1;
      };
    };
  };

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

  # Disable sleep for self-hosted runner
  power.sleep.computer = "never";

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
      "google-chrome" # nixpkgs version is marked insecure on Darwin
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

  # GitHub Actions self-hosted runners
  services.github-runners =
    lib.genAttrs
      [
        "flake-templates"
        "nix-config"
      ]
      (repoName: {
        enable = true;
        name = "macmini-${repoName}";
        url = "https://github.com/gawakawa/${repoName}";
        tokenFile = "/var/lib/github-runners/token";
        replace = true;
        extraPackages = with pkgs; [
          cachix
          nix
        ];
      });
}
