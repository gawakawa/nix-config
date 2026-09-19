# Workflow Templates for GitHub App Migration

Reusable workflow callers for `gawakawa/.github`. Copy as-is; adjust `branch` and `pr-title` in update-flake-lock if the repo uses different values.

---

## ci.yml — patch only

Do NOT rewrite `ci.yml`. Only replace the `github_access_token` line:

```
github_access_token: ${{ secrets.GH_TOKEN }}
→
github_access_token: ${{ secrets.GITHUB_TOKEN }}
```

If `ci.yml` does not reference `GH_TOKEN` at all, skip this file.

---

## dependabot-auto-merge.yml

```yaml
name: Dependabot Auto Merge

on:
  pull_request:

permissions:
  contents: write
  pull-requests: write

jobs:
  auto-merge:
    uses: gawakawa/.github/.github/workflows/dependabot-auto-merge.yml@main
```

---

## update-pr-branches.yml

```yaml
name: Update PR Branches

on:
  push:
    branches:
      - main

permissions:
  contents: write
  pull-requests: write

jobs:
  update-prs:
    uses: gawakawa/.github/.github/workflows/update-pr-branches.yml@main
    secrets:
      BOT_APP_ID: ${{ secrets.BOT_APP_ID }}
      BOT_PRIVATE_KEY: ${{ secrets.BOT_PRIVATE_KEY }}
```

---

## update-flake-lock.yml

Adjust `branch` (default: `update-flake-lock`) and `pr-title` to match the repo convention.

```yaml
name: Update Flake Lock

on:
  workflow_dispatch:
  schedule:
    - cron: '0 15 * * 5' # Run every Saturday at 00:00 JST (Friday 15:00 UTC)

jobs:
  update-flake-lock:
    permissions:
      contents: write
      pull-requests: write
    uses: gawakawa/.github/.github/workflows/update-flake-lock.yml@main
    with:
      auto-merge: true
      branch: update-flake-lock
      pr-title: "⬆️ Update flake.lock"
    secrets:
      BOT_APP_ID: ${{ secrets.BOT_APP_ID }}
      BOT_PRIVATE_KEY: ${{ secrets.BOT_PRIVATE_KEY }}

  label:
    needs: update-flake-lock
    permissions:
      pull-requests: write
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - name: Add dependencies label
        env:
          GH_TOKEN: ${{ github.token }}
        run: |
          PR_NUMBER=$(gh pr list --repo "${{ github.repository }}" --head <branch> --json number --jq '.[0].number')
          if [ -n "$PR_NUMBER" ]; then
            gh pr edit "$PR_NUMBER" --repo "${{ github.repository }}" --add-label dependencies
          fi
```

Replace `<branch>` in the `label` job with the same value used in `with.branch`.
