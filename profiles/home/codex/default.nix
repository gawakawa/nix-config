{
  programs.codex = {
    enable = true;
    context = ../agents/AGENTS.md;

    # settings is intentionally left unset. programs.codex.settings would make
    # ~/.codex/config.toml a /nix/store symlink, which breaks Codex's own
    # runtime writes there (project trust, /model, /fast, ...). Declarative
    # defaults live in /etc/codex/config.toml (profiles/hosts/codex.nix)
    # instead, which Codex only reads.
  };
}
