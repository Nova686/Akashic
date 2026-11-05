#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

history_url=${AKASHIC_HISTORY_URL:-git@github.com:Nova686/akashic-history.git}
history_ref=refs/remotes/history/main

git fetch -q origin main
git fetch -q "$history_url" "main:${history_ref}"
source_commit=$(git rev-parse origin/main)
last_synced=$(git log -1 --format=%B "$history_ref" | sed -n 's/^Synced-from: //p')
if [ "$last_synced" = "$source_commit" ]; then
  echo "akashic-history is already up to date with ${source_commit}"
  exit 0
fi

if [ -n "$last_synced" ] && git merge-base --is-ancestor "$last_synced" "$source_commit" 2>/dev/null; then
  changes=$(git log --no-merges --format='- %s' "${last_synced}..${source_commit}")
else
  changes=$(git log -1 --format='- %s' "$source_commit")
fi

mirror_commit=$(printf 'Sync from Akashic\n\n%s\n\nSynced-from: %s\n' "$changes" "$source_commit" | git commit-tree "${source_commit}^{tree}" -p "$history_ref")
git push -q "$history_url" "${mirror_commit}:refs/heads/main"
echo "akashic-history now matches Akashic ${source_commit}"
