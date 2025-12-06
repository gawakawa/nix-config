{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      v = "nvim";
      nvim = "nix run ~/.config/nvim --";
      c = "claude";
      ls = "ls -A";
      find = "fd";
      nrs = "sudo nixos-rebuild switch --flake \"$HOME/.config/nix-config#nixos\" --accept-flake-config --impure";
      drs = "sudo darwin-rebuild switch --flake \"$HOME/.config/nix-config#mac\" --accept-flake-config";
    };
    initContent = ''
      export PATH=$HOME/.deno/bin:$PATH
      export PATH=$HOME/.local/bin:$PATH
      export PATH=$HOME/.pack/bin:$PATH
      export PATH=$HOME/.ghcup/bin:$PATH
      export NIX_PATH=$HOME/.nix-defexpr/channels:$NIX_PATH

      mkcd() {
          mkdir -p "$1" && cd "$1"
      }

      # Set GH_TOKEN secret for flake update workflow in specified repository
      set-flake-update-token() {
          gh secret set GH_TOKEN -b"$(pass show github/pat-flake-update)" -R "$1"
      }

      # Set CACHIX_AUTH_TOKEN secret for Cachix push in specified repository
      set-cachix-token() {
          gh secret set CACHIX_AUTH_TOKEN -b"$(pass show cachix/auth-token)" -R "$1"
      }

      # Initialize flake using template from https://github.com/gawakawa/flake-templates
      flake-init() {
          nix flake init -t "github:gawakawa/flake-templates#$1"
      }
    '';
    prezto = {
      enable = true;
      # Comment out the prompt module to avoid conflicts with starship
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "syntax-highlighting"
        "history-substring-search"
        "autosuggestions"
        # "prompt"  # Disabled to allow starship to work
      ];
    };
  };
}
