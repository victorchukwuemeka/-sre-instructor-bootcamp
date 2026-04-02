# SRE COURSE — MODULE 2 INSTRUCTOR NOTE
### Toil, Automation, and Infrastructure as Code

---

## 1. One Sentence You Must Remember
**Toil is work that doesn’t get better no matter how many times you do it.**

---

## 2. What Toil Is (Plain English)
Toil is manual, repetitive, and reactive work that adds no lasting value.  
If a machine can do it, a human shouldn’t.

Examples:
- Restarting the same service every morning
- Manually checking whether the DB is alive
- Copy‑pasting logs to find errors
- Resetting the same user passwords daily

---

## 3. Why Toil Is Dangerous
- It wastes time and burns out engineers.
- It causes human error and outages.
- It steals time from real improvements.

---

## 4. The SRE Rule for Toil
- Do it twice → automate it.
- Do it three times → you are wasting human potential.

---

## 5. Demo Script (Use This Live)
Say this out loud:
“Here is a manual task: checking if the database is reachable.  
Now I’ll write a tiny script to do it in 5 seconds.  
This is the difference between firefighting and engineering.”

---

## 6. Practical Lab (What You Run)
Folder: `sre-labs/02-toil-automation/`
1. Run the script: `python db_health_check.py`
2. Explain that automation is reliable, repeatable, and documented.

---

## 7. Infrastructure as Code (Short Teaching)
IaC means you describe your infrastructure in code so it’s:
- Repeatable
- Reviewable
- Version controlled

Short line:
**“If it matters, put it in code.”**

---

## 8. Teaching Script — First 10 Minutes
“Toil is the enemy. It’s manual work that never gets better.  
SRE reduces toil through automation and code.  
We don’t want heroes; we want reliable systems.  
Infrastructure as Code lets us rebuild the same environment every time.”

---

## 9. Student Learning Objectives
- Define toil in their own words
- Identify tasks worth automating
- Explain why automation reduces incidents
- Understand the idea of Infrastructure as Code

---

## 10. Cheat Sheet for Teaching Day
- Toil = manual, repetitive, reactive, no long‑term value
- Automation saves time and prevents human error
- IaC = infrastructure described and managed with code

