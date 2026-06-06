---
name: migrate-to-github-app
description: "Migrate GitHub Actions from PAT to GitHub App auth."
user-invocable: true
disable-model-invocation: true
model: sonnet
---

# Migrate to GitHub App

Migrate a repo's GitHub Actions from PAT (`GH_TOKEN`) to GitHub App (`gawakawa-bot`) authentication.

Read `references/workflow-templates.md` before starting — it contains the exact YAML for each file.

## Workflow

Use TaskCreate to track each step. Commit after each file change with `/commit`.

### Step 1: Audit current workflows

```bash
ls .github/workflows/
gh secret list --repo <owner>/<repo>
```

Note which of the 4 target files exist and whether `GH_TOKEN` is present as a secret.

### Step 2: Edit workflow files (one commit each)

For each file that exists, apply the change from `references/workflow-templates.md` and run `/commit`:

1. **`ci.yml`** — patch only: replace `secrets.GH_TOKEN` → `secrets.GITHUB_TOKEN` in `github_access_token`. Skip if file doesn't use `GH_TOKEN`.
2. **`dependabot-auto-merge.yml`** — full rewrite to reusable workflow caller
3. **`update-pr-branches.yml`** — full rewrite to reusable workflow caller
4. **`update-flake-lock.yml`** — full rewrite; adjust `branch` and `pr-title` to match repo convention; keep `<branch>` consistent in the `label` job

### Step 3: Manual setup (ask user to complete before continuing)

Ask the user to complete both of the following, then confirm before proceeding:

1. **Install the GitHub App on the repo** — GitHub Settings → Integrations → GitHub Apps → gawakawa-bot → Configure → add `<owner>/<repo>`
2. **Register secrets** — run interactively (uses `pass`, requires GPG passphrase):
   ```
   ! set-bot-secrets <owner>/<repo>
   ```

### Step 4: Verify secrets and push

```bash
gh secret list --repo <owner>/<repo>
# Must show BOT_APP_ID and BOT_PRIVATE_KEY before proceeding
git push
```

If secrets are missing, ask the user to run `! set-bot-secrets <owner>/<repo>` first.

### Step 5: Confirm CI passes

```bash
gh run list --repo <owner>/<repo> --workflow ci.yml --limit 1 --json databaseId,status
gh run watch <run-id> --repo <owner>/<repo> --exit-status
```

### Step 6: Run update-flake-lock and confirm success

```bash
gh workflow run "Update Flake Lock" --repo <owner>/<repo>
sleep 5
gh run list --repo <owner>/<repo> --workflow update-flake-lock.yml --limit 1 --json databaseId,status
gh run watch <run-id> --repo <owner>/<repo> --exit-status
```

If this fails with "Not Found" on the App token step, the `gawakawa-bot` App is not installed on the repo — ask the user to install it (Step 3) and retry.

### Step 7: Delete GH_TOKEN secret

Only after Step 6 succeeds:

```bash
gh secret delete GH_TOKEN --repo <owner>/<repo>
gh secret list --repo <owner>/<repo>  # confirm GH_TOKEN is gone
```
