# SRE COURSE — MODULE 3 INSTRUCTOR NOTE
### Monitoring and Observability

---

## 1. One Sentence You Must Remember
**You can’t fix what you can’t see.**

---

## 2. The Three Pillars (Say This)
- **Metrics:** How many, how fast, how full
- **Logs:** What happened
- **Traces:** Where it happened

Short line:
**Metrics tell you “how many,” logs tell you “what,” traces tell you “where.”**

---

## 3. Why Monitoring Matters
- It prevents outages from becoming disasters.
- It shows trends before customers feel pain.
- It gives fast answers during incidents.

---

## 4. The Four Golden Signals
Use these as your core monitoring checklist:
- **Latency**
- **Traffic**
- **Errors**
- **Saturation**

---

## 5. Demo Script (Use This Live)
Say this out loud:
“We’re going to run Prometheus and Grafana.  
Prometheus collects metrics. Grafana makes them visible.  
If you can see it, you can control it.”

---

## 6. Practical Lab (What You Run)
Folder: `sre-labs/03-monitoring/`
1. Start stack: `docker compose up -d`
2. Open Grafana: `http://localhost:3000` (admin/admin)
3. Add data source: Prometheus `http://prometheus:9090`
4. Create a panel with the metric `up`

---

## 7. Alerting vs Monitoring (Clear Difference)
- **Monitoring** tells you what is happening.
- **Alerting** tells you when you must act.

Short line:
**“Dashboards are for insight. Alerts are for action.”**

---

## 8. Teaching Script — First 10 Minutes
“Monitoring is how we see the health of a system.  
Metrics show volume and speed, logs explain events, and traces show the path.  
We watch latency, traffic, errors, and saturation.  
Then we alert only when action is required.”

---

## 9. Student Learning Objectives
- Explain metrics, logs, and traces
- Run a basic monitoring stack
- Create a simple dashboard panel
- Explain the four golden signals

---

## 10. Cheat Sheet for Teaching Day
- Metrics: numbers over time
- Logs: events and messages
- Traces: request journeys
- Golden signals: latency, traffic, errors, saturation
- Prometheus collects, Grafana displays

