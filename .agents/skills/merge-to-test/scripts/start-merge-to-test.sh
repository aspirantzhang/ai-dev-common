#!/usr/bin/env bash
set -euo pipefail

git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
cd "$git_root"

state_file=".git/merge-to-test.state"
source_branch="$(git branch --show-current)"
if [ -z "$source_branch" ]; then
    echo "error: detached HEAD is not supported" >&2
    exit 64
fi

source_sha="$(git rev-parse HEAD)"
if [ "$source_branch" = "test" ]; then
    echo "error: current branch is already test" >&2
    exit 65
fi

if [ -n "$(git status --porcelain)" ]; then
    echo "error: working tree is not clean" >&2
    exit 66
fi

if [ -f "$state_file" ]; then
    echo "error: merge state already exists" >&2
    exit 67
fi

printf 'source_branch=%s\nsource_sha=%s\n' "$source_branch" "$source_sha" > "$state_file"

restore_and_fail() {
    local message="$1"
    if git rev-parse -q --verify MERGE_HEAD >/dev/null; then
        git merge --abort >/dev/null 2>&1 || true
    fi
    git checkout "$source_branch" >/dev/null 2>&1 || true
    rm -f "$state_file"
    echo "error: $message" >&2
    exit 1
}

if ! git fetch origin test; then
    restore_and_fail "failed to fetch origin test"
fi

if ! git checkout test; then
    restore_and_fail "failed to checkout test"
fi

if ! git pull origin test; then
    restore_and_fail "failed to pull origin test"
fi

if git merge "$source_branch"; then
    merge_status="clean"
else
    if [ -n "$(git diff --name-only --diff-filter=U)" ]; then
        merge_status="conflicted"
    else
        restore_and_fail "merge failed without conflicts"
    fi
fi

echo "merge_status: $merge_status"
echo "source_branch: $source_branch"
echo "source_sha: $source_sha"
if [ "$merge_status" = "conflicted" ]; then
    echo "conflict_files:"
    git diff --name-only --diff-filter=U
fi
