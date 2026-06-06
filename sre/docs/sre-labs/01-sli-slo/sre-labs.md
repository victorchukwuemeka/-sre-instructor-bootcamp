# Lab 1: SLI/SLO/Error Budget Calculator

## Objective

Build an SLO calculator tool that can compute error budgets, track consumption, and generate burn rate alerts.

## Part 1 — Basic Error Budget Calculator

Run the provided script:

```bash
python3 availability_calc.py
```

**Extend it:** Modify the script to accept SLO percentage and window length as command-line arguments.

```python
# Example usage:
# python3 availability_calc.py --slo 99.9 --window 30
```

## Part 2 — Burn Rate Calculator

Write a script that:
1. Accepts simulated incident data (start time, end time, date)
2. Computes the burn rate for each incident
3. Determines which burn rate alert window would have fired (1h, 6h, 3d, 30d)
4. Outputs the remaining budget

```python
# Sample incident data
incidents = [
    {"date": "2026-06-01", "start": "09:00", "end": "09:15", "description": "DB restart"},
    {"date": "2026-06-03", "start": "14:30", "end": "14:52", "description": "Network issue"},
    {"date": "2026-06-15", "start": "08:00", "end": "08:30", "description": "Bad deployment"},
]
```

## Part 3 — Challenge: Multi-Service Composite SLO

A mobile transfer request depends on 4 services:
- API Gateway (SLO 99.99%)
- Auth Service (SLO 99.99%)
- Core Banking API (SLO 99.95%)
- SMS Service (SLO 99.9%)

Write a function that:
1. Calculates the composite SLO
2. Computes the monthly error budget for the composite
3. Given a set of per-service incidents, determines which service is the weakest link
4. Suggests which service to invest in for the best reliability improvement
