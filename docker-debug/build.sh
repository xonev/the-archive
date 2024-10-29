#!/bin/bash

set -Eeuo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: build.sh UID [version]"
    exit 1
fi

user_id="$1"
image_name="xonev/debug-$user_id"
docker build --platform=linux/amd64 --build-arg "userId=$user_id" --tag "$image_name":latest .

if [[ $# -eq 2 ]]; then
    version="$2"
    docker tag "$image_name":latest "$image_name":"$version"
fi
