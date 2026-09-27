#!/usr/bin/env bash
set -euo pipefail
command -v kubectl >/dev/null || { echo "kubectl is required"; exit 1; }
kubectl apply --dry-run=client -f examples/security/
kubectl apply --dry-run=client -f examples/app/
bash -n scripts/*.sh
echo "Validation completed."
