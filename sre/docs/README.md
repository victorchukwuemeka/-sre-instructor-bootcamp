# SRE Training — Course Materials

This directory contains the student-facing materials for the NIIT Fortesoft SRE training course.

## Structure

```
docs/
├── index.md                                      # Course homepage
├── README.md                                     # This file
├── 01_Module_1_Intro_to_SRE.md                   # Module 1
├── 02_Module_2_Service_Level_Management.md       # Module 2
├── 03_Module_3_Toil_and_Automation.md            # Module 3
├── 04_Module_4_Monitoring_Observability.md       # Module 4
├── 05_Module_5_Incident_Management.md            # Module 5
├── 06_Module_6_Advanced_SRE_Capstone.md          # Module 6
└── sre-labs/                                     # Lab exercises
    ├── 01-sli-slo/
    ├── 02-toil-automation/
    ├── 03-monitoring/
    ├── 04-incident/
    └── 05-k8s/
```

## Serving the Documentation

```bash
# Install mkdocs and material theme
pip install mkdocs mkdocs-material

# Serve locally
mkdocs serve

# Build static site
mkdocs build
```
