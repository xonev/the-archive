#!/bin/bash

set -Eeuo pipefail

[[ -d public ]] && rm -r public
hugo
aws s3 --profile nudge-prod sync --delete public s3://nudgsicle-site-prod
aws cloudfront --profile nudge-prod create-invalidation --distribution-id E1WWVC3R5DZOPA --paths "/*"
