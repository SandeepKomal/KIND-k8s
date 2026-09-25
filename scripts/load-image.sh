#!/usr/bin/env bash
set -euo pipefail
IMAGE="${1:-}"
[[ -n "$IMAGE" ]] || { echo "Usage: $0 <image:tag>"; exit 1; }
docker image inspect "$IMAGE" >/dev/null
kind load docker-image "$IMAGE" --name kind
