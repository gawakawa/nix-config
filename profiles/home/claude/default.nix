{
  home.sessionVariables = {
    ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-5-20251101";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-5-20250929";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5-20251001";
  };

  programs.claude-code = {
    enable = true;

    settings = {
      model = "opus";
      alwaysThinkingEnabled = true;
      statusLine = {
        type = "command";
        command = "~/.claude/statusline.sh";
        padding = 0;
      };
      hooks = {
        PreCompact = [
          {
            hooks = [
              {
                type = "command";
                command = "~/.claude/backup-transcript.sh";
              }
            ];
          }
        ];
      };
      permissions = {
        deny = [
          "Bash(git add -A:*)"
          "Bash(git add --all:*)"
          "Bash(git add .:*)"
          "Bash(git add -u:*)"
          "Bash(git push:*)"
        ];
      };
      enabledPlugins = {
        "example-skills@anthropic-agent-skills" = true;
      };
    };

    memory.source = ./CLAUDE.md;
    agentsDir = ./agents;
    skillsDir = ./skills;
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
    builtins.listToAttrs (map mkScript (builtins.attrNames scripts));
}
