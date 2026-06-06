# Lab 2: Toil Elimination & Automation

## Objective

Build automation tools that replace common toil tasks and implement a self-healing pattern.

## Part 1 — Database Health Check

Run the provided script:

```bash
python3 db_health_check.py
```

**Extend it:** Add the following capabilities:
1. Accept multiple hosts from a JSON config file
2. Implement retry logic (3 attempts with 5-second backoff)
3. Log results to a file with timestamps
4. Send a Slack/HTTP webhook notification on failure

## Part 2 — Self-Healing Script

Write a script that:
1. Checks if a service is running (simulate with a local port)
2. If not running, attempts to restart it
3. Verifies the restart succeeded
4. If restart fails, escalates by writing to a log file
5. Implements a circuit breaker — if restart fails 3 times in 10 minutes, stop trying

## Part 3 — Challenge: Automation ROI Calculator

Write a script that calculates the return on investment for automating a toil task:

```python
def calculate_roi(task_name: str, 
                  frequency_per_week: int, 
                  time_per_task_minutes: int,
                  engineer_hourly_cost: float,
                  implementation_hours: int):
    """
    Calculate the ROI of automating a toil task.
    
    Returns: weekly_hours_saved, weekly_cost_saved, 
             break_even_weeks, annual_savings
    """
    pass

# Example:
# calculate_roi("Manual DB Restart", 
#               frequency_per_week=5, 
#               time_per_task_minutes=15,
#               engineer_hourly_cost=5000,  # NGN
#               implementation_hours=8)
```

Given real toil data from your team, calculate:
- Which automation has the fastest break-even?
- Which has the highest annual savings?
- What's the total ROI of automating all 5 items?

## Part 4 — Policy-as-Code (OPA)

Write a Rego policy that allows deployments only when:
- Error budget >= 20% remaining
- No SEV-1 incidents open
- The deployer is in the approved list
