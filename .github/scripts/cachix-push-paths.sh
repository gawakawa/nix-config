#!/usr/bin/env bash
# Print the closure of $1 minus the excluded packages and everything that
# references them (cachix push uploads closures, so a referrer would drag its
# excluded dependency along).
set -euo pipefail
export LC_ALL=C

# Vendor binaries that Nix only unpacks: large, but cheap to rebuild.
excluded=(
  'claude-code-[0-9]'
  'discord'
  'google-chrome'
  'index-aarch64-darwin'
  'index-x86_64-linux'
  'slack-[0-9]'
  'terminal-browser'
)

closure=$(nix-store -qR "$1" | sort)
mapfile -t roots < <(grep -E "^/nix/store/.{32}-($(
  IFS='|'
  echo "${excluded[*]}"
))" <<<"$closure")
comm -23 <(echo "$closure") <(nix-store -q --referrers-closure "${roots[@]}" | sort)
