# Lab 3: Monitoring & Observability Stack

## Objective

Deploy a complete monitoring stack, write advanced PromQL queries, and configure SLO-based alerting.

## Part 1 — Deploy Prometheus + Grafana

```bash
docker compose up -d
```

Access:
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (admin/admin)

**Verify:** Prometheus is scraping itself. Run a query: `up`

## Part 2 — PromQL Exercises

Complete these queries against the Prometheus demo data:

1. **Rate vs Irate:** Run `rate(prometheus_http_requests_total[5m])` and `irate(prometheus_http_requests_total[5m])`. Observe the difference.

2. **p99 Latency:** If you had a histogram metric, write the query for p99 latency over 5 minutes.

3. **Prediction:** Write a query that predicts when a metric will reach zero using `predict_linear`.

4. **Burn Rate:** Write a PromQL query that calculates the current SLO burn rate for a 99.9% SLO.

## Part 3 — Configure Burn Rate Alerts

Create a `alerts.yml` file with:

1. **Fast burn alert** — 1-hour window, burn rate > 2, severity critical
2. **Medium burn alert** — 6-hour window, burn rate > 1, severity critical
3. **Slow burn alert** — 3-day window, burn rate > 0.5, severity warning

Add it to your Prometheus config and reload:

```yaml
rule_files:
  - "alerts.yml"
```

## Part 4 — Challenge: Dashboard Design

In Grafana, create a dashboard for the "ATM Network" that includes:

1. Current availability (gauge, 0-100%)
2. Error rate (time series, last 1 hour)
3. Burn rate (stat, current value)
4. Budget remaining (gauge, 0-100%)
5. Top 5 error locations (table)

Share the dashboard JSON with your group.
