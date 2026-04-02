# SRE COURSE — COMPLETE INSTRUCTOR NOTE
### NIIT Education & Training Center

---

## TABLE OF CONTENTS
- [SRE COURSE — COMPLETE INSTRUCTOR NOTE](#sre-course--complete-instructor-note)
    - [NIIT Education \& Training Center](#niit-education--training-center)
  - [TABLE OF CONTENTS](#table-of-contents)
  - [1. The One Sentence You Must Remember](#1-the-one-sentence-you-must-remember)
  - [2. What Is SRE](#2-what-is-sre)
  - [3. The 3 Core SRE Concepts](#3-the-3-core-sre-concepts)
    - [Concept 1: Embrace Risk](#concept-1-embrace-risk)
    - [Concept 2: Error Budgets](#concept-2-error-budgets)
    - [Concept 3: Toil — The Enemy](#concept-3-toil--the-enemy)
  - [4. SRE vs DevOps vs Traditional Ops](#4-sre-vs-devops-vs-traditional-ops)
  - [5. Real Banking Example](#5-real-banking-example)
    - [SLI — Service Level Indicator (What You Measure)](#sli--service-level-indicator-what-you-measure)
    - [SLO — Service Level Objective (What You Promise)](#slo--service-level-objective-what-you-promise)
  - [6. SRE in 10 Bullet Points](#6-sre-in-10-bullet-points)
  - [7. Your Teaching Script — First 10 Minutes](#7-your-teaching-script--first-10-minutes)
  - [8. 7-Day Learning Sprint](#8-7-day-learning-sprint)
  - [9. Module 1 Student Learning Objectives](#9-module-1-student-learning-objectives)
  - [10. Resource Links](#10-resource-links)
  - [11. Cheat Sheet for Teaching Day](#11-cheat-sheet-for-teaching-day)
    - [Core Concepts at a Glance](#core-concepts-at-a-glance)
    - [Emergency Answers for Student Questions](#emergency-answers-for-student-questions)

---

## 1. The One Sentence You Must Remember

> **"SRE is what happens when you ask a software engineer to solve an operations problem."**

Write this on the whiteboard. Say it at the start. Say it at the end.

---

## 2. What Is SRE

**SRE = Site Reliability Engineering**

Before SRE, companies had two separate teams constantly at war:

| Team | Focus | Attitude |
|------|-------|----------|
| **Developers** | Write features, ship code, move fast | "It works on my machine" |
| **Operations** | Keep systems running, prioritise stability | "The server is on fire… again" |

**The problem:** Devs wanted to ship code every hour. Ops wanted to change nothing ever.

**SRE solves this by** making developers responsible for how their code runs in production.

> *"You build it, you run it."* — Google SRE Team

---

## 3. The 3 Core SRE Concepts

### Concept 1: Embrace Risk

| Old Thinking | SRE Thinking |
|---|---|
| "We want 100% uptime!" | "100% uptime is impossible and counterproductive." |

Chasing 100% means you never ship new features, you spend millions on redundant systems, and customers get bored and leave. Instead, pick a realistic target. Google uses **99.99%** — about 52 minutes of downtime per year.

---

### Concept 2: Error Budgets

**The formula:**

```
Error Budget = 100% - Your Uptime Target
```

**Banking examples:**

| Target | Error Budget | Meaning |
|--------|-------------|---------|
| 99.9% | 0.1% | 8.76 hours of downtime per year allowed |
| 99.99% | 0.01% | 52 minutes per year allowed |
| 99.999% | 0.001% | 5 minutes per year allowed |

**The rule:**
- Error budget remaining → **Ship new features**
- Error budget spent → **Stop shipping. Fix reliability first.**

This ends the Dev vs Ops war.

---

### Concept 3: Toil — The Enemy

**Toil** = Manual, repetitive work that does NOT make your system better.

Examples:
- Restarting a crashed server by hand
- Resetting a user's password manually
- Copying log files to check for errors
- Answering "is the system down?" for the 50th time

**SRE Rule:**
- Do it twice → Automate it
- Do it three times → You are wasting human potential

---

## 4. SRE vs DevOps vs Traditional Ops

| Aspect | Traditional Ops | DevOps | SRE |
|--------|----------------|--------|-----|
| Who fixes outages? | Ops team | Shared | Engineer on-call |
| Goal | Stability | Speed + Stability | Measured reliability |
| Changes | Avoid them | Automate them | Engineer them |
| Failure attitude | "Who broke it?" | "Fix it fast" | "What did we learn?" |
| Key metric | Uptime % | Deployment frequency | Error budget remaining |

> **The real answer:** SRE is DevOps with math. DevOps is the culture. SRE is how you actually do it.

---

## 5. Real Banking Example

### SLI — Service Level Indicator (What You Measure)

```
SLI = Successful ATM withdrawals ÷ Total attempted ATM withdrawals
```

**Example numbers:**
- Attempted: 10,000 withdrawals
- Failed: 50
- Successful: 9,950

```
9,950 ÷ 10,000 = 0.995 = 99.5% availability
```

### SLO — Service Level Objective (What You Promise)

> "We promise 99.9% availability for ATM withdrawals."

**Did we meet it?**
99.5% < 99.9% → ❌ **No. We failed. Error budget spent. Stop new features. Fix ATMs.**

---

## 6. SRE in 10 Bullet Points

1. SRE applies software engineering to operations
2. 100% uptime is impossible — embrace risk
3. Error budget = 100% minus your uptime target
4. Error budget spent? Stop shipping features
5. Toil = manual work that adds no lasting value
6. Automate everything you do twice
7. SLI = what you measure (e.g. success rate)
8. SLO = the number you promise (e.g. 99.9%)
9. SLA = the contract with a penalty (e.g. refund)
10. "You build it, you run it" is the SRE mantra

---

## 7. Your Teaching Script — First 10 Minutes

*Read this aloud to practice:*

---

"Good morning. Open your notebooks or laptops. We are starting with Site Reliability Engineering.

Let me give you one sentence. Write it down:

**'SRE is what happens when you ask a software engineer to solve an operations problem.'**

Before SRE, banks had developers who wrote code and operations people who kept servers running. And they fought constantly. Developers wanted to ship new features every day. Operations wanted to change nothing ever.

SRE fixes this by making the developer responsible for how their code runs in production. You write the code. You wake up at 3am when it breaks. That changes how you write code.

For Union Bank, this means your ATM network, your mobile app, your online banking. If any of these go down for one hour, what happens? Lost transactions. Angry customers. CBN fines.

SRE is how you prevent that. Not by chasing 100% uptime — that is impossible. But by measuring what matters, automating the boring stuff, and agreeing on exactly how much downtime you can tolerate.

That number is called your **error budget**. And it changes everything. Let me show you how..."

---

## 8. 7-Day Learning Sprint

| Day | Focus | Actions |
|-----|-------|---------|
| **Day 1** | SRE Mindset & SLI/SLO/SLA | Read Google SRE Book Chapters 1–4. Build a banking error budget calculation in a spreadsheet. Practice explaining error budget out loud. |
| **Day 2** | Toil & Automation | Install Python. Write a script that checks if a database is alive. Practice identifying toil in a real workflow. |
| **Day 3** | Monitoring & Observability | Install Docker. Run Prometheus and Grafana using docker-compose. Create a simple dashboard. |
| **Day 4** | Incident Management & Chaos | Watch "Chaos Engineering" on YouTube. Write a blameless post-mortem template. Run a simple chaos experiment. |
| **Day 5** | Cloud-Native & Capstone | Deploy a hello-world app on Kubernetes (Minikube). Design a 1-page SRE framework for a bank. |
| **Day 6** | Practice Teaching | Record yourself explaining "Error Budget" in 2 minutes. Draw the monitoring pipeline on a whiteboard. Prepare answers for common student questions. |
| **Day 7** | Rest & Environment Check | Verify Docker, Python, and VS Code work correctly. Print the course outline. |

---

## 9. Module 1 Student Learning Objectives

By the end of Module 1, students should be able to:

- [ ] Explain SRE in one sentence to their manager
- [ ] Calculate an error budget for any banking service
- [ ] Identify toil in their daily work
- [ ] Explain why 100% uptime is a trap
- [ ] Describe the difference between SRE and traditional IT operations

---

## 10. Resource Links

**Free reading (start tonight):**

- [Google SRE Book — Official, Free](https://sre.google/sre-book/introduction/)
- [Google SRE Workbook — Free](https://sre.google/workbook/)

**YouTube search terms:**
- "What is SRE Google" *(4-minute intro)*
- "Error budget SRE explained"
- "Chaos Engineering in 15 minutes"

---

## 11. Cheat Sheet for Teaching Day

### Core Concepts at a Glance

| Concept | One Sentence |
|---------|-------------|
| **SRE** | Software engineering applied to operations problems |
| **Error Budget** | How much downtime you are allowed to have |
| **Toil** | Work that a script should do, not a human |
| **SLI** | The thing you measure (e.g. uptime %) |
| **SLO** | The number you promise (e.g. 99.9%) |
| **SLA** | The contract with a penalty (e.g. refund) |
| **Blameless** | You broke it, we fix it together — no blame, just learning |

---

### Emergency Answers for Student Questions

**Q: "What if the bank has no cloud?"**
> SRE works on bare metal too. Focus on SLIs and SLOs first. Automation comes second.

**Q: "How do we convince management to pay for this?"**
> Show them the cost of 1 hour of downtime versus the cost of training. The math works every time.

**Q: "Do we need Kubernetes?"**
> No. Kubernetes helps you scale. But good SRE practices work without it.

**Q: "What if a student asks something I cannot answer?"**
> Say: *"Great question — that is an advanced topic. Write it down and I will send you a link after class."*

---

*When you finish Module 1, reply and you will receive Module 1 Topic 2: "History of SRE — Why Google Invented It."*