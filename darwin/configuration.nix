{
  pkgs,
  self,
  nixpkgs,
  system,
  ...
}:
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
    uv
  ];
}

