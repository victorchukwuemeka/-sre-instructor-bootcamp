# MODULE 2 — SERVICE LEVEL MANAGEMENT
### Duration: 8 Hours | NIIT Fortesoft | Union Bank of Nigeria

---

## INSTRUCTOR OVERVIEW

Module 2 is where the math comes in. Students learned *what* SRE is in Module 1 — now they learn *how to measure it*. SLIs, SLOs, and SLAs are the backbone of everything an SRE team does. If your students leave this module able to define, calculate, and use these three things — you have done your job.

**The three things every student must leave with today:**
1. They can define SLI, SLO, and SLA without looking at their notes
2. They can calculate an error budget for any service
3. They can write an SLO for a real banking service

---

## LESSON PLAN

| Time | Topic | Method |
|------|-------|--------|
| 0:00 – 0:30 | Recap of Module 1 | Q&A |
| 0:30 – 1:30 | SLI — what you measure | Lecture + examples |
| 1:30 – 2:30 | SLO — what you promise | Lecture + worked examples |
| 2:30 – 3:00 | Break | — |
| 3:00 – 3:45 | SLA — the contract | Lecture |
| 3:45 – 5:00 | Error budgets in depth | Lecture + calculation exercises |
| 5:00 – 5:30 | Error budget policy | Lecture + discussion |
| 5:30 – 7:30 | Banking case study + activity | Group work + presentation |
| 7:30 – 8:00 | Recap, Q&A, objectives check | Discussion |

---

## SECTION 1 — THE HIERARCHY

Before teaching each term separately, show the full picture first:

```
SLA  ← the contract with the customer (external, has penalties)
 └── SLO  ← the target you set internally (stricter than SLA)
       └── SLI  ← what you actually measure (the raw number)
```

**The key insight:** You always set your SLO tighter than your SLA. That way, your internal alarm goes off *before* you breach the customer contract.

**Analogy for the class:**
- SLI = your actual exam score (e.g. 73%)
- SLO = the score you told your parents you would get (e.g. 75%)
- SLA = the score the scholarship requires (e.g. 70%)

You missed your personal target but still kept your scholarship. That gap between SLO and SLA is your safety margin.

---

## SECTION 2 — SLI (SERVICE LEVEL INDICATOR)

### What it is
An SLI is a **quantitative measurement** of a specific aspect of your service's behaviour.

It is always expressed as a ratio or percentage:

```
SLI = Good Events ÷ Total Events
```

### Choosing the right SLI

Not everything worth measuring makes a good SLI. A good SLI is:
- Something the **user directly experiences** — not an internal system metric
- **Measurable** — you can get the number from your logs or monitoring tools
- **Meaningful** — when it drops, something the user cares about has gone wrong

### SLI categories for banking

| Category | What It Measures | Example |
|----------|-----------------|---------|
| **Availability** | Is the service up? | ATM successfully processed withdrawal / total attempts |
| **Latency** | Is it fast enough? | Transfers completed in under 3 seconds / total transfers |
| **Error Rate** | Is it producing errors? | Successful API calls / total API calls |
| **Throughput** | Can it handle the load? | Transactions processed per minute |
| **Correctness** | Is the output right? | Transactions posted with correct amounts / total transactions |

### Worked examples

**ATM Network:**
```
SLI = Successful withdrawals ÷ Total attempted withdrawals

Example:
- Total attempts: 10,000
- Failed: 50
- Successful: 9,950

SLI = 9,950 ÷ 10,000 = 0.995 = 99.5%
```

**Mobile Banking App — Latency:**
```
SLI = Login requests completed under 2 seconds ÷ Total login requests

Example:
- Total logins: 5,000
- Completed under 2 seconds: 4,850

SLI = 4,850 ÷ 5,000 = 0.97 = 97%
```

**Online Transfer — Correctness:**
```
SLI = Transfers posted with correct amount and recipient ÷ Total transfers initiated

Example:
- Total transfers: 20,000
- Correct: 19,998

SLI = 19,998 ÷ 20,000 = 0.9999 = 99.99%
```

---

## SECTION 3 — SLO (SERVICE LEVEL OBJECTIVE)

### What it is
An SLO is the **target value** you set for your SLI. It is an internal promise — not a customer contract.

```
SLO = "Our SLI must stay above X% over the next 30 days"
```

### How to choose an SLO

Common mistake: setting the SLO at whatever your system currently achieves.

That is wrong. You should ask:
1. What reliability does the user actually need to be happy?
2. What reliability is technically achievable?
3. What would the cost be to improve beyond that?

Often, users are perfectly happy with 99.9%. Engineering 99.999% costs 10x more and users cannot feel the difference.

### SLO examples for Union Bank

| Service | SLI | SLO |
|---------|-----|-----|
| ATM withdrawals | Successful withdrawal rate | 99.9% over 30 days |
| Mobile app login | Logins under 2 seconds | 95% over 30 days |
| Online transfer | Correct transfer rate | 99.99% over 30 days |
| Internet banking | Availability | 99.95% over 30 days |

### Checking an SLO

**Question:** Our ATM SLO is 99.9%. This month our SLI was 99.5%. Did we meet our SLO?

```
SLI = 99.5%
SLO = 99.9%

99.5% < 99.9%

Result: ❌ SLO MISSED. Error budget spent. Stop new feature work.
```

**Question:** Our mobile app latency SLO is 95% of logins under 2 seconds. This month we measured 96.2%. Did we meet it?

```
SLI = 96.2%
SLO = 95%

96.2% > 95%

Result: ✅ SLO MET. Error budget healthy. Continue shipping features.
```

---

## SECTION 4 — SLA (SERVICE LEVEL AGREEMENT)

### What it is
An SLA is a **formal contract** between you and your customer defining the minimum acceptable reliability, with a financial or legal consequence for breaching it.

```
SLA = "If our service drops below X%, you receive Y compensation"
```

### SLA vs SLO — the critical difference

| | SLO | SLA |
|--|-----|-----|
| Who sees it? | Internal team only | Customer and legal team |
| What happens if missed? | Engineering stops shipping features | Financial penalty, legal consequence |
| How tight should it be? | Tighter than the SLA | Looser than the SLO |
| Purpose | Drive engineering behaviour | Protect customer and define accountability |

### Banking SLA examples

- "If ATM availability drops below 99.5% in any calendar month, Union Bank will waive all ATM fees for that month."
- "If online transfer processing exceeds 10 seconds, the transaction fee is refunded."
- "If internet banking is unavailable for more than 4 hours in any single day, affected business customers receive service credits."

### The safety margin rule

Always set your SLO at least 0.1–0.5% tighter than your SLA:

```
SLA: 99.5% availability
SLO: 99.9% availability  ← internal alarm triggers here

If your SLI drops to 99.7% → SLO is breached → engineering responds
But the SLA (99.5%) is still safe → no customer penalty yet
```

---

## SECTION 5 — ERROR BUDGETS IN DEPTH

### Review the formula
```
Error Budget = 100% − SLO Target
```

### Calculating time-based error budgets

For availability SLOs:

```
Error Budget (time) = (100% − SLO%) × Time Period

Example: SLO = 99.9%, Time period = 30 days

Error Budget = 0.1% × (30 × 24 × 60 minutes)
             = 0.001 × 43,200 minutes
             = 43.2 minutes per month
```

**Full reference table:**

| SLO | Monthly Budget | Weekly Budget | Annual Budget |
|-----|---------------|---------------|---------------|
| 99% | 7h 18m | 1h 41m | 3d 15h |
| 99.5% | 3h 39m | 50m | 1d 19h |
| 99.9% | 43m | 10m | 8h 45m |
| 99.95% | 21m | 5m | 4h 22m |
| 99.99% | 4m | 1m | 52m |
| 99.999% | 26s | 6s | 5m |

### Tracking budget consumption

Each incident consumes from the budget:

```
Budget consumed = Duration of downtime

Example:
Monthly error budget: 43 minutes (SLO 99.9%)

Week 1: Database restart — 8 minutes down → 35 minutes remaining
Week 2: Network issue — 12 minutes down → 23 minutes remaining
Week 3: Bad deployment — 30 minutes down → BUDGET EXHAUSTED ← stop all deployments
Week 4: No more budget → no new releases until next month
```

---

## SECTION 6 — ERROR BUDGET POLICY

An error budget policy is a written agreement that defines what the team will do when the budget is spent or running low.

### Sample policy structure

```
Error Budget Policy — Union Bank Mobile Banking App

SLO: 99.95% availability over 30 days
Monthly error budget: 21 minutes

GREEN (>50% budget remaining):
- Normal deployment pace
- New features can be released
- Risk-taking is encouraged

YELLOW (20–50% budget remaining):
- Review all planned deployments
- High-risk changes require additional approval
- Focus on reliability improvements

RED (<20% budget remaining):
- No new feature deployments
- All engineering effort shifts to reliability
- Daily incident review meetings

EXHAUSTED (0% remaining):
- Feature freeze until next period
- Post-mortem required for all incidents this period
- Engineering lead must approve any exception
```

---

## SECTION 7 — CLASSROOM ACTIVITY (2 HOURS)

### Activity: "Build Your SLOs"

**Part 1 — Individual (30 minutes):**

Each participant picks one service from their current work and answers:
1. What does a user experience when this service is working well?
2. How would you measure that? Write the SLI formula.
3. What is the minimum reliability a user needs to be satisfied?
4. Set an SLO. Set an SLA (10% looser than the SLO).
5. Calculate the monthly error budget in minutes.

**Part 2 — Group (45 minutes):**

Groups of 3 are given this scenario:

> *Union Bank's mobile banking app had the following incidents this month:*
> - *Day 3: App crashed for 15 minutes*
> - *Day 11: Login failures for 22 minutes*
> - *Day 19: Transfer service slow (not down) for 40 minutes*
> - *Day 27: Full outage for 18 minutes*
>
> *The SLO is 99.95% monthly availability (budget = 21 minutes).*

Answer these questions:
1. How much error budget was consumed by each incident?
2. At what point was the budget exhausted?
3. What should the team have done differently after the Day 11 incident?
4. Did the bank breach its SLA? (SLA = 99.9%)
5. Write three bullet points for the error budget policy.

**Part 3 — Presentations (45 minutes):**
Each group presents their findings. Class discusses and challenges assumptions.

---

## SECTION 8 — RECAP & LEARNING OBJECTIVES CHECK

- [ ] Can you define SLI, SLO, and SLA without notes?
- [ ] Can you write an SLI formula for any banking service?
- [ ] Can you calculate a monthly error budget in minutes?
- [ ] Can you check whether an SLO was met or missed?
- [ ] Can you explain why the SLO should always be tighter than the SLA?
- [ ] Can you describe what an error budget policy is and why it matters?

---

## KEY TERMS — MODULE 2

| Term | Definition |
|------|-----------|
| **SLI** | Service Level Indicator — the actual measured value (e.g. 99.5% availability) |
| **SLO** | Service Level Objective — the internal target (e.g. must stay above 99.9%) |
| **SLA** | Service Level Agreement — the customer contract with penalties for breach |
| **Error Budget** | The allowed downtime calculated as 100% minus the SLO target |
| **Error Budget Policy** | The written rules for what the team does as the budget is consumed |
| **Availability** | The percentage of time a service is operational and accessible |
| **Latency SLO** | A target based on response time rather than availability |

---

## FURTHER READING — MODULE 2

- [Google SRE Book, Chapter 4 — Service Level Objectives](https://sre.google/sre-book/service-level-objectives/)
- [Google SRE Workbook, Chapter 2 — Implementing SLOs](https://sre.google/workbook/implementing-slos/)
