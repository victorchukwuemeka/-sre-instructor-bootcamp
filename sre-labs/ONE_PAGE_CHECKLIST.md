# One-Page Live Checklist

## Pre-Class (30 mins)
- Docker runs
- Grafana reachable
- kubectl works
- `sre-labs/run_all.sh` runs

## Live Demo Order (30 mins)
- SLI/SLO: `python 01-sli-slo/availability_calc.py`
- Toil/Automation: `python 02-toil-automation/db_health_check.py`
- Monitoring: `docker compose up -d` then Grafana panel `up`
- Incident: `./04-incident/chaos_kill.sh` + show template
- K8s: `kubectl delete pod -l app=hello` and show recreation

## Teach Reminders
- Define SLI vs SLO vs SLA
- Explain error budgets in plain words
- “Metrics tell how many, logs tell what, traces tell where”
- Blameless post‑mortem focus
- K8s keeps desired state running

## Emergency Fallbacks
- If Docker fails: use slides + explain metrics/logs/traces
- If k8s fails: use explanation + diagram
- If DB check fails: explain socket check + show code
