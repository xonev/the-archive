#!/bin/bash

set -Eeuo pipefail

[[ -d public ]] && rm -r public
hugo

export AWS_PROFILE=nudge-prod
hugo deploy --logLevel info
