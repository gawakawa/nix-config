_: {
  programs.zsh = {
    enable = true;
    sessionVariables = {
      PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
    shellAliases = {
      v = "nvim";
      nvim = "nix run ~/.config/nix-config/nvim --";
      c = "claude";
      ccr = "OPENROUTER_API_KEY=$(pass show openrouter/api-key) command ccr code";
      ls = "eza -a";
      find = "fd";
      grep = "rg";
      nrs = "sudo nixos-rebuild switch --flake \"$HOME/.config/nix-config#nixos\" --accept-flake-config --impure";
      drs = "sudo darwin-rebuild switch --flake \"$HOME/.config/nix-config#mac\"";
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

      # Set GitHub Actions secrets
      # Usage: <func> [repo] (default: gawakawa/<current-dir>)
      set-flake-update-token() {
          local repo="''${1:-gawakawa/$(basename "$PWD")}"
          gh secret set GH_TOKEN -b "$(pass show github/pat-flake-update)" -R "$repo"
      }

      set-cachix-token() {
          local repo="''${1:-gawakawa/$(basename "$PWD")}"
          gh secret set CACHIX_AUTH_TOKEN -b "$(pass show cachix/auth-token)" -R "$repo"
      }

      set-all-secrets() {
          local repo="''${1:-gawakawa/$(basename "$PWD")}"
          set-flake-update-token "$repo"
          set-cachix-token "$repo"
      }

      # Create a new GitHub repo with initial commit and secrets
      init-gh-repo() {
          git commit -m '🎉 Initial commit' && \
          gh repo create --public --source=. --push && \
          gh repo edit --enable-auto-merge --delete-branch-on-merge --allow-update-branch && \
          set-all-secrets
      }

      # Initialize flake using template from https://github.com/gawakawa/flake-templates
      flake-init() {
          nix flake init -t "github:gawakawa/flake-templates#$1"
      }

      # Push flake outputs to gawakawa cachix
      push-to-cachix() {
          if [[ -z "$1" ]]; then
              echo "Usage: push-to-cachix <flake-output>"
              echo "Example: push-to-cachix .#devShells.aarch64-darwin.default"
              return 1
          fi
          nix build "$1" --json | jq -r '.[].outputs | to_entries[].value' | cachix push gawakawa
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
        "completion"
        "syntax-highlighting"
        "history-substring-search"
        "autosuggestions"
        # "prompt"  # Disabled to allow starship to work
      ];
    };
  };
}
