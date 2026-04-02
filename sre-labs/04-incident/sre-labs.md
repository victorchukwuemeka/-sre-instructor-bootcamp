# SRE COURSE — MODULE 4 INSTRUCTOR NOTE
### Incident Management and Blameless Post‑Mortems

---

## 1. One Sentence You Must Remember
**Incidents are expected. Learning is mandatory.**

---

## 2. What an Incident Is
An incident is any event that degrades service quality or violates an SLO.

Examples:
- ATM transactions fail for 15 minutes
- Mobile app latency spikes for 30 minutes
- Payment gateway returns 5xx errors

---

## 3. Incident Phases (Teach This Flow)
1. **Detect** the issue
2. **Respond** and stop the bleeding
3. **Recover** the service
4. **Learn** and improve

Short line:
**“Restore first, analyze second.”**

---

## 4. Blameless Post‑Mortems (Core Idea)
We ask “Why did the system fail that way?” not “Who failed?”  
The goal is to prevent repeat incidents.

---

## 5. Post‑Mortem Template (Use This)
Sections to fill:
- Summary
- Timeline
- Root Cause
- Impact
- Action Items

---

## 6. Demo Script (Use This Live)
Say this out loud:
“I will kill a process and show how we document the incident.  
The template makes us focus on learning and prevention.”

---

## 7. Practical Lab (What You Run)
Folder: `sre-labs/04-incident/`
1. Run: `./chaos_kill.sh`
2. Open: `postmortem_template.md`
3. Fill two lines in Summary and Action Items

---

## 8. Teaching Script — First 10 Minutes
“Incidents will happen. The difference is how we respond.  
We detect fast, restore service, then learn.  
A blameless post‑mortem helps us fix the system, not blame people.”

---

## 9. Student Learning Objectives
- Define an incident
- Explain incident phases
- Write a simple post‑mortem
- Explain blameless culture

---

## 10. Cheat Sheet for Teaching Day
- Restore service first
- Blameless culture improves systems
- Post‑mortem output = action items

