# Teaching Cards (Fast Speak-Through)

## 1) SRE Mindset + SLI/SLO/SLA
### Teaching Note (Read This Out)
SRE is software engineering applied to operations. Our job is to make reliability predictable, not heroic. We do that by measuring what matters, setting targets, and using error budgets to balance speed and stability.

### Key Definitions (Say These)
- **SLI (Service Level Indicator):** The real metric we measure (e.g., “% of successful transactions”).  
- **SLO (Service Level Objective):** The target we set for the SLI (e.g., 99.9% success rate).  
- **SLA (Service Level Agreement):** The contract with penalties if we miss the SLO.  
- **Error Budget:** The allowed amount of failure before we slow down releases and fix reliability.

### Simple Example (Use This)
- If a bank API handles 100,000 requests and 99,900 succeed, availability is 99.9%.  
- 99.9% means about **8h 45m** downtime per year.  
- 99.99% means about **52m** downtime per year.  
This is why banking systems aim higher.

### Two-Minute Script
“SRE is how we turn reliability into engineering. We measure service health with an SLI, we promise a target with an SLO, and sometimes we put it in a contract as an SLA. Then we manage an error budget—the amount of failure we can safely accept. If we spend the budget, we pause risky changes and fix reliability. That’s how we balance speed and stability.”

## 2) Toil + Automation
- Toil is manual, repetitive, and reactive work.
- If a machine can do it, it should be scripted.
- Automation reduces human error and frees time for engineering.

## 3) Monitoring + Observability
- Metrics tell you how many and how fast.
- Logs tell you what happened.
- Traces tell you where it happened.
- Dashboards show health. Alerts tell you when to act.

## 4) Incident Management
- Blameless post-mortems build reliability.
- Focus on “why the system failed that way,” not “who failed.”
- Output is action items that prevent repeat incidents.

## 5) Kubernetes Basics
- Pods are the smallest unit of deployment.
- Kubernetes keeps desired state running.
- If a pod dies, it gets recreated automatically.
