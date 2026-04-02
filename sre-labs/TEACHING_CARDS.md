# Teaching Cards (Fast Speak-Through)

## 1) SRE Mindset + SLI/SLO/SLA
- SRE is software engineering applied to operations.
- SLI is what we measure (e.g., success rate).
- SLO is the target we promise (e.g., 99.9%).
- SLA is the contract, usually with penalties.
- Error budget is how much failure we can afford before we stop launching new features.

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
