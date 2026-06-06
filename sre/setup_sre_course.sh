#!/bin/bash

# SRE Course Folder Setup
# Run this once: bash setup_sre_course.sh

BASE="$HOME/SRE-Course-NIIT"

folders=(
  "00_Master_Materials"
  "01_Module_1_Intro_to_SRE/slides"
  "01_Module_1_Intro_to_SRE/handouts"
  "01_Module_1_Intro_to_SRE/activities"
  "01_Module_1_Intro_to_SRE/notes"
  "02_Module_2_Service_Level_Management/slides"
  "02_Module_2_Service_Level_Management/handouts"
  "02_Module_2_Service_Level_Management/activities"
  "02_Module_2_Service_Level_Management/notes"
  "03_Module_3_Toil_and_Automation/slides"
  "03_Module_3_Toil_and_Automation/handouts"
  "03_Module_3_Toil_and_Automation/activities"
  "03_Module_3_Toil_and_Automation/scripts"
  "04_Module_4_Monitoring_Observability/slides"
  "04_Module_4_Monitoring_Observability/handouts"
  "04_Module_4_Monitoring_Observability/activities"
  "04_Module_4_Monitoring_Observability/dashboards"
  "05_Module_5_Incident_Management/slides"
  "05_Module_5_Incident_Management/handouts"
  "05_Module_5_Incident_Management/activities"
  "05_Module_5_Incident_Management/templates"
  "06_Module_6_Advanced_SRE_Capstone/slides"
  "06_Module_6_Advanced_SRE_Capstone/handouts"
  "06_Module_6_Advanced_SRE_Capstone/activities"
  "06_Module_6_Advanced_SRE_Capstone/student_projects"
  "99_Resources_and_Answers/answer_keys"
  "99_Resources_and_Answers/student_handouts"
  "99_Resources_and_Answers/reference_links"
)

for folder in "${folders[@]}"; do
  mkdir -p "$BASE/$folder"
done

echo "✅ SRE Course folder created at $BASE"
