#!/bin/bash

set -Eeuo pipefail

personal_projects_dir="${HOME}/workspace/the-archive/private/obsidian/personal-gtd/projects"
template_file="${personal_projects_dir}/finances-template.md"

cp "$template_file" "${personal_projects_dir}/$(date "+%Y-%m-%d")-finances.md"
