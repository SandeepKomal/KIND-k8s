#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-single}"
CONFIG="kind/single-node.yaml"

case "$MODE" in
  single) CONFIG="kind/single-node.yaml" ;;
  multi) CONFIG="kind/multi-node.yaml" ;;
  *) echo "Usage: $0 [single|multi]"; exit 1 ;;
esac

command -v kind >/dev/null || { echo "kind is required"; exit 1; }
command -v kubectl >/dev/null || { echo "kubectl is required"; exit 1; }
command -v docker >/dev/null || { echo "docker is required"; exit 1; }

kind create cluster --config "$CONFIG"
kubectl cluster-info --context kind-kind
kubectl get nodes -o wide
