{
  pkgs,
  self,
  nixpkgs,
  ...
}:
let
  isLinux = builtins.currentSystem == "x86_64-linux";
  isDarwin = builtins.currentSystem == "aarch64-darwin";
in
{
  # 設定のインポートはDarwin用のhomebrewの部分で統合して行います

  # 共通フォント設定
  fonts = {
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code
    ];
  };

  # Flakes用の設定
  nix =
    if isLinux then
      {
        package = pkgs.nix;
        settings = {
          experimental-features = "nix-command flakes";
        };
      }
    else
      {
        enable = false;
        package = pkgs.nix;
        settings = {
          experimental-features = "nix-command flakes";
        };
      };

  # zshの有効化
  programs.zsh.enable = true;

  # Linux特有の設定
  networking =
    if isLinux then
      {
        hostName = "nixos"; # Define your hostname.
        # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
        networkmanager.enable = true;
      }
    else
      { };

  # Linux特有のユーザー設定
  users =
    if isLinux then
      {
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
      }
    else
      {
        users.iota = {
          name = "iota";
          home = "/Users/iota";
        };
      };

  # Linux特有のブートローダー設定
  boot =
    if isLinux then
      {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
      }
    else
      { };

  # Linux特有のタイムゾーン設定
  time =
    if isLinux then
      {
        timeZone = "Asia/Tokyo";
      }
    else
      { };

  # Linux特有の地域化設定
  i18n =
    if isLinux then
      {
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
      }
    else
      { };

  # Linux特有のX11/GNOME設定
  services =
    if isLinux then
      {
        xserver = {
          enable = true;
          displayManager.gdm.enable = true;
          desktopManager.gnome.enable = true;
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
      }
    else
      { };

  # Linux特有のセキュリティ設定
  security =
    if isLinux then
      {
        rtkit.enable = true;
      }
    else
      { };

  # Linux特有のFirefox設定
  programs.firefox =
    if isLinux then
      {
        enable = true;
      }
    else
      { };

  # システム設定
  system.stateVersion = if isLinux then "25.05" else null;

  # 環境に応じてインポートするモジュールを変更
  imports =
    if isDarwin then
      [
        # Darwin特有の設定
        {
          system = {
            configurationRevision = self.rev or self.dirtyRev or null;
            stateVersion = 4;
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
        }
      ]
    else
      [
        # Linux特有の設定をここに追加
        ./hardware-configuration.nix
      ];

  # nixpkgs設定
  nixpkgs =
    if isDarwin then
      {
        config.allowUnfree = true;
        hostPlatform = "aarch64-darwin";
      }
    else
      {
        config.allowUnfree = true;
      };

  # インストールするパッケージ
  environment.systemPackages =
    with pkgs;
    # 共通パッケージ
    [
      awscli2
      bat
      claude-code
      direnv
      fd
      gh
      gitmoji-cli
      google-chrome
      google-cloud-sdk
      httpie
      neofetch
      nixfmt-rfc-style
      rlwrap
      starship
      stylua
      tree
      treefmt
      unzip
    ]
    ++
      # Linux特有のパッケージ
      (
        if isLinux then
          [
            gcc
            git
            gnumake
          ]
        else
          [ ]
      )
    ++
      # Darwin特有のパッケージ
      (
        if isDarwin then
          [
            discord
            qemu
            slack
            tart
            utm
          ]
        else
          [ ]
      );
}
