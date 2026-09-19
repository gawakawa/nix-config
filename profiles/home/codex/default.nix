{
  programs.codex = {
    enable = true;
    context = ../agents/AGENTS.md;

    # settings unset: it'd symlink config.toml into /nix/store, breaking Codex's
    # runtime writes. Defaults live in profiles/hosts/codex.nix instead.
  };
}
