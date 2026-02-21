{ inputs, system, ... }:
let
  mcpPkgs = import inputs.mcp-servers-nix.inputs.nixpkgs { inherit system; };
in
{
  home.sessionVariables = {
    ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-6";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-6";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5-20251001";
  };

  programs.claude-code = {
    enable = true;

    mcpServers = {
      nixos = {
        command = "${mcpPkgs.mcp-nixos}/bin/mcp-nixos";
        args = [ ];
      };
    };

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
          "Bash(git commit --no-verify:*)"
          "Bash(git commit -n:*)"
          "Bash(nix develop:*)"
          "Bash(nix shell:*)"
        ];
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
