#!/bin/bash

JUPYTER_VERSION=3.3
ORCHESTRATOR_VERSION=3.3
SEEQ_VERSION=3.3

render_template() {
  eval "cat <<-EOF
		$(cat)
	EOF"
}

render_template < custom.template.css
