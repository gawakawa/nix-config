{
  inputs,
  system,
  pkgs,
  ...
}:
let
  mcpPkgs = import inputs.mcp-servers-nix.inputs.nixpkgs { inherit system; };
  tomlFormat = pkgs.formats.toml { };
  denyScript = pkgs.writeShellScript "codex-deny.sh" (
    builtins.readFile ../home/claude/scripts/deny.sh
  );
in
{
  environment = {
    etc = {
      "codex/deny.sh" = {
        source = denyScript;
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
            pattern = ["nix", "fmt"],
            decision = "allow",
            justification = "Nix formatting is an approved development operation.",
            match = ["nix fmt"],
        )

        prefix_rule(
            pattern = ["nix", "flake", "check"],
            decision = "allow",
            justification = "Nix flake checks are approved development verification.",
            match = ["nix flake check"],
        )

        prefix_rule(
            pattern = ["nix", "build"],
            decision = "allow",
            justification = "Nix builds are approved development verification.",
            match = ["nix build .#package"],
        )

        prefix_rule(
            pattern = ["nix", "eval"],
            decision = "allow",
            justification = "Nix evaluation is approved development verification.",
            match = ["nix eval .#package"],
        )

        prefix_rule(
            pattern = ["nix", "flake", "metadata"],
            decision = "allow",
            justification = "Nix flake metadata inspection is an approved development operation.",
            match = ["nix flake metadata"],
        )

        prefix_rule(
            pattern = ["nix", "flake", "show"],
            decision = "allow",
            justification = "Nix flake inspection is an approved development operation.",
            match = ["nix flake show"],
        )

        prefix_rule(
            pattern = ["nix", "path-info"],
            decision = "allow",
            justification = "Nix path inspection is an approved development operation.",
            match = ["nix path-info .#package"],
        )

        prefix_rule(
            pattern = ["nix", "derivation", "show"],
            decision = "allow",
            justification = "Nix derivation inspection is an approved development operation.",
            match = ["nix derivation show .#package"],
        )

        prefix_rule(
            pattern = ["nix", "why-depends"],
            decision = "allow",
            justification = "Nix dependency inspection is an approved development operation.",
            match = ["nix why-depends .#package .#dependency"],
        )

        prefix_rule(
            pattern = ["nix", "config", "show"],
            decision = "allow",
            justification = "Nix configuration inspection is an approved development operation.",
            match = ["nix config show"],
        )

        prefix_rule(
            pattern = ["rm"],
            decision = "prompt",
            justification = "Confirm deletion outside the workspace.",
            match = ["rm /tmp/example"],
        )

        prefix_rule(
            pattern = ["git", "push"],
            decision = "forbidden",
            justification = "Run git push yourself after reviewing the remote destination and branch.",
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

        prefix_rule(
            pattern = ["git-surgeon", "hunks"],
            decision = "allow",
            justification = "Listing hunks with git-surgeon is read-only.",
            match = ["git-surgeon hunks"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "show"],
            decision = "allow",
            justification = "Showing a hunk with git-surgeon is read-only.",
            match = ["git-surgeon show"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "stage"],
            decision = "allow",
            justification = "Staging hunks with git-surgeon is an approved git operation.",
            match = ["git-surgeon stage"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "unstage"],
            decision = "allow",
            justification = "Unstaging hunks with git-surgeon is an approved git operation.",
            match = ["git-surgeon unstage"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "commit"],
            decision = "allow",
            justification = "Committing selected hunks with git-surgeon is an approved git operation.",
            match = ["git-surgeon commit"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "commit-to"],
            decision = "prompt",
            justification = "Committing hunks to another branch needs confirmation.",
            match = ["git-surgeon commit-to"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "discard"],
            decision = "prompt",
            justification = "Discarding hunks loses working tree changes.",
            match = ["git-surgeon discard"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "undo"],
            decision = "prompt",
            justification = "Undoing hunks modifies the working tree.",
            match = ["git-surgeon undo"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "undo-file"],
            decision = "prompt",
            justification = "Undoing files modifies the working tree.",
            match = ["git-surgeon undo-file"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "fold"],
            decision = "prompt",
            justification = "Folding commits rewrites history.",
            match = ["git-surgeon fold"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "amend"],
            decision = "prompt",
            justification = "Amending an earlier commit rewrites history.",
            match = ["git-surgeon amend"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "squash"],
            decision = "prompt",
            justification = "Squashing commits rewrites history.",
            match = ["git-surgeon squash"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "split"],
            decision = "prompt",
            justification = "Splitting a commit rewrites history.",
            match = ["git-surgeon split"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "move"],
            decision = "prompt",
            justification = "Moving a commit rewrites history.",
            match = ["git-surgeon move"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "reword"],
            decision = "prompt",
            justification = "Rewording a commit rewrites history.",
            match = ["git-surgeon reword"],
        )

        prefix_rule(
            pattern = ["git-surgeon", "update"],
            decision = "forbidden",
            justification = "git-surgeon is managed by Nix; self-update would fight it.",
            match = ["git-surgeon update"],
        )
      '';

      "codex/config.toml".source = tomlFormat.generate "codex-config.toml" {
        model_reasoning_effort = "high";
        plan_mode_reasoning_effort = "xhigh";
        approval_policy = "on-request";
        approvals_reviewer = "auto_review";
        sandbox_mode = "workspace-write";
        tui.status_line = [
          "project-name"
          "model-with-reasoning"
          "context-remaining"
        ];
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
            pushReason = "Run git push yourself after reviewing the remote destination and branch.";
            addRegex = "^[[:space:]]*git[[:space:]]+add[[:space:]]+(-A|--all|-u|\\.)([[:space:]]|$)";
            resetRegex = "^[[:space:]]*git[[:space:]]+reset[[:space:]]+--hard([[:space:]]|$)";
            noVerifyRegex = "^[[:space:]]*git[[:space:]]+commit[[:space:]]+--no-verify([[:space:]]|$)";
            shortNoVerifyRegex = "^[[:space:]]*git[[:space:]]+commit[[:space:]]+-n([[:space:]]|$)";
            nixShellRegex = "^[[:space:]]*nix[[:space:]]+(develop|shell)([[:space:]]|$)";
            pushRegex = "^[[:space:]]*git[[:space:]]+push([[:space:]]|$)";
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
                (deny pushRegex pushReason)
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
