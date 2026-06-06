# Lab 4: Incident Response & Chaos Engineering

## Objective

Run a full incident response simulation with ICS roles, then execute a chaos experiment.

## Part 1 — ICS Role Play

**Scenario:** It's 4pm Friday. Alert fires: ATM_NETWORK_DOWN — 0% success rate. 47 ATMs offline in Lagos.

**Setup:**
1. Assign four roles: IC, Tech Lead, Comms Lead, Scribe
2. The IC runs the response for 15 minutes
3. Every 5 minutes, the IC must provide a status update
4. The Scribe documents the timeline

**Debrief questions:**
- Did the IC touch the keyboard?
- Were stakeholder updates regular?
- What information was missing?
- At what point should escalation happen?

## Part 2 — Chaos Experiment

Run the chaos kill script:

```bash
bash chaos_kill.sh
```

This simulates a service crash. Observe what happens.

**Extended experiment:** Modify the script to:

1. Kill and restart in a loop (3 times)
2. Log each kill/restart event with timestamps
3. After the 3rd restart, check if the auto-restart mechanism (systemd/Docker restart policy) would handle it
4. Determine: in a real production system, what should prevent this from causing an SLO violation?

## Part 3 — Write a Post-Mortem

Using the template, write a post-mortem for the following scenario:

```
A marketing campaign launched at 14:00 without notifying SRE.
Traffic spiked 3x. Database connection pool (max 50) hit zero available connections.
Transfer API returned 503 errors for 12 minutes beginning at 14:32.
12,000 users affected. 847 transfers failed.
Connection pool increased to 200 at 14:44.
Error rate returned to normal at 14:52.
```

Include: timeline, root cause (5 Whys), contributing factors, action items with owners and dates.

## Part 4 — Challenge: Design a Game Day

Plan a Game Day for the ATM Network. Document:
1. **Hypothesis** — what do you expect to happen?
2. **Blast radius** — what's affected, what's off limits?
3. **Experiment** — what failure will you introduce?
4. **Success criteria** — how will you know it passed?
5. **Rollback plan** — how do you stop if it goes wrong?
