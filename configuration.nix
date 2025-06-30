{
  pkgs,
  self,
  nixpkgs,
  system,
  ...
}:
let
  isLinux = system == "x86_64-linux";
  isDarwin = system == "aarch64-darwin";
in
if isDarwin then
  {
    # Darwin設定

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
    };

    # Nix設定 (Determinate Nix用)
    nix.enable = false;

    # zsh有効化
    programs.zsh.enable = true;

    # ユーザー設定
    users.users.iota = {
      name = "iota";
      home = "/Users/iota";
    };

    # システム設定
    system = {
      configurationRevision = self.rev or self.dirtyRev or null;
      stateVersion = 4;
      primaryUser = "iota";
    };

    # Homebrew設定
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
        "notion"
        "visual-studio-code"
        "wezterm"
      ];
      masApps = {
        "LINE" = 539883307;
        "Goodnotes 6" = 1444383602;
        "Kindle" = 302584613;
      };
    };

    # nixpkgs設定
    nixpkgs = {
      config.allowUnfree = true;
      hostPlatform = "aarch64-darwin";
    };

    # パッケージ
    environment.systemPackages = with pkgs; [
      awscli2
      bat
      claude-code
      direnv
      discord
      fd
      gh
      git
      gitmoji-cli
      google-chrome
      google-cloud-sdk
      httpie
      neofetch
      nixfmt-rfc-style
      qemu
      rlwrap
      slack
      starship
      stylua
      tree
      treefmt
      unzip
    ];
  }
else
  {
    # NixOS設定

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
        experimental-features = "nix-command flakes";
      };
    };

    # zsh有効化
    programs.zsh.enable = true;

    # ネットワーク設定
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
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
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

    # インポート
    imports = [
      ./hardware-configuration.nix
    ];

    # nixpkgs設定
    nixpkgs = {
      config.allowUnfree = true;
    };

    # パッケージ
    environment.systemPackages = with pkgs; [
      awscli2
      bat
      claude-code
      direnv
      discord
      fd
      gcc
      gh
      git
      gitmoji-cli
      gnumake
      google-chrome
      google-cloud-sdk
      httpie
      neofetch
      nixfmt-rfc-style
      rlwrap
      slack
      starship
      stylua
      tree
      treefmt
      unzip
    ];
  }
