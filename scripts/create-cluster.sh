#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"

MODE="${1:-single}"

case "$MODE" in
  single)
    CONFIG="$REPO_ROOT/kind/single-node.yaml"
    ;;
  multi)
    CONFIG="$REPO_ROOT/kind/multi-node.yaml"
    ;;
  *)
    echo "Usage: $0 [single|multi]"
    exit 1
    ;;
esac

command -v kind >/dev/null || { echo "kind is required"; exit 1; }
command -v kubectl >/dev/null || { echo "kubectl is required"; exit 1; }
command -v docker >/dev/null || { echo "docker is required"; exit 1; }

[[ -f "$CONFIG" ]] || { echo "ERROR: Kind config not found: $CONFIG"; exit 1; }

kind create cluster --config "$CONFIG"
kubectl cluster-info --context kind-kind
kubectl get nodes -o wide
