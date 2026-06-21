_: {
  programs.zsh = {
    enable = true;
    sessionVariables = {
      NIXCFG_DIR = "$HOME/projects/github.com/gawakawa/nix-config";
      GH_OWNER = "gawakawa";
    };
    shellAliases = {
      v = "nix run \"$NIXCFG_DIR/nvim\" --";
      c = "claude";
      ccr = "OPENROUTER_API_KEY=$(pass show openrouter/api-key) command ccr code";
      ls = "eza -a";
      find = "fd";
      grep = "rg";
      nrs = "sudo nixos-rebuild switch --flake \"$NIXCFG_DIR#nixos\" --accept-flake-config --impure";
      drs = "sudo darwin-rebuild switch --flake \"$NIXCFG_DIR#mac\"";
      non-nix-nvim = "XDG_CONFIG_HOME=$HOME/projects/github.com/gawakawa/non-nix-nvim XDG_DATA_HOME=$HOME/.local/share/non-nix-nvim XDG_STATE_HOME=$HOME/.local/state/non-nix-nvim nix run 'nixpkgs#neovim' --";
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
      # Usage: <func> [repo] (default: $GH_OWNER/<current-dir>)
      set-cachix-token() {
          local repo="''${1:-$GH_OWNER/$(basename "$PWD")}"
          local token
          token="$(pass show cachix/auth-token)" && \
          gh secret set CACHIX_AUTH_TOKEN -b "$token" -R "$repo"
      }

      set-all-secrets() {
          local repo="''${1:-$GH_OWNER/$(basename "$PWD")}"
          set-bot-secrets "$repo" && set-cachix-token "$repo"
      }

      # Set gawakawa-bot GitHub App secrets
      # Usage: set-bot-secrets <repo>
      set-bot-secrets() {
          local repo="$1"
          if [[ -z "$repo" ]]; then
              echo "Usage: set-bot-secrets <repo>"
              return 1
          fi
          local app_id private_key
          app_id="$(pass github/apps/gawakawa-bot/app-id)" && \
          private_key="$(pass github/apps/gawakawa-bot/private-key)" && \
          gh secret set BOT_APP_ID -b "$app_id" -R "$repo" && \
          gh secret set BOT_PRIVATE_KEY -b "$private_key" -R "$repo"
      }

      # Create a new GitHub repo and clone it into the ghq/gwq structure
      # Usage: init-gh-repo <name> [-t <template>]
      #   -t <template>  apply a flake template from gawakawa/flake-templates,
      #                  then commit & push the initialized repo
      init-gh-repo() {
          local name="" template=""
          while [[ $# -gt 0 ]]; do
              case "$1" in
                  -t)
                      if [[ -z "$2" ]]; then
                          echo "Usage: init-gh-repo <name> -t <template>"
                          return 1
                      fi
                      if [[ -n "$template" ]]; then
                          echo "Usage: init-gh-repo <name> [-t <template>] (one template only)"
                          return 1
                      fi
                      template="$2"
                      shift 2
                      ;;
                  -*)
                      echo "init-gh-repo: unknown option: $1"
                      echo "Usage: init-gh-repo <name> [-t <template>]"
                      return 1
                      ;;
                  *)
                      if [[ -n "$name" ]]; then
                          echo "Usage: init-gh-repo <name> [-t <template>] (one name only)"
                          return 1
                      fi
                      name="$1"
                      shift
                      ;;
              esac
          done
          if [[ -z "$name" ]]; then
              echo "Usage: init-gh-repo <name> [-t <template>]"
              return 1
          fi
          if [[ "$name" == */* ]]; then
              echo "init-gh-repo: name must not contain slashes: $name"
              return 1
          fi
          local repo="$GH_OWNER/$name"
          gh repo create "$repo" --public && \
          gh repo edit "$repo" --enable-auto-merge --delete-branch-on-merge --allow-update-branch && \
          ghq get -p "$repo" && \
          set-all-secrets "$repo" && \
          cd "$(ghq root)/github.com/$repo" || return 1
          if [[ -n "$template" ]]; then
              flake-init "$template" && \
              git add -A && \
              git commit -m ":tada: Initialize from $template template" && \
              git push -u origin HEAD
          fi
      }

      # Initialize flake using template from https://github.com/gawakawa/flake-templates
      flake-init() {
          NIX_CONFIG="access-tokens = github.com=$(gh auth token)" \
              nix flake init -t "github:$GH_OWNER/flake-templates#$1" || {
              echo "flake-init: failed to initialize template '$1' from github:$GH_OWNER/flake-templates" >&2
              return 1
          }
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

      # Select a ghq-managed repository with fzf (preview README) and cd into it
      ghq-fzf() {
          local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
          if [ -n "$src" ]; then
              BUFFER="cd $(ghq root)/$src"
              zle accept-line
          fi
          zle -R -c
      }
      zle -N ghq-fzf
      bindkey '^g' ghq-fzf
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
