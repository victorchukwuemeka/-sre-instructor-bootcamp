# MODULE 5 — INCIDENT MANAGEMENT & RESPONSE
### Duration: 8 Hours | NIIT Fortesoft | Union Bank of Nigeria

---

## INSTRUCTOR OVERVIEW

Module 5 is about what happens when things go wrong — because they always do. The difference between a great SRE team and a struggling one is not whether they have incidents. It is how fast they recover and how well they learn from each one. This module also covers chaos engineering — deliberately breaking things to find weaknesses before users do.

**The three things every student must leave with today:**
1. They can walk through the full incident lifecycle from detection to review
2. They can write a blameless post-mortem
3. They understand what chaos engineering is and why it matters

---

## LESSON PLAN

| Time | Topic | Method |
|------|-------|--------|
| 0:00 – 0:30 | Recap Module 4 | Q&A |
| 0:30 – 1:30 | The incident lifecycle | Lecture |
| 1:30 – 2:30 | Roles during an incident | Lecture + role play |
| 2:30 – 3:00 | Break | — |
| 3:00 – 4:00 | Blameless post-mortems | Lecture + example |
| 4:00 – 5:00 | Post-mortem writing activity | Group work |
| 5:00 – 6:00 | Chaos engineering | Lecture + demo |
| 6:00 – 7:00 | CBN regulatory compliance | Lecture + discussion |
| 7:00 – 7:30 | Full incident simulation | Role play |
| 7:30 – 8:00 | Recap, Q&A, objectives check | Discussion |

---

## SECTION 1 — THE INCIDENT LIFECYCLE

An incident is any event that disrupts or degrades a service that users depend on.

In banking: a failed transfer, an ATM that cannot dispense cash, a mobile app that will not load — all incidents.

### The 5 stages

```
1. DETECTION → 2. TRIAGE → 3. RESPONSE → 4. RESOLUTION → 5. REVIEW
```

---

### Stage 1 — Detection

How do you know an incident is happening?

| Source | Example | Speed |
|--------|---------|-------|
| **Automated alert** | Prometheus fires ATMHighErrorRate | Fastest — seconds |
| **Monitoring dashboard** | Engineer spots error rate spike | Minutes |
| **Customer complaint** | User calls support | Slowest — too late |
| **Internal staff report** | Branch staff cannot process transaction | Variable |

**Goal:** Detect incidents through automated alerts before customers notice. If your customers are telling you about incidents before your monitoring is — your observability is broken.

---

### Stage 2 — Triage

Triage means: **assess severity and decide what to do first.**

The moment an incident is detected, answer these three questions:
1. How many users are affected?
2. Is this getting worse or stable?
3. What is the business impact right now?

**Severity levels:**

| Severity | Definition | Example | Response Time |
|----------|-----------|---------|---------------|
| **SEV 1** | Complete service outage — all users affected | ATM network completely down | Respond immediately |
| **SEV 2** | Major degradation — most users affected | 30% of mobile transfers failing | Respond within 15 min |
| **SEV 3** | Partial degradation — some users affected | Slow login for users in one region | Respond within 1 hour |
| **SEV 4** | Minor issue — few users affected | Error on a rarely-used feature | Next business day |

---

### Stage 3 — Response

This is where the team takes action to limit the damage.

**Key principle: mitigation before root cause.**

Your first goal during an incident is not to understand why it happened — it is to stop users from being affected. Fix first, investigate after.

**Common mitigation actions:**

| Action | When to Use |
|--------|------------|
| **Rollback** | Recent deployment caused the issue — roll back to previous version |
| **Restart service** | Service is crashed or hung — restart it |
| **Failover** | Primary system is down — switch to backup |
| **Disable feature** | One feature is broken — turn it off while the rest works |
| **Scale up** | System is overloaded — add more capacity |
| **Block traffic** | Attack or bad input is causing damage — block the source |

**Communication during response:**

Every 15–30 minutes, post a status update:

```
[14:32] INCIDENT OPEN — SEV 2 — Mobile banking transfers failing
[14:35] On-call engineer engaged. Investigating logs.
[14:48] Root cause identified: database connection pool exhausted.
[14:52] Mitigation applied: increased connection pool limit. Error rate dropping.
[15:01] Error rate back to normal. Monitoring for 30 minutes before closing.
[15:34] INCIDENT CLOSED. All services normal. Post-mortem scheduled.
```

---

### Stage 4 — Resolution

An incident is resolved when:
- The service is back to normal behaviour
- The SLO is being met again
- No new errors are being generated

**Do not close an incident too early.** Monitor for at least 30 minutes after applying a fix before declaring resolution.

---

### Stage 5 — Review (Post-Mortem)

This is the most important stage — and the one most teams skip.

The post-mortem is covered in detail in Section 3.

---

## SECTION 2 — ROLES DURING AN INCIDENT

Clear roles prevent chaos during high-pressure incidents.

| Role | Responsibility |
|------|---------------|
| **Incident Commander (IC)** | Runs the incident. Makes decisions. Delegates tasks. Does NOT do technical work. |
| **Technical Lead** | Investigates the cause and implements the fix. Reports to IC. |
| **Communications Lead** | Posts status updates. Handles stakeholder questions so engineers can focus. |
| **Scribe** | Documents everything in real time — what was tried, what worked, timeline of events. |

**The Incident Commander rule:**
The IC does not touch the keyboard. Their job is to coordinate the team, make decisions, and ensure communication flows. The moment the IC starts debugging, nobody is in charge.

### Role play activity (15 minutes)

Assign four participants the four roles. Give them this scenario:

> *It is 3:15pm on a Friday. ATM transactions start failing at 40% error rate. Prometheus alert fires. You have 30 minutes to resolve it before end-of-business.*

Run the simulation. Debrief: what worked? What was chaotic?

---

## SECTION 3 — BLAMELESS POST-MORTEMS

### What is a post-mortem?

A post-mortem is a written document that the team produces after every significant incident. It answers:
- What happened?
- Why did it happen?
- How did we respond?
- What are we going to do to prevent it happening again?

### What does "blameless" mean?

Blameless means: **we do not name and blame individuals.** We investigate systems, processes, and decisions — not people.

**Why this matters:**

If engineers fear being blamed for incidents:
- They hide problems instead of reporting them
- They avoid making changes because every change is a risk to their career
- The real cause (always a system problem) never gets fixed
- The same incident happens again

If engineers know incidents are investigated without blame:
- They report problems immediately
- They are honest in post-mortems about what went wrong
- The team fixes the actual root cause
- The system gets better after every incident

**The key insight:** When something breaks, ask "what in our system allowed this to happen?" not "who did this?"

---

### Post-mortem template

```markdown
# Incident Post-Mortem
**Date:** 2026-02-23
**Severity:** SEV 2
**Duration:** 32 minutes (14:32 – 15:04)
**Author:** [Your name]
**Reviewers:** SRE Team Lead, Engineering Manager

---

## Summary
Brief description of the incident and its impact in 2–3 sentences.

## Impact
- Users affected: approximately 12,000
- Transactions failed: 847
- Financial impact: estimated NGN 2.3M in failed transfers
- SLO impact: 32 minutes consumed from monthly error budget (budget remaining: 11 minutes)

## Timeline
| Time | Event |
|------|-------|
| 14:32 | Alert fires: MobileTransferErrorRate > 5% |
| 14:35 | On-call engineer acknowledges alert |
| 14:38 | Incident opened at SEV 2, IC assigned |
| 14:48 | Root cause identified: database connection pool exhausted |
| 14:52 | Connection pool limit increased from 50 to 200 |
| 14:55 | Error rate begins dropping |
| 15:01 | Error rate returns to normal |
| 15:04 | Incident resolved after 30-minute observation period |

## Root Cause
The database connection pool was configured with a maximum of 50 connections.
A marketing campaign launched at 14:00 caused a 3x spike in mobile banking traffic.
When connections were exhausted, new transfer requests failed immediately.
The original limit was set during initial deployment and was never reviewed as traffic grew.

## Contributing Factors
- No capacity review had been conducted in 6 months
- The connection pool limit was not monitored or alerted on
- Traffic from marketing campaigns was not communicated to the SRE team in advance

## What Went Well
- Alert fired automatically within 3 minutes of the incident starting
- On-call engineer responded quickly
- Root cause was identified within 13 minutes
- Fix was straightforward once the cause was found

## What Went Poorly
- No runbook existed for database connection pool exhaustion
- Communication lead was not engaged until 20 minutes into the incident
- Status updates to stakeholders were delayed

## Action Items
| Action | Owner | Due Date |
|--------|-------|----------|
| Increase connection pool limit to 200 and add auto-scaling | Database team | 2026-03-01 |
| Add alert for connection pool utilisation above 70% | SRE team | 2026-02-28 |
| Write runbook for connection pool exhaustion | On-call engineer | 2026-02-28 |
| Create process for marketing to notify SRE of campaign launches | Engineering Manager | 2026-03-07 |
| Schedule quarterly capacity reviews | SRE Team Lead | 2026-03-01 |
```

---

## SECTION 4 — CHAOS ENGINEERING

### What is chaos engineering?

Chaos engineering is the practice of **deliberately introducing failures into a system** in a controlled way to discover weaknesses before real failures expose them to users.

> *"If your system can handle failures in testing, it will handle them in production."*

### The origin

Netflix invented chaos engineering with a tool called **Chaos Monkey** — software that randomly shut down servers in their production environment during business hours. The idea: if it can happen accidentally, let's make it happen on purpose when we are watching and ready to respond.

### Why banks should do this

Banks often discover their disaster recovery does not work during an actual disaster. Chaos engineering lets you find out during a planned test instead.

**Common chaos experiments for banking:**

| Experiment | What It Tests |
|-----------|--------------|
| Kill the primary database | Does the failover to secondary work? How long does it take? |
| Increase network latency to 500ms | Does the mobile app handle slow connections gracefully? |
| Fill disk space on a server to 95% | What happens to log collection and the application? |
| Kill one instance of the transfer service | Does load balancing redirect traffic automatically? |
| Simulate a CBN API timeout | Does the system queue the request or fail the transaction? |

### How to run a chaos experiment

Always follow this structure:

```
1. HYPOTHESIS — Define what you expect to happen
   "If we kill the primary database, the failover should complete in under 30 seconds 
    and no transactions should be lost."

2. BLAST RADIUS — Limit the scope
   "We will only run this experiment in the staging environment, 
    between 10am and 11am on a Tuesday."

3. RUN THE EXPERIMENT — Introduce the failure
   Stop the primary database service.

4. OBSERVE — Watch what actually happens
   Time the failover. Count any failed transactions. 
   Check if monitoring detected the failure.

5. DOCUMENT — Record what you learned
   "Failover completed in 47 seconds. 3 in-flight transactions were lost. 
    SLO impact: X seconds of downtime."

6. FIX — Address what you discovered
   Improve failover speed. Add transaction retry logic.
```

### Simple chaos demo

```bash
# Simulate a service crash
docker stop mobile-banking-service

# Watch what happens to error rate in Grafana
# Does the alert fire?
# Does traffic route to backup?

# Bring it back
docker start mobile-banking-service

# How long did recovery take?
```

---

## SECTION 5 — CBN REGULATORY COMPLIANCE IN INCIDENTS

This section is unique to Nigerian banking — teach it carefully.

### CBN requirements

The Central Bank of Nigeria has specific requirements for how banks handle and report system incidents:

1. **Incident notification:** Major incidents affecting core banking or customer funds must be reported to CBN within defined timeframes
2. **Incident records:** Banks must maintain logs of all incidents, responses, and resolutions
3. **Recovery Time Objective (RTO):** Some systems have CBN-mandated recovery times
4. **Recovery Point Objective (RPO):** Maximum acceptable data loss, defined by regulation for certain transaction types
5. **Audit trails:** All incident response actions must be logged and available for CBN examination

### How SRE practices support compliance

| SRE Practice | How It Satisfies CBN Requirements |
|-------------|----------------------------------|
| Post-mortems | Provides documented incident records for audit |
| Incident timeline (scribe) | Provides exact sequence of events for reporting |
| Monitoring and alerting | Demonstrates proactive system oversight |
| Chaos engineering | Demonstrates tested disaster recovery capability |
| SLO tracking | Provides evidence of reliability management |

**Key point for students:** Everything you document during an incident — timeline, actions taken, root cause, fixes — can and should be used for CBN reporting. Good SRE documentation is also good compliance documentation.

---

## SECTION 6 — FULL INCIDENT SIMULATION (30 MINUTES)

### Scenario: "The Friday Afternoon Disaster"

> *It is 4:00pm on Friday 28 February 2026. An alert fires:*
>
> **CRITICAL: ATM_NETWORK_DOWN — 0% of ATM transactions succeeding**
>
> *All 47 Union Bank ATMs across Lagos are offline. End-of-month salary payments are due today. Branches are closing in 1 hour. Social media is already active with complaints.*

**Assign roles:** Incident Commander, Technical Lead, Communications Lead, Scribe

**Give them 20 minutes to:**
1. Triage the incident (what is the severity?)
2. Assign tasks
3. Draft three status updates (at 5 min, 10 min, and 15 min)
4. Identify two possible causes to investigate
5. Decide: do you escalate to the CTO?

**Debrief (10 minutes):**
- What decisions did the IC make?
- Was communication clear?
- What information did you wish you had?
- What would you add to the runbook after this?

---

## SECTION 7 — RECAP & LEARNING OBJECTIVES CHECK

- [ ] Can you name the 5 stages of the incident lifecycle?
- [ ] Can you explain the four roles during an incident?
- [ ] Can you explain what a blameless post-mortem is and why blameless matters?
- [ ] Can you write the key sections of a post-mortem?
- [ ] Can you explain what chaos engineering is and name two banking experiments?
- [ ] Can you explain how SRE practices support CBN compliance?

---

## KEY TERMS — MODULE 5

| Term | Definition |
|------|-----------|
| **Incident** | Any event that disrupts or degrades a service users depend on |
| **Triage** | Assessing an incident's severity and deciding what to address first |
| **Mitigation** | Stopping users from being affected, before fixing the root cause |
| **Post-mortem** | Written review of an incident focused on learning, not blame |
| **Blameless** | Investigating systems and processes rather than punishing individuals |
| **Incident Commander** | The person who runs the incident response — coordinates, does not debug |
| **Chaos Engineering** | Deliberately introducing failures to discover weaknesses before users do |
| **RTO** | Recovery Time Objective — maximum acceptable time to restore a service |
| **RPO** | Recovery Point Objective — maximum acceptable data loss in time |
| **Blast Radius** | The scope of impact of a chaos experiment or a real failure |

---

## FURTHER READING — MODULE 5

- [Google SRE Book, Chapter 14 — Managing Incidents](https://sre.google/sre-book/managing-incidents/)
- [Google SRE Book, Chapter 15 — Postmortem Culture](https://sre.google/sre-book/postmortem-culture/)
- [Chaos Engineering Principles](https://principlesofchaos.org/)
