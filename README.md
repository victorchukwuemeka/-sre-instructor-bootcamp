# Fast Assimilation Course (4-Day Sprint)
You want speed and retention. This is the shortest safe path to instructor-ready. Each day is 5–7 focused hours. If you have less time, do the **Must-Teach** items only.

## Day 1 (Today): SRE Mindset + SLI/SLO/SLA + Error Budgets
**Goal:** Teach this clearly without notes.
- **Must-Teach (2.5 hours):**
  - Read/skim SRE Book Ch. 1–4 summaries.
  - Write a 3-minute explanation: SRE vs DevOps, SLI/SLO/SLA.
  - Error budget math: `Availability = Good / Total` and translate to downtime per year.
- **Demo Prep (1 hour):**
  - Create a simple availability example in a spreadsheet.
- **Teach-Back (30 mins):**
  - Record yourself explaining “error budget” in 2 minutes.

## Day 2: Toil + Automation + Infra as Code
**Goal:** Show one automation script and explain toil.
- **Must-Teach (2 hours):**
  - Define toil, give 3 examples, and explain why it’s bad.
- **Demo Prep (2 hours):**
  - Write a tiny Python or Bash script that checks DB health.
  - Explain “If you do it twice, automate it.”
- **Quick IaC (1 hour):**
  - Terraform: show a minimal config and explain what “state” means (no deep cloud).

## Day 3: Monitoring + Observability (Hard Day)
**Goal:** Run a monitoring stack and explain metrics/logs/traces.
- **Must-Teach (2 hours):**
  - Explain: Metrics = how many, Logs = what happened, Traces = where.
- **Demo Prep (3 hours):**
  - Run Prometheus + Grafana via Docker Compose.
  - Create one Grafana dashboard panel with a fake metric.
- **Teach-Back (30 mins):**
  - Explain the monitoring pipeline from memory.

## Day 4: Incident Mgmt + Chaos + Kubernetes Basics
**Goal:** Lead a blameless post‑mortem + show k8s crash/restart.
- **Must-Teach (2 hours):**
  - Post‑mortem template: Timeline, Root Cause, Impact, Action Items.
  - “Why did the system fail that way?” mindset.
- **Demo Prep (2 hours):**
  - Run a simple chaos experiment (kill a process, document impact).
- **K8s Basics (2 hours):**
  - Deploy hello‑world, delete a pod, watch it restart.

## Last‑Night Checklist (1–2 hours)
- Dry run a 10‑minute mini‑lecture for Modules 1–3.
- Ensure Docker + WSL2 + VS Code + MariaDB client work.
- Pick one war story and outline it.

---

# Practical Labs (Folders + Exact Commands)
Use this exact folder layout and run the commands in order. Keep everything inside one workspace so you can demo cleanly.

## 0) Create the Lab Folder Structure (5 minutes)
```bash
mkdir -p sre-labs/{01-sli-slo,02-toil-automation,03-monitoring,04-incident,05-k8s}
cd sre-labs
```

## 1) SLI/SLO/Error Budget Practical (15 minutes)
```bash
cd 01-sli-slo
cat > availability_calc.py <<'PY'
good = 99990
total = 100000
availability = (good / total) * 100
print(f"Availability: {availability:.4f}%")
print("Annual downtime for 99.9% = 8h 45m 36s")
print("Annual downtime for 99.99% = 52m 33s")
PY
python availability_calc.py
```

## 2) Toil vs Automation Practical (30 minutes)
```bash
cd ../02-toil-automation
cat > db_health_check.py <<'PY'
import socket

HOST = "127.0.0.1"
PORT = 3306

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.settimeout(2)
    try:
        s.connect((HOST, PORT))
        print("DB is reachable")
    except Exception as e:
        print(f"DB is not reachable: {e}")
PY
python db_health_check.py
```

## 3) Monitoring Practical (Prometheus + Grafana) (45–60 minutes)
```bash
cd ../03-monitoring
cat > docker-compose.yml <<'YML'
version: "3.8"
services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
YML

cat > prometheus.yml <<'YML'
global:
  scrape_interval: 5s
scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["prometheus:9090"]
YML

docker compose up -d
```
Open `http://localhost:3000` and login `admin/admin`. Add Prometheus data source (`http://prometheus:9090`) and create a simple panel with `up`.

## 4) Incident + Post‑Mortem Practical (30 minutes)
```bash
cd ../04-incident
cat > postmortem_template.md <<'MD'
# Incident Post‑Mortem
## Summary
## Timeline
## Root Cause
## Impact
## Action Items
MD

cat > chaos_kill.sh <<'SH'
#!/usr/bin/env bash
sleep 300 &
PID=$!
echo "Started dummy process PID=$PID"
kill -9 "$PID"
echo "Killed PID=$PID"
SH
chmod +x chaos_kill.sh
./chaos_kill.sh
```

## 5) Kubernetes Basics Practical (45–60 minutes)
```bash
cd ../05-k8s
kubectl create deployment hello --image=nginx
kubectl get pods
kubectl delete pod -l app=hello
kubectl get pods
```
If you use Minikube or kind, make sure it’s running before this step.

---

# 30‑Minute Demo Run Order (No Surprises)
Run these in this order for a smooth live demo.
1. **SLI/SLO**: `python availability_calc.py` and explain error budget.
2. **Toil/Automation**: `python db_health_check.py` and explain “do it twice, automate.”
3. **Monitoring**: `docker compose up -d`, open Grafana, add panel with `up`.
4. **Incident**: run `./chaos_kill.sh`, open `postmortem_template.md`, fill 2 bullet points.
5. **K8s**: `kubectl delete pod -l app=hello`, show it recreates.

# 2‑Hour Emergency Prep (If You’re Crunched)
Only do the starred items. Skip everything else.
- **SLI/SLO**: run `python availability_calc.py` and explain SLI vs SLO vs SLA.
- **Error budget**: memorize downtime for 99.9% and 99.99%.
- **Toil**: explain 3 examples of toil and why it’s bad.
- **Monitoring**: define metrics/logs/traces + show Grafana `up` panel.
- **Incident**: explain blameless post‑mortem with the template headings.
- **K8s**: delete pod and show self‑healing.

---

# Instructor Bootcamp: Site Reliability Engineering (SRE)
> **Target:** Teach a 44-hour corporate course at Union Bank (NIIT Fortesoft)
> **Crunch Mode:** 7 Days to Proficiency
> **Goal:** From "I know this" to "I can explain error budgets & lead a chaos engineering lab"

## The Core Mission (From the Proposal)
This course transforms IT Ops into Software Engineering. You are not teaching SysAdmin; you are teaching **reliability as code**.
- **Key Metric:** 99.99% availability for banking transactions.
- **Key Mindset:** "Failure is normal. Engineer your way out of toil."
- **Key Tools:** Prometheus, Grafana, Ansible, Terraform, Python/Bash, Kubernetes.

---

## The 7-Day "Zero to Instructor" Sprint

### Day 1: The SRE Mindset & SLI/SLO/SLA (Module 1 & 2)
**You must be able to explain:** Why SRE is different from DevOps. The "error budget" concept.
- [ ] **Read (2 hours):** Google's "Site Reliability Engineering" book (Chapter 1-4 only). *Focus on the "Four Golden Signals".*
- [ ] **Build your example:** Create a fake banking API (even a spreadsheet). Calculate: `Availability = (Good events / Total events) * 100`.
- [ ] **Practice the lecture:** Explain why Union Bank can accept 0.1% downtime (Error Budget = 8.76 hours/year) but not 1%.
- [ ] **Key Analogy:** SRE is like driving a car. SLO is the speed limit. Error budget is the gap before you get a ticket.

### Day 2: Toil & Automation (Module 3)
**You must be able to show:** The difference between "toil" (manual, repetitive) and "engineering" (scripts).
- [ ] **Install (1 hour):** WSL2 (Windows Subsystem for Linux) or Git Bash. Install `python` and `ansible`.
- [ ] **Write a script:** Python script that connects to a local MySQL/MariaDB (your previous question) and checks if the DB is alive.
- [ ] **Learn:** "Infrastructure as Code" basics. Use Terraform to spin up a free AWS EC2 (t2.micro) or Docker container.
- [ ] **Teaching point:** "If you do it twice, automate it. If you do it three times, document the script."

### Day 3: Monitoring & Observability (Module 4) - *The Hardest Day*
**You must be able to run:** A live monitoring stack.
- [ ] **Install Docker Desktop** (Windows).
- [ ] **Run Prometheus & Grafana:** Use a single `docker-compose.yml` file (find the "Prometheus Grafana Docker quickstart" on Google).
- [ ] **Create a dashboard:** In Grafana, display a fake metric ("bank_transactions_per_second").
- [ ] **Practice explaining:** "Logs tell you *what* happened. Metrics tell you *how many* happened. Traces tell you *where* it happened."

### Day 4: Incident Management & Chaos (Module 5)
**You must be able to lead:** A blameless post-mortem.
- [ ] **Watch (1 hour):** YouTube "Chaos Engineering in 15 minutes" or "Blameless Post-Mortems" (Jeli.io).
- [ ] **Run a chaos experiment:** Use `chaos-toolkit` or simply write a `kill -9` script on a local process.
- [ ] **Write a post-mortem template:** Timeline, Root Cause, Impact, Action Items. Practice with a fake "ATM outage".
- [ ] **Key phrase:** "Why did the system fail *that way*?" not "Who failed?"

### Day 5: Cloud-Native & Capstone (Module 6)
**You must be able to demo:** Kubernetes (k8s) basics.
- [ ] **Install:** Minikube or kind (Kubernetes in Docker) on Windows.
- [ ] **Deploy:** A simple "hello-world" app. Crash it. Restart it.
- [ ] **Build your Capstone:** Design a 1-page SRE framework for a bank's core system. (Diagram: Users -> Load Balancer -> App Servers -> DB -> Monitoring).

### Day 6: Practice Teaching (The "Dry Run")
**Do not learn new content. Only teach.**
- [ ] **Record yourself:** Explain "Error Budget" in 2 minutes. Listen back.
- [ ] **Whiteboard:** Draw the monitoring pipeline (App -> Prometheus -> Alertmanager -> PagerDuty).
- [ ] **Prepare for "stupid questions":** "What if the bank has no cloud?" (Answer: SRE works on bare metal too. Focus on SLIs/SLOs).

### Day 7: Rest & Tool Check
- [ ] Verify your laptop can run Docker + WSL2 + VS Code.
- [ ] Verify you can connect to MariaDB from the terminal (your previous question).
- [ ] Print the course outline. Highlight the 3 "war stories" you will tell.

---

## Windows Setup Checklist (Do this NOW)
Since you are on Windows, fix this first.

```bash
# 1. Install Chocolatey (Package Manager for Windows)
# Run PowerShell as Administrator:
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 2. Install all tools in one line (Admin PowerShell)
choco install git docker-desktop python visualstudiocode kubernetes-cli terraform -y

# 3. Enable WSL2 (Restart required)
wsl --install

# 4. Verify MariaDB client is accessible (from your last question)
mariadb --version
```

---

## Cheat Sheet: The 6 Modules in 6 Sentences

| Module | One-Sentence Takeaway for Students |
| :--- | :--- |
| **1. Intro** | SRE is what happens when you ask a software engineer to solve an operations problem. |
| **2. SLI/SLO/SLA** | Measure what matters (SLI), promise a number (SLO), write a contract (SLA), and spend your error budget wisely. |
| **3. Toil** | If a machine could do it, you shouldn't be doing it. Automate the boring stuff. |
| **4. Monitoring** | You cannot fix what you cannot see. Metrics + Logs + Traces = Observability. |
| **5. Incident** | Stop the bleeding, find the root cause, write a blameless report, then break it again on purpose (Chaos). |
| **6. Advanced** | Kubernetes doesn't make you reliable. Good SRE practices make you reliable. K8s just helps you scale. |

---

## The "Night Before" Teaching Checklist

**Do this Friday night before the Monday class:**
- [ ] Lab 1 ready: `SELECT 1;` query against a local DB.
- [ ] Lab 2 ready: `docker run -d --name grafana grafana/grafana`
- [ ] Lab 3 ready: A broken Python script that students must fix (teaches debugging).
- [ ] One war story: "In 2022, a bank went down because..." (Find a real Nigerian fintech outage story).
- [ ] Backup plan: If Wi-Fi fails, you can still draw the SRE wheel on a whiteboard.
