#!/usr/bin/env bash
set -euo pipefail

branch_name="${1:-}"
base_branch="${BASE_BRANCH:-master}"
remote_name="${REMOTE_NAME:-origin}"

if [ -z "$branch_name" ]; then
    echo "error: missing branch name" >&2
    echo "usage: $0 <type/short-description>" >&2
    exit 64
fi

if ! [[ "$branch_name" =~ ^(feat|fix|refactor|docs|chore|style|test)/[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    echo "error: invalid semantic branch name: $branch_name" >&2
    echo "expected: type/short-description, lowercase kebab-case" >&2
    exit 65
fi

git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
cd "$git_root"

if ! git remote get-url "$remote_name" >/dev/null 2>&1; then
    echo "error: remote not found: $remote_name" >&2
    exit 66
fi
if git show-ref --verify --quiet "refs/heads/$branch_name"; then
    echo "error: local branch already exists: $branch_name" >&2
    exit 67
fi

if git ls-remote --exit-code --heads "$remote_name" "$branch_name" >/dev/null 2>&1; then
    echo "error: remote branch already exists: $remote_name/$branch_name" >&2
    exit 68
fi

before_branch="$(git branch --show-current)"
if [ -z "$before_branch" ]; then
    echo "error: detached HEAD is not supported" >&2
    exit 69
fi

git fetch "$remote_name" "$base_branch"
git checkout -b "$branch_name" FETCH_HEAD

echo "created_branch: $branch_name"
echo "base_ref: $remote_name/$base_branch"
echo "previous_branch: $before_branch"
