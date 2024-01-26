#!/bin/bash

set -Eeuo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: push.sh UID version"
    exit 1
fi

image_name="xonev/debug-$1"
version="$2"
docker push "$image_name":latest
docker push "$image_name":"$version"