#!/usr/bin/env bash
set -euo pipefail

message_file="${1:-}"

if [ -z "$message_file" ]; then
    echo "error: missing commit message file" >&2
    echo "usage: $0 <message-file>" >&2
    exit 64
fi

if [ ! -f "$message_file" ]; then
    echo "error: commit message file not found: $message_file" >&2
    exit 65
fi

if [ ! -s "$message_file" ]; then
    echo "error: commit message file is empty: $message_file" >&2
    exit 66
fi

git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
cd "$git_root"

current_branch="$(git branch --show-current)"
if [ -z "$current_branch" ]; then
    echo "error: detached HEAD is not supported" >&2
    exit 67
fi

upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
if [ -z "$upstream" ]; then
    echo "error: current branch has no upstream" >&2
    exit 68
fi

if git diff --cached --quiet; then
    echo "error: no staged changes to commit" >&2
    exit 69
fi

git commit -F "$message_file"
commit_hash="$(git rev-parse --short HEAD)"

if ! git pull --rebase; then
    echo "error: rebase failed after local commit; local commit was not pushed" >&2
    echo "local_commit: $commit_hash" >&2
    echo "current_branch: $current_branch" >&2
    exit 70
fi

if ! git push; then
    echo "error: push failed after local commit" >&2
    echo "local_commit: $commit_hash" >&2
    echo "current_branch: $current_branch" >&2
    exit 71
fi

echo "committed_and_pushed: $commit_hash"
echo "current_branch: $current_branch"
