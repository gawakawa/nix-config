{
  home.sessionVariables = {
    ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-5-20251101";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-5-20250929";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5-20251001";
  };

  home.file = {
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
    ".claude/statusline.sh" = {
      source = ./statusline.sh;
      executable = true;
    };
  };
}
