{
  home.file = {
    ".claude/settings.json".source = ./settings.json;
    ".claude/CLAUDE.md".source = ./CLAUDE.md;
    ".claude/agents" = {
      source = ./agents;
      recursive = true;
    };
    ".claude/statusline.sh" = {
      source = ./statusline.sh;
      executable = true;
    };
  };
}
