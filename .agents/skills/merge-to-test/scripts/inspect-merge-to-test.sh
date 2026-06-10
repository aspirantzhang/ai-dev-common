#!/usr/bin/env bash
set -euo pipefail

git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
cd "$git_root"

current_branch="$(git branch --show-current)"
head_sha="$(git rev-parse HEAD)"
merge_head="no"
[ -f .git/MERGE_HEAD ] && merge_head="yes"

echo "repository: $git_root"
echo "current_branch: ${current_branch:-detached-head}"
echo "head_sha: $head_sha"
echo "merge_in_progress: $merge_head"
echo

echo "status:"
git status --short --branch
echo

if git show-ref --verify --quiet refs/heads/test; then
    echo "local_test: present"
else
    echo "local_test: missing"
fi
