# MODULE 4 — MONITORING & OBSERVABILITY
### Duration: 8 Hours | NIIT Fortesoft | Union Bank of Nigeria

---

## INSTRUCTOR OVERVIEW

Module 4 answers the question: *"How do you know your system is broken before your customer tells you?"* Monitoring and observability are what give SRE teams their eyes. Without this module, everything else — SLOs, error budgets, incident response — is guesswork.

**The three things every student must leave with today:**
1. They can explain the difference between monitoring and observability
2. They know what metrics, logs, and traces are and when to use each
3. They understand how to design alerting that actually works

---

## LESSON PLAN

| Time | Topic | Method |
|------|-------|--------|
| 0:00 – 0:30 | Recap Module 3 | Q&A |
| 0:30 – 1:30 | Monitoring vs Observability | Lecture |
| 1:30 – 2:30 | The three pillars — metrics, logs, traces | Lecture + examples |
| 2:30 – 3:00 | Break | — |
| 3:00 – 4:30 | Prometheus and Grafana | Demo + lab |
| 4:30 – 5:30 | ELK Stack for logs | Demo |
| 5:30 – 6:30 | Alerting design | Lecture + discussion |
| 6:30 – 7:30 | On-call management | Lecture + activity |
| 7:30 – 8:00 | Recap, Q&A, objectives check | Discussion |

---

## SECTION 1 — MONITORING VS OBSERVABILITY

These two words are often used interchangeably. They are not the same thing.

### Monitoring
Monitoring tells you **when** something is wrong.

It answers: *"Is this system up or down? Is this metric above or below the threshold?"*

Examples:
- Alert fires when CPU is above 90%
- Alert fires when the ATM API returns more than 1% errors
- Dashboard shows uptime percentage over the last 30 days

Monitoring is based on **known failure modes** — you set up alerts for problems you already know about.

### Observability
Observability tells you **why** something is wrong.

It answers: *"What exactly is happening inside this system right now, and why is it behaving this way?"*

Observability is based on **unknown failure modes** — it gives you the ability to investigate problems you have never seen before, using the data your system emits.

### The key difference

| Monitoring | Observability |
|-----------|--------------|
| Tells you something is wrong | Helps you understand why |
| Based on known failure patterns | Works for unknown failures too |
| Requires you to predict failures in advance | Lets you explore unexpected behaviour |
| "The alert fired" | "I can query the system to find the cause" |

**Analogy:**
- Monitoring is a car dashboard — it tells you the engine light is on
- Observability is a mechanic's diagnostic computer — it tells you exactly which sensor, which cylinder, and why

You need both. The alert (monitoring) wakes you up. The observability tools help you fix it fast.

---

## SECTION 2 — THE THREE PILLARS OF OBSERVABILITY

### Pillar 1 — Metrics

**What they are:** Numerical measurements collected over time.

**Format:** A number with a timestamp and labels.

```
atm_transaction_success_total{location="Lagos_Island", type="withdrawal"} 9950 1706745600
atm_transaction_total{location="Lagos_Island", type="withdrawal"} 10000 1706745600
```

**What metrics are good for:**
- Tracking trends over time (is error rate going up?)
- Triggering alerts when a threshold is crossed
- Powering dashboards and SLO calculations
- Capacity planning (when will we run out of disk space?)

**Banking metric examples:**

| Metric | What It Tracks |
|--------|---------------|
| `atm_withdrawal_success_rate` | % of ATM withdrawals that succeeded |
| `mobile_api_latency_seconds` | How long mobile API requests take |
| `transfer_errors_total` | Total number of failed transfers |
| `db_connections_active` | Current database connection count |
| `core_banking_request_duration` | How long core banking requests take |

---

### Pillar 2 — Logs

**What they are:** Time-stamped text records of events that happened inside the system.

**Format:**
```
2026-02-23 14:32:01 INFO  [ATM-001] Withdrawal request received: amount=50000, account=****1234
2026-02-23 14:32:01 INFO  [ATM-001] Balance check: passed
2026-02-23 14:32:02 INFO  [ATM-001] Dispensing cash: 50000 NGN
2026-02-23 14:32:02 INFO  [ATM-001] Transaction complete: ref=TXN-20260223-9921
2026-02-23 14:35:44 ERROR [ATM-001] Card reader failure: error_code=CR_047, retries=3
2026-02-23 14:35:44 ERROR [ATM-001] Transaction aborted: customer card retained
```

**What logs are good for:**
- Understanding exactly what happened in a specific transaction
- Debugging errors — the log tells you the exact line of code that failed
- Audit trails — who did what, when, in what order
- Incident investigation — reconstruct the sequence of events

**The problem with logs:** They are unstructured text. With millions of log lines per hour, you cannot read them manually — you need tools to search and filter them.

---

### Pillar 3 — Traces

**What they are:** A record of the complete journey of a single request through multiple services.

**When you need them:** Modern banking applications are not one system — a mobile transfer might touch 5–10 different services before completing.

```
Transfer Request → Mobile API → Auth Service → Core Banking → 
                  Fraud Check → Payment Gateway → SMS Service → Response
```

A trace shows you how long each step took and where the bottleneck is.

**Example trace:**
```
Transfer TXN-20260223-9921 — total: 4.2 seconds

  Mobile API gateway:      0.1s  ✅
  Authentication service:  0.3s  ✅
  Core banking system:     3.6s  ⚠️ ← SLOW — investigate here
  Fraud detection:         0.1s  ✅
  SMS notification:        0.1s  ✅
```

Without traces, you know the transfer took 4.2 seconds. With traces, you know exactly which service to fix.

---

## SECTION 3 — TOOLS

### Prometheus — Metrics Collection

Prometheus is an open-source tool that:
1. Scrapes (collects) metrics from your services every few seconds
2. Stores them in a time-series database
3. Lets you query them using a language called PromQL
4. Fires alerts when metrics cross thresholds

**Basic Prometheus config:**
```yaml
# prometheus.yml

global:
  scrape_interval: 15s  # Collect metrics every 15 seconds

scrape_configs:
  - job_name: 'atm-service'
    static_configs:
      - targets: ['atm-api:8080']

  - job_name: 'mobile-banking'
    static_configs:
      - targets: ['mobile-api:8080']

  - job_name: 'core-banking'
    static_configs:
      - targets: ['core-banking:9090']
```

**Basic PromQL queries:**
```
# Current error rate for ATM service
rate(atm_errors_total[5m]) / rate(atm_requests_total[5m])

# 99th percentile latency for mobile API (last hour)
histogram_quantile(0.99, rate(mobile_api_duration_seconds_bucket[1h]))

# Is the core banking system up?
up{job="core-banking"}
```

---

### Grafana — Dashboards

Grafana connects to Prometheus (and many other data sources) and displays metrics as visual dashboards.

**What a good SRE dashboard shows:**

For each critical service, display:
1. **Current availability** — is the service up right now?
2. **Error rate** — what % of requests are failing?
3. **Latency** — how long are requests taking? (show p50, p95, p99)
4. **Traffic** — how many requests per second?
5. **Error budget remaining** — how much of the monthly budget is left?

**Lab instructions:**

```bash
# Start Prometheus and Grafana with Docker
docker run -d \
  --name prometheus \
  -p 9090:9090 \
  -v ./prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus

docker run -d \
  --name grafana \
  -p 3000:3000 \
  grafana/grafana
```

Open http://localhost:3000 — login admin/admin — connect to Prometheus — build a dashboard.

---

### ELK Stack — Log Management

ELK = **Elasticsearch** + **Logstash** + **Kibana**

| Component | What It Does |
|-----------|-------------|
| **Logstash** | Collects logs from all your services and standardises the format |
| **Elasticsearch** | Stores the logs and makes them searchable instantly |
| **Kibana** | Visual interface to search, filter, and visualise logs |

**Practical use in a bank:**
- ATM throws an error at 2pm
- Engineer opens Kibana
- Filters logs for ATM-001, time range 13:55–14:10
- Finds the exact error message and stack trace in seconds
- Instead of SSHing into the ATM server and reading raw log files

---

## SECTION 4 — ALERTING DESIGN

### The problem with bad alerting

Most teams have too many alerts. When everything is alerting, nothing gets attention.

**Alert fatigue** = when engineers stop responding to alerts because there are so many false positives.

Signs of alert fatigue:
- Engineers silence alerts without investigating
- Same alert fires every day for months with no fix
- On-call engineers are exhausted from constant noise
- Real incidents get missed because they look like regular noise

---

### Principles of good alerting

**1. Alert on symptoms, not causes**

❌ Bad: Alert when CPU is above 90%
✅ Good: Alert when user-facing error rate exceeds 1%

CPU being high might not affect users at all. Errors definitely do.

**2. Every alert must be actionable**

Before creating an alert, answer: *"What will the on-call engineer do when this fires?"*
If the answer is "nothing we can do right now" — do not create the alert.

**3. Alerts should have runbooks**

Every alert should link to a runbook — a document that tells the on-call engineer exactly what to do:

```
Alert: ATM_HIGH_ERROR_RATE
Threshold: Error rate > 2% for 5 minutes
Severity: Critical

Runbook:
1. Check Grafana dashboard → ATM Services
2. Identify which ATM location(s) are affected
3. Check ATM logs in Kibana for error codes
4. If error code CR_047: call ATM hardware team (0802-xxx-xxxx)
5. If error code NW_001: check network connectivity to affected ATMs
6. If widespread: escalate to SRE lead immediately
7. Open incident ticket in Jira
```

**4. Use severity levels**

| Severity | Meaning | Response |
|----------|---------|----------|
| **Critical** | Customer-facing service is down or severely degraded | Wake someone up now |
| **Warning** | Service is degraded but still functional | Investigate within the hour |
| **Info** | Something notable happened | Review during business hours |

---

### Prometheus alerting rules example

```yaml
# alerts.yml

groups:
  - name: banking_alerts
    rules:

      - alert: ATMHighErrorRate
        expr: rate(atm_errors_total[5m]) / rate(atm_requests_total[5m]) > 0.02
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "ATM error rate above 2%"
          description: "ATM error rate is {{ $value | humanizePercentage }}. Check Grafana."
          runbook: "https://wiki.unionbank.internal/runbooks/atm-errors"

      - alert: MobileAPIHighLatency
        expr: histogram_quantile(0.99, rate(mobile_api_duration_seconds_bucket[5m])) > 3
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Mobile API p99 latency above 3 seconds"
          description: "99th percentile latency is {{ $value }}s. Users may be experiencing slowness."
```

---

## SECTION 5 — ON-CALL MANAGEMENT

### What on-call means

On-call = an engineer is designated as the first responder for alerts during a defined period (e.g. this week, tonight, this weekend).

When an alert fires — that engineer responds within a defined time (e.g. 5 minutes for Critical, 30 minutes for Warning).

### Building a healthy on-call rotation

**Rules for a good rotation:**
1. No engineer should be on-call more than 1 week in every 4
2. On-call hours outside business hours must be compensated
3. Engineers should not be on-call for systems they did not build
4. After an on-call shift, review the number of pages — more than 2 per shift means something needs fixing

### Escalation policy

```
Primary on-call receives alert
        ↓
No response in 10 minutes
        ↓
Secondary on-call is paged
        ↓
No response in 10 minutes
        ↓
SRE Team Lead is paged
        ↓
No response in 10 minutes
        ↓
CTO / Head of Technology is notified
```

---

## SECTION 6 — CLASSROOM ACTIVITY (1 HOUR)

### Activity: "Design a Dashboard"

**Instructions:**

Groups of 3 are given this scenario:

> *You are the SRE team for Union Bank's mobile banking app. You need to build a monitoring dashboard that will tell you — at a glance — whether the service is healthy right now.*

Each group must define:
1. **Five metrics** to display — name each one and explain why it matters
2. **Three alerts** — write the condition, severity, and what the on-call engineer should do
3. **One runbook** — for their most critical alert, write step-by-step response instructions

Groups present their dashboard design. Class votes on which design would catch problems fastest.

---

## SECTION 7 — RECAP & LEARNING OBJECTIVES CHECK

- [ ] Can you explain the difference between monitoring and observability?
- [ ] Can you define metrics, logs, and traces and give one banking example of each?
- [ ] Can you explain what Prometheus and Grafana are used for?
- [ ] Can you describe what makes a good alert versus a bad alert?
- [ ] Can you explain what alert fatigue is and how to prevent it?
- [ ] Can you describe how an on-call rotation works?

---

## KEY TERMS — MODULE 4

| Term | Definition |
|------|-----------|
| **Monitoring** | Watching known metrics and alerting when they cross thresholds |
| **Observability** | The ability to understand the internal state of a system from its outputs |
| **Metrics** | Numerical measurements collected over time |
| **Logs** | Timestamped text records of events inside a system |
| **Traces** | Records of a request's complete journey through multiple services |
| **Prometheus** | Open-source tool for collecting and storing metrics |
| **Grafana** | Open-source tool for visualising metrics as dashboards |
| **ELK Stack** | Elasticsearch + Logstash + Kibana — for log management |
| **Alert fatigue** | When too many alerts cause engineers to ignore or silence them |
| **Runbook** | Step-by-step instructions for responding to a specific alert |
| **On-call** | The engineer designated to respond to alerts during a defined period |
| **p99 latency** | The response time that 99% of requests complete within |

---

## FURTHER READING — MODULE 4

- [Google SRE Book, Chapter 6 — Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Grafana Getting Started](https://grafana.com/docs/grafana/latest/getting-started/)
