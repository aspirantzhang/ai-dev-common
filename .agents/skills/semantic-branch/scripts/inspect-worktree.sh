#!/usr/bin/env bash
set -euo pipefail

git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
cd "$git_root"

current_branch="$(git branch --show-current)"
upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"

echo "repository: $git_root"
echo "current_branch: ${current_branch:-detached-head}"
echo "upstream: ${upstream:-none}"
echo

echo "status:"
git status --short --branch
echo

echo "changed_files:"
changed_files="$(git diff --name-only && git diff --cached --name-only)"
if [ -n "$changed_files" ]; then
    printf '%s\n' "$changed_files" | sort -u
else
    echo "none"
fi
echo

echo "recent_commits:"
git log --oneline -5
