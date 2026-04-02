#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

say() {
  printf "\n=== %s ===\n" "$1"
}

say "01 SLI/SLO"
python "$ROOT_DIR/01-sli-slo/availability_calc.py" || true

say "02 Toil/Automation"
python "$ROOT_DIR/02-toil-automation/db_health_check.py" || true

say "03 Monitoring (Docker Compose)"
if command -v docker >/dev/null 2>&1; then
  (cd "$ROOT_DIR/03-monitoring" && docker compose up -d) || true
  echo "Grafana: http://localhost:3000 (admin/admin)"
else
  echo "Docker not found. Skip monitoring demo."
fi

say "04 Incident"
"$ROOT_DIR/04-incident/chaos_kill.sh" || true

say "05 Kubernetes"
if command -v kubectl >/dev/null 2>&1; then
  kubectl create deployment hello --image=nginx || true
  kubectl delete pod -l app=hello || true
  kubectl get pods || true
else
  echo "kubectl not found. Skip k8s demo."
fi

say "Done"
