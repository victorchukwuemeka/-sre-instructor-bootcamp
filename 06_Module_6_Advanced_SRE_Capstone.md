# MODULE 6 — ADVANCED SRE & CAPSTONE
### Duration: 6 Hours | NIIT Fortesoft | Union Bank of Nigeria

---

## INSTRUCTOR OVERVIEW

Module 6 is the final module. The first half covers advanced topics — capacity planning, cloud-native SRE, and AI in reliability. The second half is the capstone project where every participant builds a complete SRE framework for a Union Bank service and presents it to the class. This is where everything comes together. Leave at least 2.5 hours for the capstone.

**The three things every student must leave with today:**
1. They understand capacity planning and why it matters for banks
2. They know what Kubernetes is and what role it plays in SRE
3. They have built and presented a complete SRE framework

---

## LESSON PLAN

| Time | Topic | Method |
|------|-------|--------|
| 0:00 – 0:30 | Recap Module 5 | Q&A |
| 0:30 – 1:15 | Capacity planning | Lecture |
| 1:15 – 2:00 | SRE in cloud-native (Kubernetes) | Lecture + demo |
| 2:00 – 2:30 | AI-driven reliability | Lecture + discussion |
| 2:30 – 3:00 | Break + capstone briefing | — |
| 3:00 – 5:00 | Capstone project — group work | Group work |
| 5:00 – 5:45 | Capstone presentations | Presentations |
| 5:45 – 6:00 | Course close, certificates, next steps | Ceremony |

---

## SECTION 1 — CAPACITY PLANNING

### What is capacity planning?

Capacity planning is the practice of **predicting when your system will run out of resources** — and acting before it happens.

Without it:
- Your database disk fills up → system crashes → incident
- Traffic spikes during salary day → servers overloaded → customers cannot transact
- A marketing campaign drives 5x normal traffic → mobile app collapses

With it:
- You see the disk filling up 3 weeks in advance and expand it
- You scale up servers the day before salary payments hit
- You test whether your system can handle a campaign before it launches

---

### The four resources to watch

| Resource | What Runs Out | Warning Sign |
|----------|--------------|--------------|
| **CPU** | Processing power | CPU consistently above 70% |
| **Memory (RAM)** | Working memory | Memory usage trending up week-over-week |
| **Disk** | Storage space | Disk usage growing faster than expected |
| **Network** | Bandwidth | Latency increasing during peak hours |

---

### How to do capacity planning

**Step 1 — Measure current usage**

Use Prometheus to track resource usage over the last 90 days.

**Step 2 — Calculate growth rate**

```
Example: Database disk usage

January 1:  1.2 TB used
February 1: 1.35 TB used
March 1:    1.5 TB used

Growth: ~150 GB per month

Current capacity: 2 TB
Remaining: 500 GB

Time to full: 500 ÷ 150 = 3.3 months → disk full by mid-June
```

**Step 3 — Project forward**

Plot the trend line. Identify when you will hit 80% capacity (your warning threshold).

**Step 4 — Act in advance**

Do not wait until you hit 100%. When you hit 80%:
- Order additional capacity
- Archive old data if possible
- Optimise database queries to reduce growth rate

---

### Banking-specific capacity events to plan for

| Event | Expected Traffic Impact | Preparation |
|-------|------------------------|-------------|
| Salary payment day (25th–27th) | 3–5x normal ATM and transfer volume | Pre-scale servers 48 hours ahead |
| End of month | High transaction volume | Increase database connection pools |
| Christmas / New Year | High ATM withdrawals | Ensure ATM cash levels and network capacity |
| New product launch | Unpredictable spike | Load test before launch, have scaling plan ready |
| CBN policy change | Compliance-driven transaction surge | Coordinate with business teams for forecasts |

---

## SECTION 2 — SRE IN CLOUD-NATIVE ENVIRONMENTS

### What "cloud-native" means

Cloud-native means building applications designed to run in the cloud, taking full advantage of cloud infrastructure: automatic scaling, self-healing, distributed deployment.

The key technology here is **Kubernetes.**

---

### What Kubernetes does

Kubernetes is a system that manages containers — packaged versions of your applications — across a cluster of servers.

**The problem it solves:**

In a traditional environment:
- Transfer service runs on Server 12
- If Server 12 crashes → Transfer service is down until someone manually moves it
- If traffic spikes → You manually spin up more servers

With Kubernetes:
- Transfer service runs as a container that Kubernetes manages
- If the container crashes → Kubernetes automatically restarts it (usually in under 30 seconds)
- If traffic spikes → Kubernetes automatically adds more container instances
- If a server dies → Kubernetes automatically moves containers to healthy servers

---

### Key Kubernetes concepts for SRE

| Concept | What It Is | Why It Matters |
|---------|-----------|----------------|
| **Pod** | The smallest unit — one running container | If it crashes, Kubernetes restarts it |
| **Deployment** | Manages multiple identical pods | Ensures your app always has the right number of instances running |
| **Service** | Routes traffic to your pods | Load balances between instances automatically |
| **Namespace** | Logical grouping of resources | Separates dev, test, and production environments |
| **Health check** | A test Kubernetes runs on each pod | Automatically removes unhealthy pods from traffic |
| **Auto-scaler** | Scales pods up/down based on load | Handles traffic spikes without manual intervention |

---

### SRE benefits of Kubernetes

| Old Way | With Kubernetes |
|---------|----------------|
| Service crashes → manual restart → minutes of downtime | Service crashes → Kubernetes restarts → seconds of downtime |
| Traffic spike → manually provision servers (hours) | Traffic spike → auto-scaler adds pods (seconds to minutes) |
| Deploy new version → risk of downtime | Rolling deployment → zero downtime |
| Server dies → manual failover | Server dies → Kubernetes reschedules automatically |

---

### Basic Kubernetes demo

```yaml
# transfer-service-deployment.yml
# Run the Transfer Service with 3 replicas
# Kubernetes will restart any crashed pods automatically

apiVersion: apps/v1
kind: Deployment
metadata:
  name: transfer-service
  namespace: production
spec:
  replicas: 3  # Always keep 3 instances running
  selector:
    matchLabels:
      app: transfer-service
  template:
    metadata:
      labels:
        app: transfer-service
    spec:
      containers:
      - name: transfer-service
        image: unionbank/transfer-service:v2.1.4
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:   # Kubernetes checks this — restarts pod if it fails
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
```

```bash
# Apply the deployment
kubectl apply -f transfer-service-deployment.yml

# Watch pods running
kubectl get pods -n production

# Check what happens when a pod crashes
kubectl delete pod transfer-service-abc123 -n production
# Watch Kubernetes immediately create a replacement
```

---

## SECTION 3 — AI-DRIVEN RELIABILITY

### How AI is changing SRE

Artificial Intelligence is beginning to change how SRE teams work. This is not replacing SRE engineers — it is giving them better tools.

| SRE Task | Traditional Approach | AI-Assisted Approach |
|----------|---------------------|---------------------|
| **Anomaly detection** | Set static thresholds for alerts | ML models learn normal patterns and alert on deviations, even new ones |
| **Root cause analysis** | Engineer manually searches logs and metrics | AI correlates events across systems and suggests likely causes |
| **Capacity forecasting** | Extrapolate linear trends | ML models factor in seasonality, events, and growth curves |
| **On-call routing** | Defined escalation paths | AI routes alerts based on who has handled similar incidents before |
| **Post-mortem drafting** | Engineer writes from notes | AI drafts the timeline and contributing factors from incident data |

### Practical AI tools for SRE today

- **Datadog AI** — anomaly detection and intelligent alerting
- **Dynatrace Davis AI** — automated root cause analysis
- **AWS DevOps Guru** — ML-powered operational recommendations
- **OpenAI / Claude** — assist with writing runbooks, post-mortems, and documentation

### The important caveat

AI tools are assistants, not replacements. An AI can suggest a root cause — an engineer must verify it. An AI can draft a post-mortem — an engineer must review and approve it. The judgment, context, and accountability remain human.

---

## SECTION 4 — CAPSTONE PROJECT (2.5 HOURS)

### Instructions

Each group of 3 will design a **complete SRE framework** for one of the following Union Bank services:

- **Option A:** ATM Network (nationwide)
- **Option B:** Mobile Banking Application
- **Option C:** Online Transfer Service
- **Option D:** Internet Banking Portal

---

### What your framework must include

**1. Service Overview (5 minutes to write)**
- What does this service do?
- Who uses it?
- What is the business impact if it goes down for 1 hour?

**2. SLIs and SLOs (20 minutes)**
Define at least 3 SLIs with their measurement formulas. Set an SLO for each.

| SLI | Formula | SLO |
|-----|---------|-----|
| Availability | Successful requests / Total requests | 99.9% |
| Latency | Requests under 2s / Total requests | 95% |
| Error rate | Successful requests / Total requests | 99.5% |

**3. Error Budget Policy (15 minutes)**
Write a short error budget policy covering:
- Monthly error budget in minutes
- What happens at 50% consumed
- What happens at 80% consumed
- What happens when fully consumed

**4. Monitoring Plan (15 minutes)**
List:
- 5 metrics you will track
- 3 alerts you will set (include threshold, severity, and what the on-call engineer does)
- Which tools you will use (Prometheus, Grafana, ELK)

**5. Toil Elimination Plan (15 minutes)**
Identify:
- 3 toil tasks currently done manually
- How you would automate each one
- Estimated hours saved per month

**6. On-Call and Incident Plan (15 minutes)**
Define:
- On-call rotation structure
- Escalation path (4 levels)
- One runbook for your most critical alert

**7. Chaos Engineering Plan (15 minutes)**
Design one chaos experiment:
- What failure will you introduce?
- What do you expect to happen?
- How will you measure the result?
- What will you fix based on what you learn?

---

### Presentation format (15 minutes per group)

- 10 minutes: present your framework
- 5 minutes: questions from class and instructor

**Scoring criteria:**
- Are the SLOs realistic for a Nigerian banking environment?
- Is the error budget policy actionable?
- Are the alerts specific and linked to runbooks?
- Is the toil elimination plan practical?
- Does the chaos experiment test something real?

---

## SECTION 5 — COURSE CLOSE

### What participants should do in the next 30 days

**Week 1:**
- Read Google SRE Book Chapters 1–4
- Identify and document three toil items in your current team
- Bring the error budget concept to your next team meeting

**Week 2:**
- Propose one SLI and SLO for one service your team manages
- Install Prometheus and Grafana in your test environment

**Week 3:**
- Write your first runbook for your most common alert
- Run a simple chaos experiment in a safe test environment

**Week 4:**
- Present your SRE framework (built during capstone) to your engineering manager
- Identify your first automation candidate and estimate the time savings

---

### Key resources to bookmark

- [Google SRE Book](https://sre.google/sre-book/introduction/) — free, read it all
- [Google SRE Workbook](https://sre.google/workbook/) — practical exercises
- [Prometheus Docs](https://prometheus.io/docs/)
- [Grafana Docs](https://grafana.com/docs/)
- [Kubernetes Docs](https://kubernetes.io/docs/home/)
- [Ansible Docs](https://docs.ansible.com/)
- [Terraform Docs](https://developer.hashicorp.com/terraform/docs)

---

## SECTION 6 — RECAP & FINAL LEARNING OBJECTIVES CHECK

Go through these with the full class:

**Module 1 — Foundation**
- [ ] SRE in one sentence
- [ ] Why 100% uptime is a bad goal
- [ ] What toil is and why it matters

**Module 2 — Metrics**
- [ ] Define SLI, SLO, SLA
- [ ] Calculate an error budget
- [ ] Write an error budget policy

**Module 3 — Automation**
- [ ] Identify toil in any team
- [ ] Explain what Ansible, Terraform, and Python are used for
- [ ] Read a basic automation script

**Module 4 — Observability**
- [ ] Difference between monitoring and observability
- [ ] Metrics, logs, traces — when to use each
- [ ] Design an alert that is actionable and not noisy

**Module 5 — Incidents**
- [ ] Walk through the incident lifecycle
- [ ] Explain the four incident roles
- [ ] Write a blameless post-mortem

**Module 6 — Advanced**
- [ ] Explain capacity planning and why it matters
- [ ] Explain what Kubernetes does for SRE teams
- [ ] Present a complete SRE framework

---

## KEY TERMS — MODULE 6

| Term | Definition |
|------|-----------|
| **Capacity planning** | Predicting when resources will run out and acting before they do |
| **Kubernetes** | A system that manages and auto-heals containerised applications |
| **Container** | A packaged, portable version of an application and its dependencies |
| **Auto-scaling** | Automatically adding or removing instances based on current load |
| **Rolling deployment** | Updating an application gradually with zero downtime |
| **Health check** | A test run on each pod — failing pods are removed from traffic automatically |
| **Anomaly detection** | Using ML to identify unusual behaviour that static thresholds would miss |
| **Cloud-native** | Applications designed to run on cloud infrastructure and take advantage of its capabilities |

---

## FURTHER READING — MODULE 6

- [Google SRE Book, Chapter 17 — Testing Reliability](https://sre.google/sre-book/testing-reliability/)
- [Google SRE Book, Chapter 18 — Software Engineering in SRE](https://sre.google/sre-book/software-engineering-in-sre/)
- [Kubernetes Documentation](https://kubernetes.io/docs/concepts/overview/)
- [Chaos Engineering Principles](https://principlesofchaos.org/)
