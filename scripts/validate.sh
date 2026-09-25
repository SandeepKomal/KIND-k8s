#!/usr/bin/env bash
set -euo pipefail
command -v kubectl >/dev/null || { echo "kubectl is required"; exit 1; }
kubectl apply --dry-run=client -f examples/app/
kubectl apply --dry-run=client -f examples/security/
bash -n scripts/*.sh
echo "Validation completed."
