# Module 6 — Advanced SRE & Capstone

## Duration: 6 Hours

---

## 6.1 Kubernetes Reliability Patterns

Kubernetes does not make your system reliable by itself. It provides the primitives; you must configure them correctly.

### 6.1.1 PodDisruptionBudget (PDB)

A PDB limits how many pods can be voluntarily disrupted at a time. Without it, node maintenance or cluster autoscaling can kill all replicas simultaneously.

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: transfer-service-pdb
spec:
  minAvailable: 2        # Keep at least 2 pods running
  selector:
    matchLabels:
      app: transfer-service
```

Or using `maxUnavailable`:

```yaml
spec:
  maxUnavailable: 1      # Never disrupt more than 1 pod at a time
```

**Why it matters:** Without a PDB, a node drain during an incident could kill all your transfer service pods simultaneously, causing downtime.

### 6.1.2 Topology Spread Constraints

Ensures pods are distributed across failure domains (nodes, zones, regions).

```yaml
spec:
  topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: topology.kubernetes.io/zone  # Spread across zones
      whenUnsatisfiable: DoNotSchedule
      labelSelector:
        matchLabels:
          app: transfer-service
```

**Why it matters:** If all pods run in one availability zone and that zone fails, the service is completely down. Spread constraints ensure pods are distributed.

### 6.1.3 Priority Classes

Critical services should not be evicted to make room for less important ones.

```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 1000
globalDefault: false
description: "Critical banking services"
---
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: low-priority
value: 100
globalDefault: false
description: "Batch jobs, non-critical workloads"
```

**Why it matters:** During resource contention, the scheduler evicts lower-priority pods first, protecting critical services.

### 6.1.4 Resource Requests and Limits

Without proper requests, pods can overcommit node resources and cause neighbour disruption.

```yaml
spec:
  containers:
    - name: transfer-service
      resources:
        requests:      # Guaranteed minimum
          memory: "256Mi"
          cpu: "250m"
        limits:        # Hard cap
          memory: "512Mi"
          cpu: "500m"
```

### 6.1.5 Cluster Autoscaler

Automatically adds/removes nodes based on unschedulable pods.

```yaml
# cluster-autoscaler config
autoDiscovery:
  clusterName: union-bank-production
maxNodeCount: 20
minNodeCount: 3
scaleDownEnabled: true
scaleDownDelayAfterAdd: 10m
```

### 6.1.6 Liveness, Readiness, and Startup Probes

Three probes serve different purposes:

| Probe | Purpose | Failure Action |
|-------|---------|---------------|
| **livenessProbe** | Is the app alive? (not hung) | Restart the pod |
| **readinessProbe** | Is the app ready to serve traffic? | Remove from Service |
| **startupProbe** | Has the app finished starting? | Delay liveness checks |

```yaml
spec:
  containers:
    - name: transfer-service
      livenessProbe:
        httpGet:
          path: /healthz
          port: 8080
        initialDelaySeconds: 30
        periodSeconds: 10
        failureThreshold: 3
      readinessProbe:
        httpGet:
          path: /ready
          port: 8080
        initialDelaySeconds: 5
        periodSeconds: 5
      startupProbe:
        httpGet:
          path: /startup
          port: 8080
        initialDelaySeconds: 0
        periodSeconds: 2
        failureThreshold: 30  # Allow 60 seconds to start
```

---

## 6.2 Capacity Planning

### The Process

**Step 1 — Measure current usage (90 days of data)**

```
Database disk usage:
  Jan 1:  1.2 TB
  Feb 1:  1.35 TB
  Mar 1:  1.5 TB
  Growth: ~150 GB/month

Current capacity: 2 TB
Remaining: 500 GB
Time to full: 500 ÷ 150 = 3.3 months
```

**Step 2 — Project forward with forecasting**

```promql
# Disk full prediction
predict_linear(
  node_filesystem_free_bytes{mountpoint="/data"}[30d],
  3600 * 24 * 365  # 1 year
) < 0
```

**Step 3 — Act at threshold**

| Threshold | Action |
|-----------|--------|
| < 50% | Normal operations |
| 50–70% | Plan capacity increase |
| 70–80% | Procure additional capacity |
| > 80% | Immediate action — this is an incident |

### Banking Capacity Events

| Event | Impact | Preparation |
|-------|--------|-------------|
| Salary payment day (25th–27th) | 3–5x ATM and transfer volume | Pre-scale 48h ahead |
| End of month | High transaction volume | Increase connection pools |
| Christmas / New Year | Peak ATM withdrawals | Ensure cash and network capacity |
| New product launch | Unpredictable spike | Load test before launch |
| CBN policy change | Compliance-driven surge | Coordinate with business |

---

## 6.3 SRE for Multi-Region Deployments

For critical banking services, consider multi-region deployment:

| Pattern | RTO | RPO | Cost |
|---------|-----|-----|------|
| Active-Passive | 5–15 min | 5 min | 2x |
| Active-Active | < 1 min | Near-zero | 3x+ |
| Cold Standby | 1–4 hours | 1 hour | 1.5x |

**Key implementation considerations:**
- Data consistency across regions (synchronous vs asynchronous replication)
- DNS-based traffic routing (route53, CloudDNS with health checks)
- Regional PDBs to prevent cross-region disruption
- Cross-region failover testing (at least quarterly)

---

## 6.4 AI-Driven Reliability

### Current State

| SRE Task | Traditional | AI-Assisted |
|----------|------------|-------------|
| Anomaly detection | Static thresholds | ML models learn normal patterns |
| Root cause analysis | Manual log search | AI correlates events across systems |
| Capacity forecasting | Linear extrapolation | ML with seasonality + growth curves |
| On-call routing | Fixed escalation | AI routes by past handling patterns |
| Post-mortem drafting | Manual from notes | AI drafts timeline from incident data |

### Practical Tools

- **Datadog AI** — anomaly detection, intelligent alerting
- **Dynatrace Davis AI** — automated root cause analysis
- **AWS DevOps Guru** — ML-powered operational recommendations
- **Claude / GPT-4** — runbook and post-mortem drafting

### Important Caveat

AI tools are **assistants, not replacements.** An AI can suggest a root cause — a human must verify it. AI can draft a post-mortem — a human must review it. The judgment, context, and accountability remain with the engineer.

---

## 6.5 Capstone Project (2.5 Hours)

### Brief

Your team has been hired as SRE consultants for Union Bank. The board has approved a reliability transformation initiative. One service has been assigned to your team.

**Options:**
- **A:** ATM Network (nationwide, 200+ ATMs, 24/7 operations)
- **B:** Mobile Banking App (1M+ users, fastest-growing channel)
- **C:** Online Transfer Service (inter-bank, NIP/NIBSS integrations)
- **D:** Internet Banking Portal (regulatory-sensitive, business customers)

### Deliverables

**1. Service Overview (10 min)**
- Define the service boundary
- Identify all dependencies (internal and external)
- Map the user journey
- Quantify business impact of 1-hour downtime

**2. SRE Framework (60 min)**

| Component | Requirements |
|-----------|-------------|
| SLIs | 4+ SLIs with formulas and aggregation strategy |
| SLOs | Targets with justification and safety margin analysis |
| Error Budget | Monthly budget calculation + policy (GREEN/YELLOW/RED/EXHAUSTED) |
| Burn Rate Alerts | 4 windows with thresholds and severity assignments |
| Monitoring | Prometheus metrics list (10+), Grafana dashboard design, log strategy |
| Runbooks | 3 runbooks for critical alerts |
| Toil Elimination | 3 toil items with automation plan and ROI estimate |
| On-Call | Rotation design for team of 8, escalation path |
| Chaos | 2 Game Day experiments with hypothesis, blast radius, and success criteria |
| K8s | Deployment YAML with PDB, probes, spread constraints, priority class |

**3. Presentation (15 min per group)**
- 10 min: Present your framework
- 5 min: Q&A from class

**Scoring Criteria:**

| Criteria | Weight |
|----------|--------|
| SLIs/SLOs are specific and measurable | 20% |
| Error budget policy is actionable | 15% |
| Burn rate alerts are properly configured | 15% |
| Runbooks are detailed and actionable | 15% |
| Toil elimination plan has real ROI | 10% |
| Chaos experiments test meaningful failure modes | 10% |
| K8s config follows reliability best practices | 10% |
| Presentation clarity and defence of decisions | 5% |

---

## 6.6 Course Close — 30-Day Action Plan

### Week 1
- [ ] Read Google SRE Book Chapters 1–4
- [ ] Identify 3 toil items in your team
- [ ] Propose one error budget to your team lead

### Week 2
- [ ] Define one SLI/SLO for a service you manage
- [ ] Install Prometheus + Grafana in test environment
- [ ] Configure 1 burn rate alert

### Week 3
- [ ] Write your first runbook
- [ ] Run one chaos experiment in staging
- [ ] Review one post-mortem from a past incident

### Week 4
- [ ] Present your SRE framework to your engineering manager
- [ ] Automate one toil item
- [ ] Schedule your first Game Day

---

## Key Terms

| Term | Definition |
|------|-----------|
| **PodDisruptionBudget** | Limits voluntary disruptions to pods during maintenance |
| **Topology Spread** | Distributes pods across failure domains (zones, regions) |
| **Priority Class** | Marks a pod's importance for scheduling and eviction decisions |
| **Cluster Autoscaler** | Automatically adds/removes nodes based on demand |
| **Multi-Region** | Deploying services across geographic regions for disaster recovery |
| **RTO** | Recovery Time Objective — max acceptable downtime |
| **RPO** | Recovery Point Objective — max acceptable data loss |
| **Game Day** | Structured chaos experiment with hypothesis and fix |

---

## Further Reading

- [Google SRE Book, Chapter 17 — Testing Reliability](https://sre.google/sre-book/testing-reliability/)
- [Google SRE Workbook, Chapter 10 — Production Readiness Review](https://sre.google/workbook/production-readiness-review/)
- [Kubernetes Production Patterns](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)
- [Chaos Engineering Principles](https://principlesofchaos.org/)
- [Multi-Region Deployment Patterns — AWS](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/multi-region-deployment.html)
