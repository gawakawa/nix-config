{
  pkgs,
  self,
  nixpkgs,
  system,
  ...
}:
{
  # NixOS設定

  # インポート
  imports = [
    ./hardware-configuration.nix
  ];

  # フォント設定
  fonts = {
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
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

  # Nix設定
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
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # ユーザー設定
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

  # ブートローダー設定
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # タイムゾーン設定
  time = {
    timeZone = "Asia/Tokyo";
  };

  # 地域化設定
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
      enabled = "fcitx5";
      fcitx5.addons = [ pkgs.fcitx5-mozc ];
    };
  };

  # X11/GNOME設定
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
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

  # セキュリティ設定
  security = {
    rtkit.enable = true;
  };

  # システム設定
  system.stateVersion = "25.05";

  # nixpkgs設定
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

  # パッケージ
  environment.systemPackages = with pkgs; [
    bat
    claude-code
    codex
    direnv
    discord
    fd
    gcc
    gh
    git
    gitmoji-cli
    gnumake
    google-chrome
    haskell-language-server
    httpie
    neofetch
    nixfmt-rfc-style
    rlwrap
    slack
    stack # for cornelis
    starship
    stylua
    tree
    treefmt
    unzip
    uv
    wofi
  ];
}
