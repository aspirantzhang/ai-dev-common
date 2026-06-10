#!/usr/bin/env bash
set -euo pipefail

git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
cd "$git_root"

current_branch="$(git branch --show-current)"
if [ -z "$current_branch" ]; then
    echo "error: detached HEAD is not supported" >&2
    exit 64
fi

had_staged=0
if ! git diff --cached --quiet; then
    had_staged=1
fi

if [ "$had_staged" -eq 1 ]; then
    echo "stage_mode: keep-existing-staged"
else
    git add .
    echo "stage_mode: auto-stage-all"
fi

if git diff --cached --quiet; then
    echo "error: no staged changes to commit" >&2
    exit 65
fi

echo
echo "staged_files:"
git diff --cached --name-only
echo
echo "staged_diff_stat:"
git diff --cached --stat

echo
echo "staged_diff:"
git diff --cached --no-ext-diff
