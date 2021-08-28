#!/bin/bash
set -euo pipefail

autorestic_config=/autorestic/config/autorestic.yml
autorestic_args="--ci"
if [[ $# -gt 0 ]]; then
  exec autorestic $autorestic_args --config ${autorestic_config} "$@"
else
  exec autorestic --config ${autorestic_config} --help
fi
