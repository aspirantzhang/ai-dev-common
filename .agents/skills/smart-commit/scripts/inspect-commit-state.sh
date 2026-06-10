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

if git diff --cached --quiet; then
    echo "staged_state: empty"
else
    echo "staged_state: present"
fi

echo

echo "staged_files:"
if git diff --cached --quiet; then
    echo "none"
else
    git diff --cached --name-only
fi
echo

echo "unstaged_files:"
if git diff --quiet; then
    echo "none"
else
    git diff --name-only
fi

echo

echo "untracked_files:"
untracked_files="$(git ls-files --others --exclude-standard)"
if [ -n "$untracked_files" ]; then
    printf '%s\n' "$untracked_files"
else
    echo "none"
fi

echo

echo "staged_diff_stat:"
if git diff --cached --quiet; then
    echo "none"
else
    git diff --cached --stat
fi
