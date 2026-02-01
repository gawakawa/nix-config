{
  pkgs,
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
      jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.noto
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK JP"
          "Noto Color Emoji"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  nix = {
    enable = true;
    package = pkgs.nix;
    settings = {
      # Binary Cache for haskell.nix
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
      substituters = [
        "https://cache.iog.io"
      ];
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.iota = {
      isNormalUser = true;
      description = "iota";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        #  thunderbird
      ];
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  time = {
    timeZone = "Asia/Tokyo";
  };

  i18n = {
    defaultLocale = "ja_JP.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ja_JP.UTF-8";
      LC_IDENTIFICATION = "ja_JP.UTF-8";
      LC_MEASUREMENT = "ja_JP.UTF-8";
      LC_MONETARY = "ja_JP.UTF-8";
      LC_NAME = "ja_JP.UTF-8";
      LC_NUMERIC = "ja_JP.UTF-8";
      LC_PAPER = "ja_JP.UTF-8";
      LC_TELEPHONE = "ja_JP.UTF-8";
      LC_TIME = "ja_JP.UTF-8";
    };
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = [ pkgs.fcitx5-mozc ];
    };
  };

  services = {
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = false;
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security = {
    rtkit.enable = true;
  };

  system.stateVersion = "25.05";

  nixpkgs = {
    config.allowUnfree = true;
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    zsh.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        deno
      ];
    };
  };

  # Linux-specific packages
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wofi
  ];
}
