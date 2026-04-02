#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

say() {
  printf "\n=== %s ===\n" "$1"
}

say "Monitoring Cleanup"
if command -v docker >/dev/null 2>&1; then
  (cd "$ROOT_DIR/03-monitoring" && docker compose down) || true
else
  echo "Docker not found. Skip."
fi

say "Kubernetes Cleanup"
if command -v kubectl >/dev/null 2>&1; then
  kubectl delete deployment hello || true
else
  echo "kubectl not found. Skip."
fi

say "Done"
