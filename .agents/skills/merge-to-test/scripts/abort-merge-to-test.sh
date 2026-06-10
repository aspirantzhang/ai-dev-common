#!/usr/bin/env bash
set -euo pipefail

git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
cd "$git_root"

state_file=".git/merge-to-test.state"
if [ ! -f "$state_file" ]; then
    echo "error: state file not found: $state_file" >&2
    exit 64
fi

source_branch=""
source_sha=""
# shellcheck disable=SC1090
source "$state_file"

if git rev-parse -q --verify MERGE_HEAD >/dev/null; then
    git merge --abort
fi

git checkout "$source_branch"
current_sha="$(git rev-parse HEAD)"
if [ "$current_sha" != "$source_sha" ]; then
    echo "error: original branch sha changed" >&2
    echo "source_branch: $source_branch" >&2
    echo "expected_sha: $source_sha" >&2
    echo "actual_sha: $current_sha" >&2
    exit 65
fi

rm -f "$state_file"
echo "merge_result: aborted"
echo "source_branch: $source_branch"
echo "source_sha: $source_sha"
