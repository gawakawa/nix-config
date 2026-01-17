{
  home.sessionVariables = {
    ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-5-20251101";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-5-20250929";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5-20251001";
  };

  home.file =
    let
      scripts = builtins.readDir ./scripts;
      mkScript = name: {
        name = ".claude/${name}";
        value = {
          source = ./scripts/${name};
          executable = true;
        };
      };
    in
    {
      ".claude/settings.json".source = ./settings.json;
      ".claude/CLAUDE.md".source = ./CLAUDE.md;
      ".claude/agents" = {
        source = ./agents;
        recursive = true;
      };
      ".claude/skills" = {
        source = ./skills;
        recursive = true;
      };
    }
    // builtins.listToAttrs (map mkScript (builtins.attrNames scripts));
}
