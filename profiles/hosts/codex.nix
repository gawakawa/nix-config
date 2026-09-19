{
  inputs,
  system,
  pkgs,
  ...
}:
let
  mcpPkgs = import inputs.mcp-servers-nix.inputs.nixpkgs { inherit system; };
  tomlFormat = pkgs.formats.toml { };
in
{
  environment = {
    etc = {
      "codex/deny.sh" = {
        source = ../home/claude/scripts/deny.sh;
        mode = "0755";
      };

      "codex/rules/default.rules".text = ''
        prefix_rule(
            pattern = ["ax"],
            decision = "allow",
            justification = "ax is an approved development tool.",
            match = ["ax --help"],
        )

        prefix_rule(
            pattern = ["agent-browser"],
            decision = "allow",
            justification = "agent-browser is an approved development tool.",
            match = ["agent-browser --help"],
        )

        prefix_rule(
            pattern = ["rm"],
            decision = "prompt",
            justification = "Confirm deletion outside the workspace.",
            match = ["rm /tmp/example"],
        )

        prefix_rule(
            pattern = ["git", "push"],
            decision = "prompt",
            justification = "Confirm changes sent to a remote repository.",
            match = ["git push origin main"],
        )

        prefix_rule(
            pattern = ["terraform", "apply"],
            decision = "forbidden",
            justification = "Review infrastructure changes without applying them.",
            match = ["terraform apply"],
        )

        prefix_rule(
            pattern = ["opentofu", "apply"],
            decision = "forbidden",
            justification = "Review infrastructure changes without applying them.",
            match = ["opentofu apply"],
        )

        prefix_rule(
            pattern = ["tofu", "apply"],
            decision = "forbidden",
            justification = "Review infrastructure changes without applying them.",
            match = ["tofu apply"],
        )
      '';

      "codex/config.toml".source = tomlFormat.generate "codex-config.toml" {
        model_reasoning_effort = "high";
        plan_mode_reasoning_effort = "xhigh";
        approval_policy = "on-request";
        approvals_reviewer = "auto_review";
        sandbox_mode = "workspace-write";
        hooks.PreToolUse =
          let
            deny = matchRegex: reason: {
              type = "command";
              command = "/etc/codex/deny.sh '${matchRegex}' '${reason}'";
              timeout = 5;
              statusMessage = "Checking command policy";
            };
            bulkAddReason = "Stage files explicitly by name instead: git add <file>.";
            resetHardReason = "Use git reset --soft to move HEAD while keeping changes, git revert to undo a commit, or git restore <file> (git checkout -- <file>) to discard specific working-tree changes.";
            noVerifyReason = "Do not bypass commit hooks.";
            nixShellReason = "Use direnv or comma instead of nix develop or nix shell.";
            addRegex = "^[[:space:]]*git[[:space:]]+add[[:space:]]+(-A|--all|-u|\\.)([[:space:]]|$)";
            resetRegex = "^[[:space:]]*git[[:space:]]+reset[[:space:]]+--hard([[:space:]]|$)";
            noVerifyRegex = "^[[:space:]]*git[[:space:]]+commit[[:space:]]+--no-verify([[:space:]]|$)";
            shortNoVerifyRegex = "^[[:space:]]*git[[:space:]]+commit[[:space:]]+-n([[:space:]]|$)";
            nixShellRegex = "^[[:space:]]*nix[[:space:]]+(develop|shell)([[:space:]]|$)";
          in
          [
            {
              matcher = "^Bash$";
              hooks = [
                (deny addRegex bulkAddReason)
                (deny resetRegex resetHardReason)
                (deny noVerifyRegex noVerifyReason)
                (deny shortNoVerifyRegex noVerifyReason)
                (deny nixShellRegex nixShellReason)
              ];
            }
          ];
        mcp_servers.nixos = {
          command = "${mcpPkgs.mcp-nixos}/bin/mcp-nixos";
          args = [ ];
        };
      };
    };
  };
}
