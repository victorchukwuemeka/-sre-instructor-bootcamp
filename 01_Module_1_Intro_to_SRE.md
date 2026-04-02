# MODULE 1 — INTRODUCTION TO SRE
### Duration: 6 Hours | NIIT Fortesoft | Union Bank of Nigeria

---

## INSTRUCTOR OVERVIEW

This is the foundation module. Everything else in the course builds on what you teach here. Your job in Module 1 is not to go deep — it is to make sure every participant understands *why SRE exists* and can explain it in their own words before they leave the room.

**The three things every student must leave with today:**
1. They can explain SRE in one sentence
2. They understand error budgets at a basic level
3. They can name at least three examples of toil from their own work

---

## LESSON PLAN

| Time | Topic | Method |
|------|-------|--------|
| 0:00 – 0:30 | Welcome, introductions, course overview | Discussion |
| 0:30 – 1:30 | What is SRE? History and origin | Lecture + Q&A |
| 1:30 – 2:30 | SRE vs DevOps vs Traditional Ops | Lecture + Group discussion |
| 2:30 – 3:00 | Break | — |
| 3:00 – 4:00 | Core principles: Risk, Error Budgets, Toil | Lecture + Worked examples |
| 4:00 – 5:00 | SRE in banking — Union Bank context | Case study + Discussion |
| 5:00 – 5:45 | Classroom activity | Group work |
| 5:45 – 6:00 | Recap, Q&A, learning objectives check | Discussion |

---

## SECTION 1 — WHAT IS SRE?

### The one sentence
Write this on the board before anyone sits down:

> **"SRE is what happens when you ask a software engineer to solve an operations problem."**

Tell them: *Everything we do this week comes back to this sentence.*

---

### Where SRE came from

In 2003, Google had a problem. Their systems were getting too big and too complex for traditional operations teams to manage. Servers were crashing. Outages were frequent. The operations team was overwhelmed.

So Google did something unusual. They hired a software engineer — **Ben Treynor Sloss** — and told him: *"Your job is to keep our systems running. Use engineering to solve it."*

Instead of hiring more people to manually fix problems, he wrote software to prevent and fix problems automatically. That became Site Reliability Engineering.

By 2016, Google published the **SRE Book** — free online — and shared the entire methodology with the world. That book is the foundation of this course.

---

### The problem SRE solves

Before SRE, every company had two teams at war with each other:

**Developers:**
- Their job: ship new features as fast as possible
- Their metric: how many deployments per week
- Their attitude: "It worked fine when I tested it"

**Operations:**
- Their job: keep systems stable and running
- Their metric: uptime percentage
- Their attitude: "Every change is a risk. Change nothing."

**The result:** Developers would push code. Operations would block it. Or worse — code would go live and break production. Everyone blamed each other. Nothing improved.

**SRE fixes this with one rule:**

> The same engineers who write the code are responsible for running it in production.

When a developer knows they are on-call for their own code — they write it differently. They add monitoring. They handle errors properly. They think about failure.

---

### SRE is not a job title

Important point to make clear on Day 1:

SRE is **not** something you do by hiring one person and calling them an "SRE Engineer."

It is a **culture and methodology** that the whole team adopts. You can start practising SRE tomorrow with zero new hires by simply changing how your team thinks about reliability.

---

## SECTION 2 — SRE vs DEVOPS vs TRADITIONAL OPS

| Aspect | Traditional Ops | DevOps | SRE |
|--------|----------------|--------|-----|
| Who fixes outages? | Ops team only | Everyone shares | Engineer on-call |
| Main goal | Keep things stable | Speed + stability | Measured reliability |
| Attitude to change | Avoid it | Automate it | Engineer it carefully |
| When things fail | "Who broke this?" | "Fix it fast" | "What did we learn?" |
| Key metric | Uptime % | Deployment frequency | Error budget remaining |

**The simple way to explain this:**
- Traditional Ops is the old way — manual, reactive, blame-driven
- DevOps is the culture change — collaboration, automation, shared ownership
- SRE is the implementation — DevOps with concrete numbers, metrics, and engineering rigour

> **DevOps tells you *what* to do. SRE tells you *how* to actually do it.**

---

## SECTION 3 — THE 3 CORE SRE PRINCIPLES

### Principle 1 — Embrace Risk

The old goal was: *"We want 100% uptime."*

This sounds good. It is actually a trap.

**Why 100% uptime is harmful:**
- Achieving 100% means you can never change anything — any change risks downtime
- You spend enormous money on redundant systems for events that almost never happen
- Users cannot even tell the difference between 99.9% and 100% uptime — the improvement is invisible to them
- Meanwhile, your competitors are shipping new features while you are frozen

**What SRE does instead:**
Pick a realistic reliability target and use the "saved" engineering time to ship features.

Google runs most of its services at **99.99%** — that is 52 minutes of downtime per year. Users barely notice. But Google ships thousands of improvements every single day.

---

### Principle 2 — Error Budgets

This is the most important concept in the entire course. Spend real time here.

**The formula:**
```
Error Budget = 100% − Uptime Target
```

**Examples for Union Bank:**

| Service | Target | Error Budget per Year |
|---------|--------|-----------------------|
| ATM Network | 99.9% | 8 hours 45 minutes |
| Mobile Banking App | 99.95% | 4 hours 22 minutes |
| Online Transfers | 99.99% | 52 minutes |
| Core Banking System | 99.999% | 5 minutes |

**How the error budget is used:**

Think of it like a monthly data bundle.

- You start the month with your full error budget
- Every time there is downtime, you spend from that budget
- If the budget runs out before the month ends — **all new feature work stops** until the next period
- If the budget is still healthy — engineers are free to take risks and ship new things

**Why this works:**
- Developers now have a *reason* to care about reliability — if they cause an outage, they lose their own ability to ship features
- Operations now has a *reason* to allow changes — as long as there is budget remaining, changes are fine
- Both sides share the same goal: keep the budget healthy

---

### Principle 3 — Toil

**Definition:** Toil is any work that is:
- Manual — a human does it by hand
- Repetitive — it happens over and over
- Automatable — a script could do it
- Tactical — it does not make the system better or smarter

**Real examples from banking operations:**

| Toil Task | How Often | Time Wasted |
|-----------|-----------|-------------|
| Restarting a crashed service by hand | Daily | 30 min/day = 180 hrs/year |
| Manually checking if backups completed | Every morning | 15 min/day = 90 hrs/year |
| Resetting user passwords individually | 20x per day | 1 hr/day = 365 hrs/year |
| Copying logs to check for errors | After every incident | 45 min each time |

**The SRE rule:**
- Do it twice → write a script to automate it
- Do it three times → you are wasting engineering talent

Google has a hard rule: no SRE team should spend more than **50% of their time on toil**. The other 50% must go to engineering work that makes the system better.

---

## SECTION 4 — SRE IN THE BANKING CONTEXT

### Why banking is a perfect SRE environment

Banks are under more pressure to maintain reliability than almost any other industry:

- **CBN regulations** require banks to report and resolve outages within defined timeframes
- **Financial transactions** cannot be retried easily — a failed transaction may mean lost money
- **Customer trust** is the core product — one bad outage on a Friday afternoon can cost the bank accounts
- **Legacy systems** — many Nigerian banks run critical services on old infrastructure, making every change high-risk

SRE gives banks a disciplined way to:
1. Quantify exactly how reliable their systems need to be
2. Make changes safely without causing outages
3. Recover faster when incidents happen
4. Prove to regulators that reliability is managed, not hoped for

---

### Union Bank specific context

When teaching this class, make these connections:

| Union Bank Service | SRE Relevance |
|-------------------|---------------|
| ATM network | Highest visibility — customers notice immediately |
| Mobile banking app | Fastest growing channel — reliability = retention |
| Online transfers | Highest financial risk — failed transfers damage trust |
| Internet banking | CBN-regulated — downtime must be reported |
| Core banking system | Everything depends on this — highest SLO required |

---

## SECTION 5 — CLASSROOM ACTIVITY (45 MINUTES)

### Activity: "Find Your Toil"

**Instructions:**

Split participants into groups of 3–4. Give each group 15 minutes to answer these questions about their actual current jobs:

1. What is the most repetitive task your team does every week?
2. How long does it take each time?
3. Could a script do it? What would the script need to do?
4. If you automated it — how many hours per year would you save?

Each group then presents their top toil item to the class. Write them all on the board.

**Debrief questions:**
- Which of these is causing the most pain?
- Which would be easiest to automate first?
- Who in your team could write that script?

**Why this works:** Participants immediately connect SRE concepts to their real daily work. By the end of Day 1, they are already thinking like SRE engineers.

---

## SECTION 6 — RECAP & LEARNING OBJECTIVES CHECK

Before closing, go through this checklist with the class out loud:

- [ ] Can you explain SRE in one sentence?
- [ ] Can you explain what an error budget is and how it is used?
- [ ] Can you name three examples of toil from your own work?
- [ ] Can you explain the difference between SRE and traditional IT operations?
- [ ] Can you explain why 100% uptime is a bad goal?

If anyone cannot answer these, spend the last 10 minutes addressing the gaps.

---

## KEY TERMS — MODULE 1

| Term | Definition |
|------|-----------|
| **SRE** | Site Reliability Engineering — applying software engineering to operations |
| **Toil** | Manual, repetitive, automatable work that adds no lasting value |
| **Error Budget** | The amount of downtime a system is allowed before feature work must stop |
| **Reliability** | The probability that a system performs its required function without failure |
| **On-call** | The engineer responsible for responding to incidents during a defined period |
| **Blameless culture** | A team environment where failures are investigated for system causes, not personal blame |

---

## FURTHER READING — MODULE 1

- [Google SRE Book, Chapter 1 — Introduction](https://sre.google/sre-book/introduction/)
- [Google SRE Book, Chapter 2 — The Production Environment](https://sre.google/sre-book/production-environment/)
- [Google SRE Book, Chapter 4 — Service Level Objectives](https://sre.google/sre-book/service-level-objectives/)
