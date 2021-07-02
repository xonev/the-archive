#!/bin/bash

set -x

for dir in "$@"; do
    git worktree remove "$dir"
done
