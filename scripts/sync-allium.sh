#!/usr/bin/env bash
#
# Re-vendor (or verify) plugins/allium from a pinned juxt/allium ref.
#
#   scripts/sync-allium.sh           # update plugins/allium to the pinned ref
#   scripts/sync-allium.sh --check   # exit non-zero if plugins/allium drifts
#
# The pinned ref lives in scripts/allium-ref.txt — a commit SHA or release tag
# of juxt/allium. Allium is an actively developed external repo, so its plugin
# payload is vendored here rather than referenced as a remote source (Codex
# only discovers local `./plugins/X` marketplace entries). Vendoring drifts
# silently; this script + the matching CI check keep the copy honest.
#
# To ship a new Allium release to the marketplace: bump scripts/allium-ref.txt
# to the new ref, run `scripts/sync-allium.sh`, and commit the result.
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REF="$(tr -d '[:space:]' < "$ROOT/scripts/allium-ref.txt")"
DEST="$ROOT/plugins/allium"
MODE="${1:-sync}"

if [ -z "$REF" ]; then
  echo "error: scripts/allium-ref.txt is empty" >&2
  exit 2
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

git clone --quiet https://github.com/juxt/allium "$tmp/allium"
git -C "$tmp/allium" checkout --quiet "$REF"
rm -rf "$tmp/allium/.git"

if [ "$MODE" = "--check" ]; then
  if [ ! -d "$DEST" ]; then
    echo "plugins/allium not present yet — nothing to check (vendor it with: scripts/sync-allium.sh)."
    exit 0
  fi
  if diff -r "$tmp/allium" "$DEST" >/dev/null; then
    echo "plugins/allium is in sync with juxt/allium@$REF"
  else
    echo "::error::plugins/allium is OUT OF SYNC with juxt/allium@$REF" >&2
    diff -r "$tmp/allium" "$DEST" || true
    echo "Run scripts/sync-allium.sh to update plugins/allium." >&2
    exit 1
  fi
elif [ "$MODE" = "sync" ]; then
  rm -rf "$DEST"
  mkdir -p "$DEST"
  cp -R "$tmp/allium/." "$DEST/"
  echo "Synced plugins/allium to juxt/allium@$REF"
else
  echo "usage: scripts/sync-allium.sh [--check]" >&2
  exit 2
fi
