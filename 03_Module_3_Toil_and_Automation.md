# MODULE 3 — REDUCING TOIL & AUTOMATION
### Duration: 8 Hours | NIIT Fortesoft | Union Bank of Nigeria

---

## INSTRUCTOR OVERVIEW

Module 3 is the most practical module so far. Students have learned the philosophy (Module 1) and the metrics (Module 2). Now they learn how to actually eliminate the painful manual work that consumes their teams. This module should feel energising — participants will immediately see things they can go back and fix at work.

**The three things every student must leave with today:**
1. They can identify and quantify toil in any team
2. They understand what Ansible, Terraform, and Python scripting are used for
3. They have written or read at least one automation script

---

## LESSON PLAN

| Time | Topic | Method |
|------|-------|--------|
| 0:00 – 0:30 | Recap Module 2 | Q&A |
| 0:30 – 1:30 | Toil — deep dive | Lecture + discussion |
| 1:30 – 2:30 | Automation tools overview | Lecture + demo |
| 2:30 – 3:00 | Break | — |
| 3:00 – 4:30 | Python scripting for SRE | Live demo + lab |
| 4:30 – 5:30 | Ansible basics | Demo |
| 5:30 – 6:30 | Terraform basics | Demo |
| 6:30 – 7:30 | Infrastructure as Code concepts | Lecture + discussion |
| 7:30 – 8:00 | Recap, Q&A, objectives check | Discussion |

---

## SECTION 1 — TOIL: THE DEEP DIVE

### Recap the definition
Toil = manual, repetitive, automatable, tactical work with no lasting value.

### How to measure toil

Ask your team to track their work for one week and categorise every task:

| Category | Example | Is it Toil? |
|----------|---------|-------------|
| Restarting a service by hand | Restarting the ATM switch daily | ✅ Yes |
| Investigating a new class of alert | Diagnosing a new database error pattern | ❌ No — this builds knowledge |
| Writing a runbook | Documenting how to handle an outage | ❌ No — this adds lasting value |
| Responding to the same alert for the 20th time | "Database connection timeout" again | ✅ Yes |
| Building a monitoring dashboard | First time set up | ❌ No |
| Manually checking that dashboard daily | Every morning for a year | ✅ Yes — automate the alert |

### The 50% rule

Google's SRE teams enforce a hard rule: **no more than 50% of engineering time can be toil.**

If a team is spending more than half their time on toil:
1. Measure and document the toil (make it visible to management)
2. Prioritise the highest-frequency items first
3. Allocate dedicated time each sprint to eliminate toil
4. Track progress — report hours saved per quarter

### Toil vs necessary operational work

Not all repetitive work is toil. Some work is genuinely necessary:

| Looks like Toil | Is it actually Toil? |
|-----------------|---------------------|
| On-call response | ❌ No — if it leads to fixing the root cause |
| Writing post-mortems | ❌ No — builds lasting process improvement |
| Capacity reviews | ❌ No — proactive, prevents problems |
| Manual approval of changes | ✅ Yes — if it can be automated with proper guardrails |

---

## SECTION 2 — AUTOMATION TOOLS OVERVIEW

Three tools power most SRE automation. Know what each one does:

| Tool | Category | What It Does | Banking Use Case |
|------|----------|-------------|-----------------|
| **Python** | Scripting | Quick automation, health checks, data processing | Check if ATM API is responding; parse error logs |
| **Ansible** | Configuration Management | Configure and manage servers consistently | Push the same config to 200 bank servers at once |
| **Terraform** | Infrastructure as Code | Define and create infrastructure in code | Spin up a new test environment for core banking |

**The analogy:**
- Python is a hammer — fast, flexible, good for specific tasks
- Ansible is a factory blueprint — defines how every machine should be configured
- Terraform is an architect's drawing — defines what infrastructure should exist

---

## SECTION 3 — PYTHON FOR SRE

Python is the most important scripting language for SRE work. Even basic scripts save enormous amounts of time.

### Script 1 — Health Check

This script checks if a service is running and logs the result.

```python
import requests
import datetime

def check_service(url, service_name):
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            status = "UP"
        else:
            status = f"DEGRADED (HTTP {response.status_code})"
    except requests.exceptions.Timeout:
        status = "DOWN (timeout)"
    except requests.exceptions.ConnectionError:
        status = "DOWN (connection error)"

    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{timestamp}] {service_name}: {status}")

# Check Union Bank services
check_service("https://mobile.unionbank.com/api/health", "Mobile Banking API")
check_service("https://atm.unionbank.com/status", "ATM Network API")
check_service("https://transfer.unionbank.com/health", "Transfer Service")
```

**Explain to students:** This script runs every 5 minutes via a cron job. Instead of someone manually checking each service every morning, the machine does it automatically and logs every check.

---

### Script 2 — Log Error Counter

This script scans a log file and counts how many errors occurred.

```python
import re
from collections import Counter

def count_errors(log_file_path):
    error_pattern = re.compile(r'ERROR|CRITICAL|FATAL', re.IGNORECASE)
    errors = []

    with open(log_file_path, 'r') as f:
        for line in f:
            if error_pattern.search(line):
                errors.append(line.strip())

    print(f"\nTotal errors found: {len(errors)}")
    print("\nFirst 5 errors:")
    for error in errors[:5]:
        print(f"  → {error}")

count_errors("/var/log/banking-app/app.log")
```

**Explain to students:** Instead of someone opening a log file and scrolling through thousands of lines looking for errors every morning — this script does it in 2 seconds.

---

### Script 3 — Error Budget Calculator

```python
def calculate_error_budget(slo_percent, period_days):
    uptime_target = slo_percent / 100
    error_budget_percent = 1 - uptime_target
    total_minutes = period_days * 24 * 60
    budget_minutes = error_budget_percent * total_minutes

    hours = int(budget_minutes // 60)
    minutes = int(budget_minutes % 60)

    print(f"\nSLO: {slo_percent}%")
    print(f"Period: {period_days} days")
    print(f"Error Budget: {hours}h {minutes}m")
    print(f"             ({budget_minutes:.1f} minutes total)")

# Examples
calculate_error_budget(99.9, 30)
calculate_error_budget(99.95, 30)
calculate_error_budget(99.99, 30)
```

**Explain to students:** This directly connects to Module 2. They can now calculate any error budget instantly.

---

## SECTION 4 — ANSIBLE BASICS

### What Ansible does

Ansible lets you define the desired state of a server and then apply that state automatically across as many servers as you need.

**Without Ansible:**
- Engineer SSHs into Server 1, installs package, edits config file
- Engineer SSHs into Server 2, does the same thing
- Three weeks later, someone does it slightly differently on Server 3
- Now your 50 servers are all configured slightly differently
- Nobody knows which one is "correct"

**With Ansible:**
- Write one playbook defining exactly how every server should be configured
- Run it — Ansible connects to all 50 servers and makes them identical
- Six months later, run it again — any drift is corrected automatically

### Basic Ansible playbook example

```yaml
# install_monitoring.yml
# This playbook installs and starts the monitoring agent on all servers

- name: Set up monitoring on all banking servers
  hosts: all
  become: yes  # Run as root

  tasks:
    - name: Install monitoring agent
      apt:
        name: prometheus-node-exporter
        state: present
        update_cache: yes

    - name: Start monitoring agent
      service:
        name: prometheus-node-exporter
        state: started
        enabled: yes

    - name: Confirm agent is running
      command: systemctl status prometheus-node-exporter
      register: result

    - name: Show status
      debug:
        msg: "{{ result.stdout }}"
```

**Run it with:**
```bash
ansible-playbook -i inventory.ini install_monitoring.yml
```

This runs the same task on every server in your inventory simultaneously.

---

## SECTION 5 — TERRAFORM BASICS

### What Terraform does

Terraform lets you define your infrastructure (servers, databases, networks, load balancers) as code files — and then create, modify, or destroy that infrastructure automatically.

**Without Terraform:**
- Click through AWS console to create a server
- Forget what settings you used
- Need to create a test environment — click through everything again
- Test and production environments drift apart

**With Terraform:**
- Write a `.tf` file describing exactly what infrastructure you need
- Run `terraform apply` — infrastructure is created exactly as specified
- Save the file in Git — you have a full history of every infrastructure change
- Need a test environment — run the same file with different variables

### Basic Terraform example

```hcl
# main.tf
# Creates a server to run the banking health check service

provider "aws" {
  region = "eu-west-1"  # Closest AWS region to Nigeria
}

resource "aws_instance" "health_check_server" {
  ami           = "ami-0123456789abcdef0"  # Ubuntu 22.04
  instance_type = "t3.micro"

  tags = {
    Name        = "union-bank-health-checker"
    Environment = "production"
    Team        = "SRE"
  }
}

output "server_ip" {
  value = aws_instance.health_check_server.public_ip
}
```

**Commands:**
```bash
terraform init     # Download required plugins
terraform plan     # Preview what will be created
terraform apply    # Create the infrastructure
terraform destroy  # Remove everything when done
```

---

## SECTION 6 — INFRASTRUCTURE AS CODE (IaC)

### The core principle

Infrastructure as Code means: **treat your servers and infrastructure exactly like you treat your application code.**

| Application Code | Infrastructure as Code |
|-----------------|----------------------|
| Stored in Git | ✅ Stored in Git |
| Reviewed before merging | ✅ Reviewed before applying |
| Has a history of changes | ✅ Every infrastructure change is tracked |
| Can be rolled back | ✅ Can restore previous infrastructure state |
| Tested before production | ✅ Tested in staging first |

### Why this matters for banks

- **Audit trail:** Every infrastructure change is committed to Git with a message, author, and timestamp — perfect for CBN audits
- **Disaster recovery:** If your data centre fails, you can recreate your entire infrastructure from code in hours, not weeks
- **Consistency:** Dev, test, and production environments are identical — "it works in test but not prod" becomes rare
- **Speed:** New environments spin up in minutes, not days

---

## SECTION 7 — CLASSROOM ACTIVITY (1 HOUR)

### Activity: "Automate One Thing"

**Instructions:**

Each participant thinks of one toil task from their real work that could be automated.

They then plan the automation:

1. **Describe the task** — what happens, how often, how long it takes
2. **Choose the tool** — Python script, Ansible playbook, or Terraform config?
3. **Sketch the logic** — not code, just plain English steps:
   - "First, connect to the server"
   - "Check if the service is running"
   - "If not running, restart it and log the event"
   - "Send a message to the team Slack channel"
4. **Estimate the time saved** — hours per month, hours per year
5. **Identify what they need to learn** to build it

Groups share their plans. Class votes on which automation would save the most time across the whole team.

---

## SECTION 8 — RECAP & LEARNING OBJECTIVES CHECK

- [ ] Can you define toil and give three examples from banking?
- [ ] Can you explain what Ansible, Terraform, and Python are each used for?
- [ ] Can you read and understand the Python health check script?
- [ ] Can you explain what Infrastructure as Code means and why it matters?
- [ ] Can you identify one toil task in your work and describe how to automate it?

---

## KEY TERMS — MODULE 3

| Term | Definition |
|------|-----------|
| **Toil** | Manual, repetitive, automatable work with no lasting value |
| **Automation** | Using scripts or tools to perform tasks without human intervention |
| **Ansible** | A configuration management tool that keeps servers consistent |
| **Terraform** | An Infrastructure as Code tool that creates and manages infrastructure |
| **IaC** | Infrastructure as Code — defining infrastructure in version-controlled files |
| **Playbook** | An Ansible file that defines a set of tasks to run on servers |
| **Cron job** | A scheduled task that runs automatically at defined intervals |

---

## FURTHER READING — MODULE 3

- [Google SRE Book, Chapter 5 — Eliminating Toil](https://sre.google/sre-book/eliminating-toil/)
- [Ansible Getting Started Guide](https://docs.ansible.com/ansible/latest/getting_started/)
- [Terraform Getting Started](https://developer.hashicorp.com/terraform/tutorials)
