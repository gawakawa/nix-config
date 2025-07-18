{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      v = "nvim";
      c = "claude";
      lmk = "latexmk -pvc -c";
      updatedb = "sudo /usr/libexec/locate.updatedb";
      oj-bundle = "oj-bundle -I $HOME/kyopro/atcoder/cpp/mylib";
      gpp = "g++ -std=c++23 -O2 -Wall -Wextra -Wshadow -g";
      idris2 = "rlwrap idris2 -p contrib";
      oj-t = "fourmolu -i Main.hs && oj t -c 'stack Main.hs'"; # oj test for Haskell
      ls = "ls -A";
      nrs = "sudo nixos-rebuild switch --flake \"$HOME/.config/nix-config#nixos\" --impure"; # update nix config
      drs = "sudo darwin-rebuild switch --flake \"$HOME/.config/nix-config#mac\"";
      nsh = "nix-shell";
      new = "cargo compete new";
      test = "cargo compete test";
      submit = "cargo compete submit";
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
