{
  inputs,
  system,
  pkgs,
  lib,
  ...
}:
let
  mcpPkgs = import inputs.mcp-servers-nix.inputs.nixpkgs { inherit system; };
in
{
  home.sessionVariables = {
    ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-8";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-5";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5-20251001";
    CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
  };

  programs.claude-code = {
    enable = true;

    # ponytail's hooks invoke `node`; keep it on Claude's PATH only, not global.
    package = pkgs.symlinkJoin {
      name = "claude-code-with-node";
      paths = [ pkgs.claude-code ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/claude --prefix PATH : ${lib.makeBinPath [ pkgs.nodejs ]}
      '';
    };

    plugins = [ inputs.ponytail ];

    mcpServers = {
      nixos = {
        command = "${mcpPkgs.mcp-nixos}/bin/mcp-nixos";
        args = [ ];
      };
    };

    settings = {
      model = "opusplan";
      advisorModel = "opus";
      language = "japanese";
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
        PreToolUse = [
          {
            matcher = "Bash";
            hooks =
              let
                # `if` only gates whether deny.sh runs; deny.sh re-checks the
                # real command from stdin before denying, since `if`'s prefix
                # matcher fails open on ${...} and compound commands. The
                # match regex is passed through as-is so this `let` block is
                # the single place that maps a guard to its pattern.
                deny = matchRegex: ifPattern: reason: {
                  type = "command";
                  "if" = ifPattern;
                  command = "~/.claude/deny.sh '${matchRegex}' '${reason}'";
                };
                bulkAddReason = "Stage files explicitly by name instead: git add <file>.";
                resetHardReason = "Use git reset --soft to move HEAD while keeping changes, git revert to undo a commit, or git restore <file> (git checkout -- <file>) to discard specific working-tree changes.";
                addRegex = "^[[:space:]]*git[[:space:]]+add[[:space:]]+(-A|--all|-u|\\.)([[:space:]]|$)";
                resetRegex = "^[[:space:]]*git[[:space:]]+reset[[:space:]]+--hard([[:space:]]|$)";
              in
              (map (ifPattern: deny addRegex ifPattern bulkAddReason) [
                "Bash(git add -A:*)"
                "Bash(git add --all:*)"
                "Bash(git add -u:*)"
                "Bash(git add .:*)"
              ])
              ++ [
                (deny resetRegex "Bash(git reset --hard:*)" resetHardReason)
              ];
          }
        ];
      };
      permissions = {
        allow = [
          "Skill(commit)"
          "Skill(pr)"
          "Skill(ci-debugger)"
          "Skill(skill-creator)"
          "Skill(review-loop)"
          "Skill(japanese-tech-writing)"
          "mcp__nixos"
        ];
        ask = [
          "Bash(rm *)"
          "Bash(mv *)"
          "Bash(ln *)"
          "Bash(git push:*)"
          "Bash(git restore:*)"
          "Bash(git commit --amend:*)"
          "Bash(terraform * apply *)"
          "Bash(opentofu * apply *)"
          "Bash(tofu * apply *)"
        ];
        deny = [
          "Bash(git commit --no-verify:*)"
          "Bash(git commit -n:*)"
          "Bash(nix develop:*)"
          "Bash(nix shell:*)"
        ];
      };
    };

    context = ./CLAUDE.md;
    agentsDir = ./agents;
    skills = ./skills;
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
