#!/usr/bin/env bash
set -euo pipefail

git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
cd "$git_root"

state_file=".git/merge-to-test.state"
if [ ! -f "$state_file" ]; then
    echo "error: state file not found: $state_file" >&2
    exit 64
fi

# shellcheck disable=SC1090
source "$state_file"

current_branch="$(git branch --show-current)"
if [ "$current_branch" != "test" ]; then
    echo "error: finalize must run on test branch" >&2
    exit 65
fi

if [ -n "$(git diff --name-only --diff-filter=U)" ]; then
    echo "error: unresolved merge conflicts remain" >&2
    git diff --name-only --diff-filter=U >&2
    exit 66
fi

if ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    git add -A
fi

if git rev-parse -q --verify MERGE_HEAD >/dev/null; then
    git commit -m "chore: merge branch '$source_branch' into test"
fi

push_status="success"
if ! git push origin test; then
    push_status="failed"
    echo "error: push failed" >&2
    echo "source_branch: $source_branch" >&2
    echo "source_sha: $source_sha" >&2
fi

git checkout "$source_branch"
current_sha="$(git rev-parse HEAD)"
if [ "$current_sha" != "$source_sha" ]; then
    echo "error: original branch sha changed" >&2
    echo "source_branch: $source_branch" >&2
    echo "expected_sha: $source_sha" >&2
    echo "actual_sha: $current_sha" >&2
    exit 67
fi

rm -f "$state_file"
if [ "$push_status" = "failed" ]; then
    echo "merge_result: merged_not_pushed"
    echo "source_branch: $source_branch"
    echo "source_sha: $source_sha"
    exit 68
fi

echo "merge_result: pushed"
echo "source_branch: $source_branch"
echo "source_sha: $source_sha"
