{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../profiles/hosts/packages.nix
    ../../profiles/hosts/codex.nix
    inputs.silentSDDM.nixosModules.default
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
      trusted-public-keys = [
        # Binary Cache for haskell.nix
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "gawakawa.cachix.org-1:NVSPP7gCC7cr4U7eWhK3MlDGmbU5YkdHqW6+r7oz17c="
      ];
      substituters = [
        # Binary Cache for haskell.nix
        "https://cache.iog.io"
        "https://nix-community.cachix.org"
        "https://gawakawa.cachix.org"
      ];
      trusted-users = [
        "root"
        "iota"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    optimise = {
      automatic = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    networkmanager.wifi.powersave = true;
  };

  # cachix-watch-store decrypts its token here (systemd --user can't use
  # pass/GPG's pinentry-tty). Bound to ssh_host_ed25519_key: a from-scratch
  # reinstall needs that key restored, or secrets/nixos.yaml re-keyed.
  sops = {
    defaultSopsFile = ../../secrets/nixos.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.cachix-auth-token.owner = "iota";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.iota = {
      isNormalUser = true;
      description = "iota";
      extraGroups = [
        "docker"
        "networkmanager"
        "video"
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
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ja_JP.UTF-8";
      LC_IDENTIFICATION = "ja_JP.UTF-8";
      LC_MEASUREMENT = "ja_JP.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
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
    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings.main.capslock = "esc";
      };
    };
    resolved = {
      enable = true; # local DNS cache via stub resolver (127.0.0.53)
      settings.Resolve.LLMNR = "false"; # disable LLMNR to prevent link-local name poisoning
    };
    power-profiles-daemon.enable = true;
    # Ignore lid close on AC power; battery keeps the systemd default (suspend).
    logind.settings.Login = {
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    # brightnessctl's udev rules grant the "video" group write access to
    # /sys/class/backlight, so brightness can be adjusted without root.
    udev.packages = [ pkgs.brightnessctl ];
    # sshd itself is not enabled; only ed25519 host key is generated, for
    # sops.age.sshKeyPaths (used above).
    openssh = {
      generateHostKeys = true;
      hostKeys = [
        {
          type = "ed25519";
          path = "/etc/ssh/ssh_host_ed25519_key";
        }
      ];
    };
  };

  security = {
    rtkit.enable = true;
  };

  system.stateVersion = "25.05";

  nixpkgs = {
    config.allowUnfree = true;
  };

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # Hide the broken "Hyprland (uwsm-managed)" SDDM entry: nixpkgs' hyprland
  # package ships hyprland-uwsm.desktop unconditionally, but this repo never
  # enables programs.uwsm, so selecting it freezes the greeter.
  services.displayManager.sessionPackages = lib.mkForce [
    (pkgs.symlinkJoin {
      name = "hyprland-session-no-uwsm";
      paths = [ config.programs.hyprland.package ];
      postBuild = ''
        rm -f $out/share/wayland-sessions/hyprland-uwsm.desktop
      '';
      passthru.providedSessions = [ "hyprland" ];
    })
  ];

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    silentSDDM = {
      enable = true;
      theme = "default";
    };
    zsh.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        deno
      ];
    };
    nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 30d --keep 3";
      };
    };
  };

  # Linux-specific packages
  environment.systemPackages = with pkgs; [
    brightnessctl
    (callPackage ./packages/terminal-browser.nix { })
    wl-clipboard
    wofi
  ];
}
