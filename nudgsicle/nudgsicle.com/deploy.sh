#!/bin/bash

set -Eeuo pipefail

[[ -d public ]] && rm -r public
hugo
aws s3 sync --delete public s3://nudgsicle-site
aws cloudfront create-invalidation --distribution-id E1MSCREMTPLF1T --paths "/*"
